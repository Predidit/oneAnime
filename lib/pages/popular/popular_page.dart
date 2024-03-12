import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/anime/anime_card.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  final PopularController popularController = Modular.get<PopularController>();

  @override
  void initState() {
    super.initState();
    debugPrint('Popular 开始初始化');
    if (popularController.list.length == 0) {
      debugPrint('动画列表缓存为空, 尝试重新加载');
      popularController.getAnimeList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('oneAnime Popular Test Page')),
      body: Container(
        child: animeList
      ),
    );
  }

  Widget get animeList {
    return Observer(builder: (context) {
      return popularController.list.length != 0
          ? ListView.builder(
              itemCount: popularController.list.length,
              itemBuilder: (context, index) {
                return AnimeInfoCard(
                    info: popularController.list[index], index: index);
              },
            )
          : const Center(
              child: Text('找不到任何東西 (´;ω;`)'),
            );
      ;
    });
  }
}
