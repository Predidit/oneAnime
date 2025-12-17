import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:oneanime/bean/download/download_task.dart' as local;
import 'package:oneanime/bean/download/download_anime.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:oneanime/utils/utils.dart';
import 'package:oneanime/request/video.dart';
import 'package:oneanime/utils/constans.dart';

part 'download_controller.g.dart';

class DownloadController = _DownloadController with _$DownloadController;

abstract class _DownloadController with Store {
  bool _initialized = false;
  StreamSubscription<TaskUpdate>? _updateSubscription;
  
  @observable
  ObservableList<local.DownloadTask> tasks = ObservableList<local.DownloadTask>.of([]);
  
  @observable
  local.DownloadTask? currentDownloading;
  
  @observable
  bool isProcessing = false;

  _DownloadController() {
    // Auto-initialize on first access
    init();
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    
    try {
      // Initialize FileDownloader with background support
      await FileDownloader().start(doRescheduleKilledTasks: true);
      await FileDownloader().trackTasks();
      
      // Configure for Android foreground mode to improve survival
      if (Platform.isAndroid) {
        await FileDownloader().configure(globalConfig: [
          (Config.runInForeground, Config.whenAble),
        ]);
      }
      
      // Configure notifications
      FileDownloader().configureNotification(
        running: const TaskNotification('Downloading', 'Episode {filename}'),
        complete: const TaskNotification('Download complete', '{filename}'),
        progressBar: true,
      );
      
      // Subscribe to updates
      _updateSubscription = FileDownloader().updates.listen(_handleUpdate);
      
      // Resume from background if needed
      await FileDownloader().resumeFromBackground();
      
      // Load and reconcile tasks
      await loadTasks();
      await _reconcileTasks();
    } catch (e) {
      debugPrint('DownloadController init error: $e');
    }
  }

