import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/i18n/strings.g.dart';

class BangumiPanel extends StatelessWidget {
  const BangumiPanel({
    super.key,
    required this.title,
    required this.episodeLength,
    required this.currentEpisode,
    required this.onChangeEpisode,
  });

  final String title;
  final int episodeLength;
  final int currentEpisode;
  final Future<void> Function(int episode) onChangeEpisode;

  @override
  Widget build(BuildContext context) {
    final Translations i18n = Translations.of(context);
    final ScrollController listViewScrollCtr = ScrollController();

    return Expanded(
      child: Column(
        children: [
          Platform.isWindows || Platform.isLinux || Platform.isMacOS
              ? const SizedBox(height: 7)
              : Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 6),
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
            child: GridView.builder(
              controller: listViewScrollCtr,
              scrollDirection: Axis.vertical, // 将滚动方向改为竖直
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    Platform.isWindows || Platform.isLinux || Platform.isMacOS
                        ? 10
                        : 3,
                crossAxisSpacing: 10, // 间距
                mainAxisSpacing: 5, // 间距
                childAspectRatio: 1.7, // 子项宽高比
              ),
              itemCount: episodeLength,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  // width: 150,
                  margin: const EdgeInsets.only(bottom: 10), // 改为bottom间距
                  child: Material(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    borderRadius: BorderRadius.circular(6),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () {
                        onChangeEpisode(i + 1);
                      },
                      child: Padding(
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
                                Text(
                                  i18n.toast.currentEpisode(episode: i + 1),
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
                                const SizedBox(width: 2),
                              ],
                            ),
                            const SizedBox(height: 3),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
