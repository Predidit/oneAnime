import 'package:oneanime/pages/history/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/anime/anime_card.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:oneanime/i18n/strings.g.dart'; 

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin {
  late Translations i18n;
  final ScrollController scrollController = ScrollController();
  final HistoryController historyController = Modular.get<HistoryController>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    i18n = Translations.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    historyController.getHistoryList();
    scrollController.addListener(() {
      historyController.scrollOffset = scrollController.offset;
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: SysAppBar(title: Text(i18n.my.history.title)),
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
        itemCount: historyController.historyList.isEmpty
            ? 1
            : historyController.historyList.length,
        itemBuilder: (context, index) {
          // 倒序
          return historyController.historyList.isNotEmpty
              ? AnimeInfoCard(
                  info: historyController.historyList[
                      historyController.historyList.length - index - 1],
                  index: historyController.historyList.length - index - 1,
                  type: 'history')
              : SizedBox(
                  height: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(i18n.my.history.empty),
                    ],
                  ));
        },
      );
    });
  }
}
