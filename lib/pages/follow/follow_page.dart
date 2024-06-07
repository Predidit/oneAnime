import 'dart:io';
import 'package:oneanime/pages/follow/follow_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/anime/anime_card.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:oneanime/pages/menu/side_menu.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage>
    with AutomaticKeepAliveClientMixin {
  dynamic navigationBarState;
  final ScrollController scrollController = ScrollController();
  final FollowController followController = Modular.get<FollowController>();

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
    followController.getFollowList();
    scrollController.addListener(() {
      followController.scrollOffset = scrollController.offset;
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  void onBackPressed(BuildContext context) {
    navigationBarState.showNavigate();
    navigationBarState.updateSelectedIndex(0);
    Modular.to.navigate('/tab/popular/');
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
          title: Text('追番')
        ),
        body: Container(child: animeList),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            scrollController.jumpTo(0.0);
            followController.scrollOffset = 0.0;
          },
          child: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }

  Widget get animeList {
    return Observer(builder: (context) {
      return ListView.separated(
        controller: scrollController,
        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
        itemCount: followController.followList.length == 0
            ? 1
            : followController.followList.length,
        itemBuilder: (context, index) {
          return followController.followList.length != 0
              ? AnimeInfoCard(
                  info: followController.followList[index], index: index, type: 'follow')
              : const SizedBox(
                  height: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('啊咧（⊙.⊙） 没有追番的说'),
                    ],
                  ));
        },
      );
    });
  }
}
