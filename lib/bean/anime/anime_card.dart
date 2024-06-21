import 'dart:io';

import 'package:oneanime/bean/anime/anime_history.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/menu/side_menu.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:oneanime/pages/history/history_controller.dart';
import 'package:provider/provider.dart';

/// Takes an AnimeInfo object and render it to a card
class AnimeInfoCard extends StatefulWidget {
  const AnimeInfoCard({
    Key? key,
    required this.info,
    required this.index,
    required this.type,
  }) : super(key: key);

  final AnimeInfo info;
  final int index;
  final String type;
  @override
  State<AnimeInfoCard> createState() => _AnimeInfoCardState();
}

class _AnimeInfoCardState extends State<AnimeInfoCard> {
  late bool follow;
  @override
  Widget build(BuildContext context) {
    follow = widget.info.follow ?? false;
    final PopularController popularController =
        Modular.get<PopularController>();
    final VideoController videoController = Modular.get<VideoController>();
    final HistoryController historyController =
        Modular.get<HistoryController>();
    dynamic navigationBarState;

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () async {
          SmartDialog.showLoading(msg: '获取中');
          AnimeHistory? history =
              historyController.lookupHistory(widget.info.link ?? 0);
          if (history == null) {
            historyController.updateHistory(widget.info.link ?? 0, 0);
          } else {
            historyController.updateHistory(
                widget.info.link ?? 0, history.offset ?? 0);
          }
          try {
            debugPrint(
                'AnimeButton is pressed. https://anime1.me/?cat=${widget.info.link}');
            if (widget.info.progress != 1) {
              await popularController.getVideoLink(
                  'https://anime1.me/?cat=${widget.info.link}',
                  episode: widget.info.progress ?? 1);
            } else {
              await popularController
                  .getVideoLink('https://anime1.me/?cat=${widget.info.link}');
            }
            debugPrint(
                'VideoSource resolved success ${videoController.videoUrl}');
            await popularController.getPageTitle(widget.info.name ?? '');
          } catch (e) {
            SmartDialog.dismiss();
            return;
          }
          SmartDialog.dismiss();
          if (widget.info.progress != 1) {
            SmartDialog.showToast('上次观看到第 ${widget.info.progress} 话');
          }
          videoController.from = '/tab/' + widget.type + '/';
          videoController.link = widget.info.link!;
          videoController.offset = history?.offset ?? 0;
          videoController.follow = widget.info.follow ?? false;
          navigationBarState =
              Platform.isWindows || Platform.isLinux || Platform.isMacOS
                  ? Provider.of<SideNavigationBarState>(context, listen: false)
                  : Provider.of<NavigationBarState>(context, listen: false);
          navigationBarState.hideNavigate();
          Modular.to.navigate('/tab/video/');
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width:
                    Platform.isWindows || Platform.isLinux || Platform.isMacOS
                        ? 800
                        : 300,
                child: Text(
                  widget.info.name ?? '',
                  maxLines: 2,
                  softWrap: true,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Wrap(
                      spacing: 8.0,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 4.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            widget.info.episode ?? "77",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.surface),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 4.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            (widget.info.year ?? "2077") +
                                (widget.info.season ?? ""),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.surface),
                          ),
                        ),
                        widget.type == 'popular'
                            ? widget.info.subtitle != ''
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 4.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      widget.info.subtitle ?? "",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface),
                                    ),
                                  )
                                : Container()
                            : Container(
                                margin: const EdgeInsets.only(bottom: 4.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  "已追 ${widget.info.progress ?? 1} 话",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      widget.type == 'history'
                          ? IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                debugPrint(
                                    'Delete history ${widget.info.link}');
                                historyController
                                    .deleteHistory(widget.info.link ?? 0);
                              },
                              splashColor: Theme.of(context)
                                  .colorScheme
                                  .tertiary
                                  .withOpacity(0.5),
                            )
                          : Container(),
                      IconButton(
                        icon: (follow)
                            ? Icon(Icons.favorite,
                                color: Theme.of(context).colorScheme.tertiary)
                            : Icon(Icons.favorite_border,
                                color: Theme.of(context).colorScheme.tertiary),
                        onPressed: () {
                          if (popularController.isLoadingMore == false) {
                            popularController.updateFollow(
                                widget.info.link ?? 19951, !(follow));
                            setState(() {
                              follow = !follow;
                            });
                            SmartDialog.showToast(
                                follow ? '自己追的番要好好看完哦' : '取消追番成功',
                                displayType: SmartToastType.last);
                          }
                        },
                        splashColor: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
