import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:oneanime/bean/download/download_task.dart';
import 'package:oneanime/bean/download/download_anime.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:oneanime/utils/utils.dart';
import 'package:oneanime/request/video.dart';
import 'package:oneanime/utils/constans.dart';

part 'download_controller.g.dart';

class DownloadController = _DownloadController with _$DownloadController;

abstract class _DownloadController with Store {
  final Dio _dio = Dio();
  CancelToken? _currentCancelToken;
  
  @observable
  ObservableList<DownloadTask> tasks = ObservableList<DownloadTask>.of([]);
  
  @observable
  DownloadTask? currentDownloading;
  
  @observable
  bool isProcessing = false;

  Future<void> init() async {
    await loadTasks();
    // Resume any interrupted downloads
    resumeQueue();
  }

  @action
  Future<void> loadTasks() async {
    tasks.clear();
    final allTasks = GStorage.downloadTasks.values.toList();
    tasks.addAll(allTasks);
    // Sort by creation time (newest first)
    tasks.sort((a, b) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0));
  }

  @action
  Future<String> enqueueEpisode({
    required int link,
    required String title,
    required int episode,
    required String token,
  }) async {
    // Check if task already exists
    final existingTask = tasks.firstWhere(
      (t) => t.link == link && t.episode == episode,
      orElse: () => DownloadTask(),
    );

    if (existingTask.link != null) {
      if (existingTask.isCompleted) {
        return 'Episode already downloaded';
      } else if (existingTask.isDownloading) {
        return 'Episode is currently downloading';
      } else if (existingTask.isQueued) {
        return 'Episode is already in queue';
      } else if (existingTask.isFailed) {
        // Retry failed task
        await retryTask(existingTask);
        return 'Retrying download';
      } else if (existingTask.isPaused) {
        await resumeTask(existingTask);
        return 'Resuming download';
      }
    }

    // Save anime info if not exists
    final animeKey = link.toString();
    if (!GStorage.downloadAnime.containsKey(animeKey)) {
      final downloadAnime = DownloadAnime(
        link: link,
        title: title,
        tokensJson: '[]', // Will be updated when needed
        episodeTotal: 0,
      );
      await GStorage.downloadAnime.put(animeKey, downloadAnime);
    }

    // Create new task
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final task = DownloadTask(
      link: link,
      title: title,
      episode: episode,
      token: token,
      userAgent: Utils.getRandomUA(),
      status: 'queued',
      receivedBytes: 0,
      totalBytes: 0,
      createdAt: now,
      updatedAt: now,
    );

    // Save to hive
    await GStorage.downloadTasks.put(task.taskId, task);
    tasks.insert(0, task);

    // Start processing queue
    processQueue();

    return 'Download queued';
  }

  @action
  Future<void> processQueue() async {
    if (isProcessing) return;
    isProcessing = true;

    try {
      while (true) {
        // Find next queued task
        final nextTask = tasks.firstWhere(
          (t) => t.isQueued,
          orElse: () => DownloadTask(),
        );

        if (nextTask.link == null) break;

        await _downloadTask(nextTask);
      }
    } finally {
      isProcessing = false;
      currentDownloading = null;
    }
  }

  Future<void> _downloadTask(DownloadTask task) async {
    currentDownloading = task;
    _updateTaskStatus(task, 'downloading');

    try {
      // Resolve video URL and cookie
      debugPrint('Resolving video URL for ${task.title} Episode ${task.episode}');
      final result = await VideoRequest.getVideoLink(task.token ?? '');
      final videoUrl = result['link'] as String;
      final videoCookie = result['cookie'] as String;

      if (videoUrl.isEmpty) {
        throw Exception('Failed to resolve video URL');
      }

      task.resolvedUrl = videoUrl;
      task.videoCookie = videoCookie;
      await task.save();

      // Check if URL is HLS (m3u8)
      if (videoUrl.contains('.m3u8')) {
        _updateTaskStatus(task, 'failed', error: 'HLS streaming not supported yet. Direct file download only.');
        return;
      }

      // Prepare save path
      final dir = await _getDownloadDirectory();
      final fileName = _generateFileName(task);
      final savePath = '${dir.path}/$fileName';
      task.savePath = savePath;
      await task.save();

      // Prepare headers
      final headers = {
        'user-agent': task.userAgent ?? Utils.getRandomUA(),
        'referer': HttpString.baseUrl,
        'Cookie': videoCookie,
      };

      // Download file
      _currentCancelToken = CancelToken();
      await _dio.download(
        videoUrl,
        savePath,
        options: Options(headers: headers),
        cancelToken: _currentCancelToken,
        onReceiveProgress: (received, total) {
          task.receivedBytes = received;
          task.totalBytes = total;
          task.updatedAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          task.save();
          // Trigger UI update
          tasks = ObservableList.of(tasks);
        },
      );

      // Verify file exists
      final file = File(savePath);
      if (await file.exists()) {
        _updateTaskStatus(task, 'completed');
        debugPrint('Download completed: ${task.title} Episode ${task.episode}');
      } else {
        throw Exception('Downloaded file not found');
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        _updateTaskStatus(task, 'paused', error: 'Download cancelled');
      } else {
        _updateTaskStatus(task, 'failed', error: e.toString());
      }
      debugPrint('Download error: ${e.toString()}');
    } finally {
      _currentCancelToken = null;
    }
  }

  Future<Directory> _getDownloadDirectory() async {
    Directory dir;
    if (Platform.isAndroid) {
      dir = await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getApplicationSupportDirectory();
    }
    
    final downloadDir = Directory('${dir.path}/downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }

  String _generateFileName(DownloadTask task) {
    final sanitizedTitle = task.title?.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_') ?? 'anime';
    final timestamp = task.createdAt ?? 0;
    return '${sanitizedTitle}_ep${task.episode}_$timestamp.mp4';
  }

  void _updateTaskStatus(DownloadTask task, String status, {String? error}) {
    task.status = status;
    task.error = error;
    task.updatedAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    task.save();
    // Trigger UI update
    tasks = ObservableList.of(tasks);
  }

  @action
  Future<void> pauseTask(DownloadTask task) async {
    if (task.isDownloading && currentDownloading?.taskId == task.taskId) {
      _currentCancelToken?.cancel('User paused');
    }
    _updateTaskStatus(task, 'paused');
  }

  @action
  Future<void> resumeTask(DownloadTask task) async {
    if (task.isPaused || task.isFailed) {
      _updateTaskStatus(task, 'queued');
      processQueue();
    }
  }

  @action
  Future<void> retryTask(DownloadTask task) async {
    task.error = null;
    task.receivedBytes = 0;
    task.totalBytes = 0;
    _updateTaskStatus(task, 'queued');
    processQueue();
  }

  @action
  Future<void> cancelTask(DownloadTask task) async {
    if (task.isDownloading && currentDownloading?.taskId == task.taskId) {
      _currentCancelToken?.cancel('User cancelled');
    }
    
    // Delete file if exists
    if (task.savePath != null) {
      final file = File(task.savePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    // Remove from storage
    await GStorage.downloadTasks.delete(task.taskId);
    tasks.remove(task);
  }

  @action
  Future<void> deleteTask(DownloadTask task) async {
    // Delete file if exists
    if (task.savePath != null) {
      final file = File(task.savePath!);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted file: ${task.savePath}');
      }
    }

    // Remove from storage
    await GStorage.downloadTasks.delete(task.taskId);
    tasks.remove(task);
  }

  @action
  Future<void> clearCompleted() async {
    final completedTasks = tasks.where((t) => t.isCompleted).toList();
    for (final task in completedTasks) {
      // Delete file
      if (task.savePath != null) {
        final file = File(task.savePath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      // Remove from storage
      await GStorage.downloadTasks.delete(task.taskId);
      tasks.remove(task);
    }
  }

  @action
  void resumeQueue() {
    // Resume interrupted downloads
    final downloadingTasks = tasks.where((t) => t.isDownloading).toList();
    for (final task in downloadingTasks) {
      _updateTaskStatus(task, 'queued');
    }
    
    if (downloadingTasks.isNotEmpty) {
      processQueue();
    }
  }

  DownloadTask? getTaskForEpisode(int link, int episode) {
    try {
      return tasks.firstWhere(
        (t) => t.link == link && t.episode == episode,
      );
    } catch (e) {
      return null;
    }
  }

  bool isEpisodeDownloaded(int link, int episode) {
    final task = getTaskForEpisode(link, episode);
    if (task == null) return false;
    if (!task.isCompleted) return false;
    
    // Verify file exists
    if (task.savePath == null) return false;
    final file = File(task.savePath!);
    return file.existsSync();
  }

  String? getLocalPath(int link, int episode) {
    final task = getTaskForEpisode(link, episode);
    if (task == null || !task.isCompleted) return null;
    
    // Verify file exists
    if (task.savePath == null) return null;
    final file = File(task.savePath!);
    if (!file.existsSync()) return null;
    
    return task.savePath;
  }
}

