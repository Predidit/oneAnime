import 'dart:io';
import 'package:mobx/mobx.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';

part 'follow_controller.g.dart';

class FollowController = _FollowController with _$FollowController;

abstract class _FollowController with Store {
  final PopularController popularController = Modular.get<PopularController>();
  late List<AnimeInfo> list;
  // List<AnimeInfo> list = GStorage.listCahce.values.toList();

  @observable
  ObservableList<AnimeInfo> followList = ObservableList<AnimeInfo>.of([]);

  double scrollOffset = 0.0;
  bool isLoadingMore = true;
  String keyword = '';

  Future getFollowList() async {
    followList.clear();
    list = popularController.list;
    list.asMap().forEach((index, item) {
      if(item.follow == true) {
        followList.add(item);
      }
    });
  }

  Future updateFollow(int link, bool status) async {
    list.asMap().forEach((index, item) {
      if(item.link == link) {
        list[index].follow = status;
        return;
      }
    });
    updateData();
  }

  Future updateData() async {
    await GStorage.listCahce.clear();
    await GStorage.listCahce.addAll(list);
  }
}
