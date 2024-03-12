import 'package:mobx/mobx.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:oneanime/request/list.dart';

part 'popular_controller.g.dart';

class PopularController = _PopularController with _$PopularController;

abstract class _PopularController with Store {
  @observable
  List<AnimeInfo> list = [];

  Future getAnimeList() async {
    list = await ListRequest.getAnimeList();
  }
}