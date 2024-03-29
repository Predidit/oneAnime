import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:oneanime/pages/timeline/timeline_controller.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/pages/menu/side_menu.dart';

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
    navigationBarState = Platform.isWindows
        ? Provider.of<SideNavigationBarState>(context, listen: false)
        : Provider.of<NavigationBarState>(context, listen: false);
    navigationBarState.showNavigate();
    navigationBarState.updateSelectedIndex(0);
    Modular.to.navigate('/tab/popular/');
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
            title: Text(timelineController.sessonName),
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
        child: Text('數據還沒有更新 (´;ω;`)'),
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
                      await popularController.getVideoLink(item.link ?? '');
                    } catch (e) {
                      SmartDialog.dismiss();
                      SmartDialog.showToast(e.toString());
                      return;
                    }
                    videoController.title = item.name ?? '';
                    SmartDialog.dismiss();
                    navigationBarState = Platform.isWindows
                        ? Provider.of<SideNavigationBarState>(context,
                            listen: false)
                        : Provider.of<NavigationBarState>(context,
                            listen: false);
                    navigationBarState.hideNavigate();
                    videoController.from = '/tab/timeline/';
                    Modular.to.navigate('/tab/video/');
                  } else {
                    SmartDialog.showToast('動畫還沒有更新第一集 >_<');
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
