import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/anime/anime_card.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/services.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:window_manager/window_manager.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage>
    with AutomaticKeepAliveClientMixin {
  DateTime? _lastPressedAt;
  bool showArrowUp = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final PopularController popularController = Modular.get<PopularController>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (popularController.cacheList.isEmpty) {
      debugPrint('页面列表尝试重新加载');
      popularController.getAnimeList();
    }
    debugPrint('动画缓存列表长度为 ${popularController.list.length}');
    scrollController.addListener(() {
      popularController.scrollOffset = scrollController.offset;
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          popularController.isLoadingMore == false &&
          popularController.keyword == '') {
        debugPrint('Popular 正在加载更多');
        popularController.isLoadingMore = true;
        popularController.onLoad();
      }
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        checkArrowUp();
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    if (popularController.keyword != '') {
      popularController.filterList('');
      popularController.scrollOffset = 0.0;
    }
    super.dispose();
  }

  void onBackPressed(BuildContext context) {
    if (popularController.keyword != '') {
      _controller.clear();
      popularController.filterList('');
      scrollController.jumpTo(0.0);
      return;
    }
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) >
            const Duration(seconds: 2)) {
      // 两次点击时间间隔超过2秒，重新记录时间戳
      _lastPressedAt = DateTime.now();
      SmartDialog.showToast("再按一次退出应用");
      return;
    }
    SystemNavigator.pop(); // 退出应用
  }

  void checkArrowUp() {
    if (scrollController.position.pixels >= 800 && showArrowUp == false) {
      setState(() {
        showArrowUp = true;
      });
    }
    if (scrollController.position.pixels < 800 && showArrowUp == true) {
      setState(() {
        showArrowUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(popularController.scrollOffset);
    });
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          if (popularController.keyword == '' &&
              popularController.isLoadingMore == false) {
            await popularController.getAnimeList();
          }
        },
        child: Scaffold(
          appBar: SysAppBar(
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary
                .withOpacity(0.5), // 调整背景颜色的透明度以使其更柔和
            title: Stack(
              children: [
                TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: const InputDecoration(
                    hintText: '快速搜索',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  autocorrect: false,
                  autofocus: false,
                  onTap: () {
                    setState(() {
                      _focusNode.requestFocus();
                      _controller.clear(); 
                    });
                  },
                  onChanged: (t) {
                    scrollController.jumpTo(0.0);
                    popularController.filterList(t);
                  },
                ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onPanStart: (_) => windowManager.startDragging(),
                    child: Container(),
                  ),
                ),
              ],
            ),
            elevation: 0, // 移除阴影效果
            shape: Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? const RoundedRectangleBorder(
                    // 添加圆角
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                      bottom: Radius.circular(5),
                    ),
                  )
                : null,
          ),
          body: Container(child: animeList),
          floatingActionButton: Platform.isWindows || Platform.isLinux || Platform.isMacOS
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: showArrowUp,
                      child: FloatingActionButton(
                        onPressed: () {
                          scrollController.jumpTo(0.0);
                          popularController.scrollOffset = 0.0;
                        },
                        child: const Icon(Icons.arrow_upward),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 10.0), 
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        await popularController.getAnimeList();
                        SmartDialog.showToast('列表更新完成');
                      },
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                )
              : FloatingActionButton(
                  onPressed: () {
                    scrollController.jumpTo(0.0);
                    popularController.scrollOffset = 0.0;
                  },
                  child: const Icon(Icons.arrow_upward),
                ),
        ),
      ),
    );
  }

  Widget get animeList {
    return Observer(builder: (context) {
      return ListView.separated(
        controller: scrollController,
        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
        itemCount: popularController.cacheList.isEmpty
            ? 1
            : popularController.cacheList.length,
        itemBuilder: (context, index) {
          return popularController.cacheList.isNotEmpty
              ? AnimeInfoCard(
                  info: popularController.cacheList[index],
                  index: index,
                  type: 'popular')
              : (popularController.keyword == ''
                  ? const SizedBox(
                      height: 600,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ))
                  : const SizedBox(
                      height: 600,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('空空如也 >_<'),
                        ],
                      )));
        },
      );
    });
  }
}
