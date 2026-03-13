import 'package:oneanime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/download/download_controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class BangumiPanel extends StatelessWidget {
  const BangumiPanel({
    super.key,
    required this.title,
    required this.episodeLength,
    this.episodes,
    required this.currentEpisode,
    required this.onChangeEpisode,
    this.animeLink,
    this.tokens,
  });

  final String title;
  final int episodeLength;
  final List<int>? episodes;
  final int currentEpisode;
  final Future<void> Function(int episode) onChangeEpisode;
  final int? animeLink;
  final List<String>? tokens;

  void _showEpisodePickerDialog(
    BuildContext context,
    Translations i18n,
    List<int> episodeItems,
  ) {
    final size = MediaQuery.sizeOf(context);
    final dialogWidth = (size.width * 0.95).clamp(320.0, 760.0);
    final dialogHeight = (size.height * 0.7).clamp(240.0, 640.0);
    SmartDialog.show(
      useAnimation: false,
      builder: (context) {
        return AlertDialog(
          title: Text(i18n.video.changeEpisode),
          content: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.8,
              ),
              itemCount: episodeItems.length,
              itemBuilder: (BuildContext context, int idx) {
                final episode = episodeItems[idx];
                final isCurrent = episode == currentEpisode;
                final label = i18n.toast.currentEpisode(episode: episode.toString());
                if (isCurrent) {
                  return FilledButton(
                    onPressed: () => SmartDialog.dismiss(),
                    child: Text(label),
                  );
                }
                return FilledButton.tonal(
                  onPressed: () async {
                    await onChangeEpisode(episode);
                    SmartDialog.dismiss();
                  },
                  child: Text(label),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Translations i18n = Translations.of(context);
    final ScrollController listViewScrollCtr = ScrollController();
    final DownloadController downloadController = Modular.get<DownloadController>();
    final List<int> episodeItems =
        episodes ?? List<int>.generate(episodeLength, (i) => i + 1);
    final int totalCount = episodeItems.length;

    return Expanded(
      child: Column(
        children: [
          !Utils.isCompact()
              ? const SizedBox(height: 7)
              : Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 6, left: 8, right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(i18n.video.collection),
                      Expanded(
                        child: Text(
                          i18n.video.playingCollection(title: title),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 38,
                        child: FilledButton.tonalIcon(
                          onPressed: () =>
                              _showEpisodePickerDialog(context, i18n, episodeItems),
                          icon: const Icon(Icons.grid_view, size: 18),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          label: Text(
                            i18n.video.episodeTotal(total: totalCount),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          Expanded(
            // width: Platform.isWindows ? 300: null,
            child: Padding(
              padding: !Utils.isCompact() ? const EdgeInsets.only(left: 0, right: 0) : const EdgeInsets.only(left: 8.0, right: 8.0),
              child: GridView.builder(
                controller: listViewScrollCtr,
                scrollDirection: Axis.vertical, // 将滚动方向改为竖直
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                      Utils.isCompact() ? 180 : (Utils.isTablet() ? 220 : 240),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3.1,
                ),
                itemCount: episodeItems.length,
                itemBuilder: (BuildContext context, int i) {
                  final episode = episodeItems[i];
                  
                  return Observer(builder: (context) {
                    final isDownloaded = animeLink != null && 
                        downloadController.isEpisodeDownloaded(animeLink!, episode);
                    final task = animeLink != null ? 
                        downloadController.getTaskForEpisode(animeLink!, episode) : null;
                    
                    return Container(
                      // width: 150,
                      margin: const EdgeInsets.only(bottom: 10), // 改为bottom间距
                      child: Material(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        borderRadius: BorderRadius.circular(6),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () {
                            onChangeEpisode(episode);
                          },
                          onLongPress: animeLink != null && tokens != null && episode <= tokens!.length
                              ? () {
                                  _showDownloadMenu(
                                    context,
                                    downloadController,
                                    episode,
                                    isDownloaded,
                                    task,
                                    i18n,
                                  );
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              children: [
                                // Episode label column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          if (episode == currentEpisode) ...<Widget>[
                                            Image.asset(
                                              'assets/images/live.png',
                                              color:
                                                  Theme.of(context).colorScheme.primary,
                                              height: 12,
                                            ),
                                            const SizedBox(width: 6)
                                          ],
                                          Expanded(
                                            child: Text(
                                              i18n.toast.currentEpisode(episode: episode),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: episode == currentEpisode
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurface),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Status indicator (small icon below text)
                                      if (isDownloaded || (task != null && task.isDownloading))
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: isDownloaded
                                              ? Icon(
                                                  Icons.download_done,
                                                  size: 14,
                                                  color: Theme.of(context).colorScheme.primary,
                                                )
                                              : SizedBox(
                                                  width: 14,
                                                  height: 14,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    value: task!.progress > 0 ? task.progress : null,
                                                  ),
                                                ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Download action button - 48x48 tap target for mobile
                                if (animeLink != null && tokens != null && episode <= tokens!.length)
                                  SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(12),
                                      icon: Icon(
                                        _getDownloadIcon(isDownloaded, task),
                                        size: 20,
                                      ),
                                      color: Theme.of(context).colorScheme.primary,
                                      onPressed: () => _handleDownloadTap(
                                        context,
                                        downloadController,
                                        episode,
                                        isDownloaded,
                                        task,
                                        i18n,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  IconData _getDownloadIcon(bool isDownloaded, dynamic task) {
    if (isDownloaded) {
      return Icons.download_done;
    } else if (task != null && task.isDownloading) {
      return Icons.downloading;
    } else if (task != null && (task.isPaused || task.isFailed)) {
      return Icons.download;
    } else if (task != null && task.isQueued) {
      return Icons.schedule;
    }
    return Icons.download;
  }

  void _handleDownloadTap(
    BuildContext context,
    DownloadController downloadController,
    int episode,
    bool isDownloaded,
    dynamic task,
    Translations i18n,
  ) {
    if (animeLink == null || tokens == null || episode > tokens!.length) return;

    // Hybrid behavior: if not downloaded and no task, start download directly
    if (!isDownloaded && task == null) {
      final token = tokens![tokens!.length - episode];
      downloadController.enqueueEpisode(
        link: animeLink!,
        title: title,
        episode: episode,
        token: token,
      ).then((result) {
        SmartDialog.showToast(result);
      });
    } else {
      // Otherwise, show the action menu
      _showDownloadMenu(
        context,
        downloadController,
        episode,
        isDownloaded,
        task,
        i18n,
      );
    }
  }

  void _showDownloadMenu(
    BuildContext context,
    DownloadController downloadController,
    int episode,
    bool isDownloaded,
    dynamic task,
    Translations i18n,
  ) {
    if (animeLink == null || tokens == null || episode > tokens!.length) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isDownloaded && task == null)
                ListTile(
                  leading: const Icon(Icons.download),
                  title: Text('Download Episode $episode'),
                  onTap: () async {
                    Navigator.pop(context);
                    final token = tokens![tokens!.length - episode];
                    final result = await downloadController.enqueueEpisode(
                      link: animeLink!,
                      title: title,
                      episode: episode,
                      token: token,
                    );
                    SmartDialog.showToast(result);
                  },
                ),
              if (task != null && task.isDownloading)
                ListTile(
                  leading: const Icon(Icons.pause),
                  title: Text(i18n.my.downloads.pause),
                  onTap: () {
                    Navigator.pop(context);
                    downloadController.pauseTask(task);
                  },
                ),
              if (task != null && (task.isPaused || task.isFailed))
                ListTile(
                  leading: const Icon(Icons.play_arrow),
                  title: Text(i18n.my.downloads.resume),
                  onTap: () {
                    Navigator.pop(context);
                    downloadController.resumeTask(task);
                  },
                ),
              if (isDownloaded)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(i18n.my.downloads.delete),
                  onTap: () {
                    Navigator.pop(context);
                    downloadController.deleteTask(task);
                    SmartDialog.showToast('Download deleted');
                  },
                ),
              if (task != null && !isDownloaded)
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: Text(i18n.my.downloads.cancel),
                  onTap: () {
                    Navigator.pop(context);
                    downloadController.cancelTask(task);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
