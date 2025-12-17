import 'package:oneanime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/i18n/strings.g.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/download/download_controller.dart';

class BangumiPanel extends StatelessWidget {
  const BangumiPanel({
    super.key,
    required this.title,
    required this.episodeLength,
    required this.currentEpisode,
    required this.onChangeEpisode,
    this.animeLink,
    this.tokens,
  });

  final String title;
  final int episodeLength;
  final int currentEpisode;
  final Future<void> Function(int episode) onChangeEpisode;
  final int? animeLink;
  final List<String>? tokens;

  @override
  Widget build(BuildContext context) {
    final Translations i18n = Translations.of(context);
    final ScrollController listViewScrollCtr = ScrollController();
    final DownloadController downloadController = Modular.get<DownloadController>();

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
                        height: 34,
                        child: TextButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                          ),

                          // Todo 展示更多
                          onPressed: () {
                            if (MediaQuery.sizeOf(context).height <
                                MediaQuery.sizeOf(context).width) {
                              SmartDialog.show(
                                  useAnimation: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(i18n.video.changeEpisode),
                                      content: StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return Wrap(
                                          spacing: 8,
                                          runSpacing: 2,
                                          children: [
                                            for (int i = 1;
                                                i <= episodeLength;
                                                i++) ...<Widget>[
                                              if (i ==
                                                  currentEpisode) ...<Widget>[
                                                FilledButton(
                                                  onPressed: () async {
                                                    SmartDialog.dismiss();
                                                  },
                                                  child:
                                                      Text(i18n.toast.currentEpisode(episode: i.toString())),
                                                ),
                                              ] else ...[
                                                FilledButton.tonal(
                                                  onPressed: () async {
                                                    onChangeEpisode(i);
                                                    SmartDialog.dismiss();
                                                  },
                                                  child:
                                                      Text(i18n.toast.currentEpisode(episode: i.toString())),
                                                ),
                                              ]
                                            ]
                                          ],
                                        );
                                      }),
                                    );
                                  });
                            }
                          },
                          child: Text(
                            i18n.video.episodeTotal(total: episodeLength),
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (!Utils.isCompact() && !Utils.isTablet())
                          ? 10
                          : 3,
                  crossAxisSpacing: 10, // 间距
                  mainAxisSpacing: 5, // 间距
                  childAspectRatio: 1.7, // 子项宽高比
                ),
                itemCount: episodeLength,
                itemBuilder: (BuildContext context, int i) {
                  final episode = i + 1;
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
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      if (i == (currentEpisode - 1)) ...<Widget>[
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
                                              color: i == (currentEpisode - 1)
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onSurface),
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      if (isDownloaded)
                                        Icon(
                                          Icons.download_done,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                        )
                                      else if (task != null && task.isDownloading)
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            value: task.progress > 0 ? task.progress : null,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
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
