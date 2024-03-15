import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/anime/anime_card.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/services.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage>
    with AutomaticKeepAliveClientMixin {
  DateTime? _lastPressedAt;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final PopularController popularController = Modular.get<PopularController>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    debugPrint('Popular 开始初始化');
    if (popularController.list.length == 0) {
      debugPrint('动画列表缓存为空, 尝试重新加载');
      popularController.getAnimeList();
    }
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
    });
    debugPrint('Popular 监听器已添加');
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    if (popularController.keyword != '') {
      popularController.filterList('');
      popularController.scrollOffset = 0.0;
    }
    debugPrint('popular 模块已卸载, 监听器移除');
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('尝试恢复状态');
      scrollController.jumpTo(popularController.scrollOffset);
      debugPrint('Popular加载完成');
    });
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          if (popularController.keyword == '') {
            await popularController.getAnimeList();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary, // 使用应用主题的主色
            title: TextField(
              focusNode: _focusNode,
              controller: _controller,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                hintText: '快速搜索',
                hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                border: InputBorder.none, // 隐藏下划线
                prefixIcon: Icon(Icons.search, color: Colors.white), // 搜索图标
              ),
              autocorrect: false,
              autofocus: false,
              onTap: () {
                setState(() {
                  _focusNode.requestFocus();
                  // _controller.clear(); // 清空文本字段内容
                });
              },
              onChanged: (t) {
                scrollController.jumpTo(0.0);
                popularController.filterList(t);
              },
            ),
          ),
          body: Container(child: animeList),
          floatingActionButton: FloatingActionButton(
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
        itemCount: popularController.cacheList.length == 0
            ? 1
            : popularController.cacheList.length,
        itemBuilder: (context, index) {
          return popularController.cacheList.length != 0
              ? AnimeInfoCard(
                  info: popularController.cacheList[index], index: index)
              : const SizedBox(
                  height: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ));
        },
      );
    });
  }
}
