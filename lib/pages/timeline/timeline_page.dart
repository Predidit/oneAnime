import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:oneanime/pages/timeline/timeline_controller.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/pages/menu/side_menu.dart';
import 'package:oneanime/bean/anime/anime_sesson.dart';
import 'package:oneanime/bean/anime/anime_history.dart';
import 'package:oneanime/pages/history/history_controller.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage>
    with SingleTickerProviderStateMixin {
  final TimelineController timelineController =
      Modular.get<TimelineController>();
  final VideoController videoController = Modular.get<VideoController>();
  final PopularController popularController = Modular.get<PopularController>();
  final HistoryController historyController = Modular.get<HistoryController>();
  dynamic navigationBarState;
  TabController? controller;

  @override
  void initState() {
    super.initState();
    int weekday = DateTime.now().weekday - 1;
    controller =
        TabController(vsync: this, length: tabs.length, initialIndex: weekday);
    if (timelineController.schedules.length == 0) {
      debugPrint('时间表缓存为空, 尝试重新加载');
      timelineController.getSchedules();
    }
  }

  void onBackPressed(BuildContext context) {
    navigationBarState = Platform.isWindows || Platform.isLinux || Platform.isMacOS
        ? Provider.of<SideNavigationBarState>(context, listen: false)
        : Provider.of<NavigationBarState>(context, listen: false);
    navigationBarState.showNavigate();
    navigationBarState.updateSelectedIndex(0);
    Modular.to.navigate('/tab/popular/');
  }

  DateTime generateDateTime(int year, String season) {
    switch (season) {
      case '冬':
        return DateTime(year, 1, 2);
      case '春':
        return DateTime(year, 4, 2);
      case '夏':
        return DateTime(year, 7, 2);
      case '秋':
        return DateTime(year, 10, 2);
      default:
        return DateTime.now();
    }
  }

  final List<Tab> tabs = const <Tab>[
    Tab(text: '一'),
    Tab(text: '二'),
    Tab(text: '三'),
    Tab(text: '四'),
    Tab(text: '五'),
    Tab(text: '六'),
    Tab(text: '日'),
  ];

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          onBackPressed(context);
        },
        child: Scaffold(
          appBar: SysAppBar(
            toolbarHeight: 104,
            bottom: TabBar(
              controller: controller,
              tabs: tabs,
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            title: InkWell(
              child: Text(timelineController.sessonName),
              onTap: () {
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('时间机器'),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            children: [
                              for (final int i in [
                                DateTime.now().year,
                                DateTime.now().year - 1,
                                DateTime.now().year - 2
                              ])
                                for (final String selectedSeason in [
                                  '秋',
                                  '夏',
                                  '春',
                                  '冬'
                                ])
                                  DateTime.now().isAfter(
                                          generateDateTime(i, selectedSeason))
                                      ? timelineController.selectedDate ==
                                              generateDateTime(
                                                  i, selectedSeason)
                                          ? FilledButton(
                                              onPressed: () async {
                                                if (timelineController
                                                        .selectedDate !=
                                                    generateDateTime(
                                                        i, selectedSeason)) {
                                                  timelineController
                                                          .selectedDate =
                                                      generateDateTime(
                                                          i, selectedSeason);
                                                  timelineController
                                                      .getSchedules();
                                                }
                                                SmartDialog.dismiss();
                                              },
                                              child: Text(i.toString() +
                                                  selectedSeason.toString()),
                                            )
                                          : FilledButton.tonal(
                                              onPressed: () async {
                                                if (timelineController
                                                        .selectedDate !=
                                                    generateDateTime(
                                                        i, selectedSeason)) {
                                                  timelineController
                                                          .selectedDate =
                                                      generateDateTime(
                                                          i, selectedSeason);
                                                  timelineController
                                                      .getSchedules();
                                                }

                                                SmartDialog.dismiss();
                                              },
                                              child: Text(i.toString() +
                                                  selectedSeason.toString()),
                                            )
                                      : Container(),
                            ],
                          );
                        }),
                      );
                    });
              },
            ),
          ),
          body: renderBody,
        ),
      );
    });
  }

  Widget get renderBody {
    if (timelineController.schedules.length > 0) {
      return TabBarView(
        controller: controller,
        children: renderSchedule(),
      );
    } else {
      return const Center(
        child: Text('数据还没有更新 (´;ω;`)'),
      );
    }
  }

  List<Widget> renderSchedule() {
    List<Widget> children = [];
    for (int i = 0; i < tabs.length; i++) {
      final list = timelineController.schedules.where((s) => s.weekday == i);
      children.add(SafeArea(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (c, i) {
            final item = list.elementAt(i);
            return SizedBox(
              height: 48,
              child: InkWell(
                onTap: () async {
                  // It might be null
                  if (item.link != null) {
                    SmartDialog.showLoading(msg: '获取中');
                    try {
                      AnimeInfo? animeInfo =
                          popularController.lookupAnime(item.name ?? "");
                      videoController.link = animeInfo?.link ?? 0;
                      videoController.follow = animeInfo?.follow ?? false;
                      AnimeHistory? history =
                          historyController.lookupHistory(animeInfo?.link ?? 0);
                      if (history == null) {
                        historyController.updateHistory(
                            animeInfo?.link ?? 0, 0);
                      } else {
                        historyController.updateHistory(
                            animeInfo?.link ?? 0, history.offset ?? 0);
                        videoController.offset = history.offset ?? 0;
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                      SmartDialog.dismiss();
                    }
                    try {
                      await popularController.getVideoLink(item.link ?? '');
                    } catch (_) {
                      SmartDialog.dismiss();
                      SmartDialog.showToast('获取剧集失败 errcode: 404');
                      return;
                    }
                    videoController.title = item.name ?? '';
                    SmartDialog.dismiss();
                    navigationBarState = Platform.isWindows || Platform.isLinux || Platform.isMacOS
                        ? Provider.of<SideNavigationBarState>(context,
                            listen: false)
                        : Provider.of<NavigationBarState>(context,
                            listen: false);
                    navigationBarState.hideNavigate();
                    videoController.from = '/tab/timeline/';
                    Modular.to.navigate('/tab/video/');
                  } else {
                    SmartDialog.showToast('動畫還沒有更新第一集 >_<', displayType: SmartToastType.last);
                  }
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      item.formattedName() ?? "賽博朋克",
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
              ),
            );
            ;
          },
        ),
      ));
    }

    return children;
  }
}
