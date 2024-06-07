import 'dart:io';
import 'package:oneanime/pages/history/history_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/anime/anime_card.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:oneanime/pages/menu/side_menu.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin {
  dynamic navigationBarState;
  final ScrollController scrollController = ScrollController();
  final HistoryController historyController = Modular.get<HistoryController>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在widget构建完成后调用的函数
      navigationBarState = Platform.isWindows || Platform.isLinux || Platform.isMacOS
          ? Provider.of<SideNavigationBarState>(context, listen: false)
          : Provider.of<NavigationBarState>(context, listen: false);
      navigationBarState.showNavigate();
    });
    historyController.getHistoryList();
    scrollController.addListener(() {
      historyController.scrollOffset = scrollController.offset;
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    debugPrint('history 模块已卸载, 监听器移除');
    super.dispose();
  }

  void onBackPressed(BuildContext context) {
    Modular.to.navigate('/tab/my/');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: const SysAppBar(
          title: Text('历史记录')
        ),
        body: Container(child: animeList),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            scrollController.jumpTo(0.0);
            historyController.scrollOffset = 0.0;
            historyController.clearHistory();
          },
          child: const Icon(Icons.clear_all),
        ),
      ),
    );
  }

  Widget get animeList {
    return Observer(builder: (context) {
      return ListView.separated(
        controller: scrollController,
        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
        itemCount: historyController.historyList.length == 0
            ? 1
            : historyController.historyList.length,
        itemBuilder: (context, index) {
          // 倒序
          return historyController.historyList.length != 0
              ? AnimeInfoCard(
                  info: historyController.historyList[historyController.historyList.length - index -1], index: historyController.historyList.length - index -1, type: 'history')
              : const SizedBox(
                  height: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('啊咧（⊙.⊙） 没有观看记录的说'),
                    ],
                  ));
        },
      );
    });
  }
}
