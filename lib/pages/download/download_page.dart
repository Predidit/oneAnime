import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/pages/download/download_controller.dart';
import 'package:oneanime/bean/download/download_task.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:oneanime/i18n/strings.g.dart';
import 'package:oneanime/utils/utils.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  late Translations i18n;
  final DownloadController downloadController = Modular.get<DownloadController>();
  final VideoController videoController = Modular.get<VideoController>();
  final PopularController popularController = Modular.get<PopularController>();

  @override
  void initState() {
    super.initState();
    downloadController.init();
  }

  void _showDeleteDialog(DownloadTask task) {
    SmartDialog.show(
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (context) {
        return AlertDialog(
          title: Text(i18n.my.downloads.confirmDelete),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: Text(
                i18n.dialog.dismiss,
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () {
                downloadController.deleteTask(task);
                SmartDialog.dismiss();
              },
              child: Text(i18n.my.downloads.delete),
            ),
          ],
        );
      },
    );
  }

  void _showClearCompletedDialog() {
    SmartDialog.show(
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (context) {
        return AlertDialog(
          title: Text(i18n.my.downloads.confirmClearCompleted),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: Text(
                i18n.dialog.dismiss,
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () {
                downloadController.clearCompleted();
                SmartDialog.dismiss();
              },
              child: Text(i18n.my.downloads.clearCompleted),
            ),
          ],
        );
      },
    );
  }

  Future<void> _playDownloadedEpisode(DownloadTask task) async {
    SmartDialog.showLoading(msg: i18n.toast.loading);
    try {
      // Set video controller state for offline playback
      videoController.link = task.link!;
      videoController.title = task.title!;
      videoController.episode = task.episode!;
      videoController.videoUrl = task.savePath!;
      videoController.videoCookie = '';
      videoController.offset = 0;
      
      // Try to get anime info
      final animeInfo = popularController.lookupAnime(task.title ?? "");
      videoController.follow = animeInfo?.follow ?? false;
      
      SmartDialog.dismiss();
      Modular.to.pushNamed('/video/');
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast('Failed to play: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    i18n = Translations.of(context);
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: SysAppBar(title: Text(i18n.my.downloads.title)),
        body: Observer(builder: (context) {
          if (downloadController.tasks.isEmpty) {
            return Center(
              child: Text(
                i18n.my.downloads.empty,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: downloadController.tasks.length,
            itemBuilder: (context, index) {
              final task = downloadController.tasks[index];
              return _buildTaskItem(task);
            },
          );
        }),
        floatingActionButton: Observer(builder: (context) {
          final hasCompleted = downloadController.tasks.any((t) => t.isCompleted);
          if (!hasCompleted) return const SizedBox();

          return FloatingActionButton.extended(
            onPressed: _showClearCompletedDialog,
            icon: const Icon(Icons.clear_all),
            label: Text(i18n.my.downloads.clearCompleted),
          );
        }),
      ),
    );
  }

  Widget _buildTaskItem(DownloadTask task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and episode
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        i18n.toast.currentEpisode(episode: task.episode.toString()),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(task),
              ],
            ),
            
            // Progress bar for downloading tasks
            if (task.isDownloading || task.isQueued) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: task.progress > 0 ? task.progress : null,
              ),
              const SizedBox(height: 4),
              Text(
                _formatProgress(task),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
            
            // Error message for failed tasks
            if (task.isFailed && task.error != null) ...[
              const SizedBox(height: 8),
              Text(
                task.error!,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.error,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            // Action buttons
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _buildActionButtons(task),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(DownloadTask task) {
    String label;
    Color? backgroundColor;
    Color? textColor;

    if (task.isCompleted) {
      label = i18n.my.downloads.completed;
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
      textColor = Theme.of(context).colorScheme.onPrimaryContainer;
    } else if (task.isDownloading) {
      label = i18n.my.downloads.downloading;
      backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
      textColor = Theme.of(context).colorScheme.onSecondaryContainer;
    } else if (task.isQueued) {
      label = i18n.my.downloads.queued;
      backgroundColor = Theme.of(context).colorScheme.tertiaryContainer;
      textColor = Theme.of(context).colorScheme.onTertiaryContainer;
    } else if (task.isPaused) {
      label = i18n.my.downloads.paused;
      backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      textColor = Theme.of(context).colorScheme.onSurface;
    } else {
      label = i18n.my.downloads.failed;
      backgroundColor = Theme.of(context).colorScheme.errorContainer;
      textColor = Theme.of(context).colorScheme.onErrorContainer;
    }

    return Chip(
      label: Text(label),
      backgroundColor: backgroundColor,
      labelStyle: TextStyle(color: textColor, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  List<Widget> _buildActionButtons(DownloadTask task) {
    List<Widget> buttons = [];

    if (task.isCompleted) {
      buttons.add(
        TextButton.icon(
          onPressed: () => _playDownloadedEpisode(task),
          icon: const Icon(Icons.play_arrow, size: 18),
          label: Text(i18n.my.downloads.play),
        ),
      );
      buttons.add(const SizedBox(width: 8));
      buttons.add(
        TextButton.icon(
          onPressed: () => _showDeleteDialog(task),
          icon: const Icon(Icons.delete, size: 18),
          label: Text(i18n.my.downloads.delete),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    } else if (task.isDownloading) {
      buttons.add(
        TextButton.icon(
          onPressed: () => downloadController.pauseTask(task),
          icon: const Icon(Icons.pause, size: 18),
          label: Text(i18n.my.downloads.pause),
        ),
      );
      buttons.add(const SizedBox(width: 8));
      buttons.add(
        TextButton.icon(
          onPressed: () => downloadController.cancelTask(task),
          icon: const Icon(Icons.close, size: 18),
          label: Text(i18n.my.downloads.cancel),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    } else if (task.isPaused) {
      buttons.add(
        TextButton.icon(
          onPressed: () => downloadController.resumeTask(task),
          icon: const Icon(Icons.play_arrow, size: 18),
          label: Text(i18n.my.downloads.resume),
        ),
      );
      buttons.add(const SizedBox(width: 8));
      buttons.add(
        TextButton.icon(
          onPressed: () => downloadController.cancelTask(task),
          icon: const Icon(Icons.close, size: 18),
          label: Text(i18n.my.downloads.cancel),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    } else if (task.isFailed) {
      buttons.add(
        TextButton.icon(
          onPressed: () => downloadController.retryTask(task),
          icon: const Icon(Icons.refresh, size: 18),
          label: Text(i18n.my.downloads.retry),
        ),
      );
      buttons.add(const SizedBox(width: 8));
      buttons.add(
        TextButton.icon(
          onPressed: () => downloadController.cancelTask(task),
          icon: const Icon(Icons.close, size: 18),
          label: Text(i18n.my.downloads.cancel),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    } else if (task.isQueued) {
      buttons.add(
        TextButton.icon(
          onPressed: () => downloadController.cancelTask(task),
          icon: const Icon(Icons.close, size: 18),
          label: Text(i18n.my.downloads.cancel),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    }

    return buttons;
  }

  String _formatProgress(DownloadTask task) {
    final received = task.receivedBytes ?? 0;
    final total = task.totalBytes ?? 0;
    
    if (total == 0) return 'Waiting...';
    
    final receivedMB = received / (1024 * 1024);
    final totalMB = total / (1024 * 1024);
    final percentage = (task.progress * 100).toStringAsFixed(1);
    
    return '${receivedMB.toStringAsFixed(1)} MB / ${totalMB.toStringAsFixed(1)} MB ($percentage%)';
  }
}