  @action
  Future<void> loadTasks() async {
    tasks.clear();
    final allTasks = GStorage.downloadTasks.values.toList();
    tasks.addAll(allTasks);
    // Sort by creation time (newest first)
    tasks.sort((a, b) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0));
  }

  Future<void> _reconcileTasks() async {
    // Reconcile Hive tasks with FileDownloader database
    for (final task in tasks) {
      if (task.isCompleted) continue;
      
      try {
        final record = await FileDownloader().database.recordForId(task.taskId);
        if (record != null) {
          // Update from FileDownloader database
          _syncTaskFromRecord(task, record);
        } else if (task.isDownloading || task.isQueued) {
          // Task was killed, mark as paused for manual retry
          _updateTaskStatus(task, 'paused', error: 'Download interrupted');
        }
      } catch (e) {
        debugPrint('Reconcile error for task ${task.taskId}: $e');
      }
    }
    
    // Clean up orphan .part files
    await _cleanupOrphanPartFiles();
  }

  Future<void> _cleanupOrphanPartFiles() async {
    try {
      final dir = await _getDownloadDirectory();
      final files = dir.listSync();
      
      for (final file in files) {
        if (file is File && file.path.endsWith('.part')) {
          // Check if we have a matching task
          final hasTask = tasks.any((t) => 
            t.savePath != null && file.path.startsWith(t.savePath!.replaceAll('.mp4', '')));
          
          if (!hasTask) {
            // Orphan file, delete it
            try {
              await file.delete();
              debugPrint('Cleaned up orphan file: ${file.path}');
            } catch (e) {
              debugPrint('Failed to delete orphan file: $e');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Cleanup orphan files error: $e');
    }
  }

  void _handleUpdate(TaskUpdate update) {
    switch (update) {
      case TaskStatusUpdate():
        _handleStatusUpdate(update);
        break;
      case TaskProgressUpdate():
        _handleProgressUpdate(update);
        break;
    }
  }

  void _handleStatusUpdate(TaskStatusUpdate update) {
    final task = _findTaskByBgTaskId(update.task.taskId);
    if (task == null) return;
    
    debugPrint('Status update for ${update.task.taskId}: ${update.status}');
    
    switch (update.status) {
      case TaskStatus.enqueued:
        _updateTaskStatus(task, 'queued');
        break;
      case TaskStatus.running:
        _updateTaskStatus(task, 'downloading');
        break;
      case TaskStatus.complete:
        _handleDownloadComplete(task);
        break;
      case TaskStatus.paused:
        _updateTaskStatus(task, 'paused');
        break;
      case TaskStatus.canceled:
        _updateTaskStatus(task, 'paused', error: 'Download canceled');
        break;
      case TaskStatus.failed:
        _updateTaskStatus(task, 'failed', 
          error: update.exception?.toString() ?? 'Download failed');
        break;
      case TaskStatus.notFound:
        _updateTaskStatus(task, 'failed', error: 'File not found');
        break;
      case TaskStatus.waitingToRetry:
        _updateTaskStatus(task, 'queued');
        break;
    }
  }

  void _handleProgressUpdate(TaskProgressUpdate update) {
    final task = _findTaskByBgTaskId(update.task.taskId);
    if (task == null) return;
    
    task.receivedBytes = (update.progress * (task.totalBytes ?? 0)).toInt();
    task.updatedAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    task.save();
    
    // Trigger UI update
    tasks = ObservableList.of(tasks);
  }

  Future<void> _handleDownloadComplete(local.DownloadTask task) async {
    // Rename .part file to final .mp4
    if (task.savePath != null) {
      final partPath = '${task.savePath!}.part';
      final finalPath = task.savePath!;
      
      try {
        final partFile = File(partPath);
        if (await partFile.exists()) {
          await partFile.rename(finalPath);
          debugPrint('Renamed ${partPath} to ${finalPath}');
        }
      } catch (e) {
        debugPrint('Failed to rename file: $e');
      }
    }
    
    _updateTaskStatus(task, 'completed');
    debugPrint('Download completed: ${task.title} Episode ${task.episode}');
  }

  local.DownloadTask? _findTaskByBgTaskId(String bgTaskId) {
    try {
      return tasks.firstWhere((t) => t.taskId == bgTaskId);
    } catch (e) {
      return null;
    }
  }

  void _syncTaskFromRecord(local.DownloadTask task, TaskRecord record) {
    switch (record.status) {
      case TaskStatus.enqueued:
        task.status = 'queued';
        break;
      case TaskStatus.running:
        task.status = 'downloading';
        break;
      case TaskStatus.complete:
        task.status = 'completed';
        break;
      case TaskStatus.paused:
        task.status = 'paused';
        break;
      case TaskStatus.failed:
        task.status = 'failed';
        break;
      default:
        task.status = 'paused';
    }
    
    task.receivedBytes = (record.progress * (record.expectedFileSize ?? 0)).toInt();
    task.totalBytes = record.expectedFileSize ?? 0;
    task.save();
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
      orElse: () => local.DownloadTask(),
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
        tokensJson: '[]',
        episodeTotal: 0,
      );
      await GStorage.downloadAnime.put(animeKey, downloadAnime);
    }

    try {
      // Resolve video URL and cookie BEFORE enqueuing
      debugPrint('Resolving video URL for $title Episode $episode');
      final result = await VideoRequest.getVideoLink(token);
      final videoUrl = result['link'] as String;
      final videoCookie = result['cookie'] as String;

      if (videoUrl.isEmpty) {
        return 'Failed to resolve video URL';
      }

      // Check if URL is HLS (m3u8)
      if (videoUrl.contains('.m3u8')) {
        return 'HLS streaming not supported. Direct file download only.';
      }

      // Create local task
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final userAgent = Utils.getRandomUA();
      final fileName = _generateFileName(title, episode, now);
      final dir = await _getDownloadDirectory();
      final savePath = '${dir.path}/$fileName';
      
      final localTask = local.DownloadTask(
        link: link,
        title: title,
        episode: episode,
        token: token,
        userAgent: userAgent,
        resolvedUrl: videoUrl,
        videoCookie: videoCookie,
        savePath: savePath,
        status: 'queued',
        receivedBytes: 0,
        totalBytes: 0,
        createdAt: now,
        updatedAt: now,
      );

      // Create background_downloader task with .part extension
      final bgTask = DownloadTask(
        taskId: localTask.taskId,
        url: videoUrl,
        filename: '$fileName.part', // Download to .part first
        directory: 'downloads',
        baseDirectory: Platform.isAndroid || Platform.isIOS
            ? BaseDirectory.applicationDocuments
            : BaseDirectory.applicationSupport,
        headers: {
          'user-agent': userAgent,
          'referer': HttpString.baseUrl,
          'Cookie': videoCookie,
        },
        updates: Updates.statusAndProgress,
        allowPause: true,
        metaData: '${link}_$episode',
      );

      // Enqueue with FileDownloader
      final success = await FileDownloader().enqueue(bgTask);
      
      if (success) {
        // Save to Hive
        await GStorage.downloadTasks.put(localTask.taskId, localTask);
        tasks.insert(0, localTask);
        
        return 'Download started';
      } else {
        return 'Failed to enqueue download';
      }
    } catch (e) {
      debugPrint('Enqueue error: $e');
      return 'Error: ${e.toString()}';
    }
  }

  Future<Directory> _getDownloadDirectory() async {
    Directory dir;
    if (Platform.isAndroid || Platform.isIOS) {
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

  String _generateFileName(String? title, int? episode, int timestamp) {
    final sanitizedTitle = title?.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_') ?? 'anime';
    return '${sanitizedTitle}_ep${episode}_$timestamp.mp4';
  }

  void _updateTaskStatus(local.DownloadTask task, String status, {String? error}) {
    task.status = status;
    task.error = error;
    task.updatedAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    task.save();
    // Trigger UI update
    tasks = ObservableList.of(tasks);
  }

  @action
  Future<void> pauseTask(local.DownloadTask task) async {
    try {
      final bgTask = await FileDownloader().database.recordForId(task.taskId);
      if (bgTask != null) {
        await FileDownloader().pause(bgTask.task);
      }
      _updateTaskStatus(task, 'paused');
    } catch (e) {
      debugPrint('Pause error: $e');
    }
  }

  @action
  Future<void> resumeTask(local.DownloadTask task) async {
    if (task.isPaused || task.isFailed) {
      try {
        final bgTask = await FileDownloader().database.recordForId(task.taskId);
        if (bgTask != null) {
          final canResume = await FileDownloader().taskCanResume(bgTask.task);
          if (canResume) {
            await FileDownloader().resume(bgTask.task);
          } else {
            // Re-enqueue if can't resume
            await retryTask(task);
          }
        } else {
          // Task not in FileDownloader, re-enqueue
          await retryTask(task);
        }
      } catch (e) {
        debugPrint('Resume error: $e');
        _updateTaskStatus(task, 'failed', error: e.toString());
      }
    }
  }

  @action
  Future<void> retryTask(local.DownloadTask task) async {
    try {
      // Cancel existing task if any
      await FileDownloader().cancelTaskWithId(task.taskId);
      
      // Re-enqueue
      if (task.resolvedUrl != null) {
        final fileName = _generateFileName(task.title, task.episode, task.createdAt ?? 0);
        
        final bgTask = DownloadTask(
          taskId: task.taskId,
          url: task.resolvedUrl!,
          filename: '$fileName.part',
          directory: 'downloads',
          baseDirectory: Platform.isAndroid || Platform.isIOS
              ? BaseDirectory.applicationDocuments
              : BaseDirectory.applicationSupport,
          headers: {
            'user-agent': task.userAgent ?? Utils.getRandomUA(),
            'referer': HttpString.baseUrl,
            'Cookie': task.videoCookie ?? '',
          },
          updates: Updates.statusAndProgress,
          allowPause: true,
          metaData: '${task.link}_${task.episode}',
        );
        
        await FileDownloader().enqueue(bgTask);
        task.error = null;
        task.receivedBytes = 0;
        _updateTaskStatus(task, 'queued');
      }
    } catch (e) {
      debugPrint('Retry error: $e');
      _updateTaskStatus(task, 'failed', error: e.toString());
    }
  }

  @action
  Future<void> cancelTask(local.DownloadTask task) async {
    try {
      await FileDownloader().cancelTaskWithId(task.taskId);
    } catch (e) {
      debugPrint('Cancel error: $e');
    }
    
    // Delete files
    if (task.savePath != null) {
      try {
        final file = File(task.savePath!);
        if (await file.exists()) {
          await file.delete();
        }
        final partFile = File('${task.savePath!}.part');
        if (await partFile.exists()) {
          await partFile.delete();
        }
      } catch (e) {
        debugPrint('Delete file error: $e');
      }
    }

    // Remove from storage
    await GStorage.downloadTasks.delete(task.taskId);
    tasks.remove(task);
  }

  @action
  Future<void> deleteTask(local.DownloadTask task) async {
    try {
      await FileDownloader().cancelTaskWithId(task.taskId);
    } catch (e) {
      debugPrint('Cancel before delete error: $e');
    }
    
    // Delete files
    if (task.savePath != null) {
      try {
        final file = File(task.savePath!);
        if (await file.exists()) {
          await file.delete();
          debugPrint('Deleted file: ${task.savePath}');
        }
        final partFile = File('${task.savePath!}.part');
        if (await partFile.exists()) {
          await partFile.delete();
        }
      } catch (e) {
        debugPrint('Delete file error: $e');
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
      await deleteTask(task);
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

  void dispose() {
    _updateSubscription?.cancel();
  }
}
