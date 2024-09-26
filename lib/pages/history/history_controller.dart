import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:oneanime/bean/anime/anime_history.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:hive/hive.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryController with _$HistoryController;

abstract class _HistoryController with Store {
  final PopularController popularController = Modular.get<PopularController>();
  late List<AnimeInfo> list;
  Box setting = GStorage.setting;
  bool privateMode = false;
  List<AnimeHistory> history = GStorage.history.values.toList();

  @observable
  ObservableList<AnimeInfo> historyList = ObservableList<AnimeInfo>.of([]);

  double scrollOffset = 0.0;
  bool isLoadingMore = true;

  Future getHistoryList() async {
    historyList.clear();
    if (history.isNotEmpty) {
      list = popularController.list;
      history.asMap().forEach((key, value) {
        list.asMap().forEach((index, item) {
          if (item.link == value.link) {
            historyList.add(item);
            return;
          }
        });
      });
    }
  }

  Future updateFollow(int link, bool status) async {
    list.asMap().forEach((index, item) {
      if (item.link == link) {
        list[index].follow = status;
        return;
      }
    });
    updateData();
  }

  Future updateHistory(int link, int offset) async {
    privateMode = setting.get(SettingBoxKey.privateMode, defaultValue: false);
    if (privateMode) {
      return;
    }
    int? deleteKey;
    AnimeHistory newRecord;
    int time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (history.isNotEmpty) {
      history.asMap().forEach((key, value) {
        if (value.link == link) {
          // history[key].time = time;
          deleteKey = key;
          return;
        }
      });
      if (deleteKey != null) {
        history.removeAt(deleteKey!);
        await GStorage.history.clear();
        await GStorage.history.addAll(history);
      }
    }
    newRecord = AnimeHistory.fromJson({"link": link, "time": time, "offset": offset});
    debugPrint('更新历史记录: link: $link, time: $time, offset: $offset');
    history.add(newRecord);
    GStorage.history.add(newRecord);
  }

  Future deleteHistory(int link) async {
    // if (history.length == 1) {
    //   historyList.clear();
    //   await GStorage.history.clear();
    //   return;
    // }
    int? deleteKey;
    history.asMap().forEach((key, value) {
      if (value.link == link) {
        deleteKey = key;
        return;
      }
    });
    if (deleteKey != null) {
      debugPrint('找到目标历史记录 $deleteKey');
      history.removeAt(deleteKey!);
      deleteKey = null;
    }
    historyList.asMap().forEach((key, value) {
      if (value.link == link) {
        deleteKey = key;
        return;
      }
    });
    if (deleteKey != null) {
      historyList.removeAt(deleteKey!);
    }
    await GStorage.history.clear();
    await GStorage.history.addAll(history);
  }

  AnimeHistory? lookupHistory(int link) {
    AnimeHistory? ret;
    history.asMap().forEach((key, value) {
      if (value.link == link) {
        ret = value;
      }
    });
    return ret;
  }

  Future clearHistory() async {
    history.clear();
    historyList.clear();
    GStorage.history.clear();
  }

  Future updateData() async {
    await GStorage.listCahce.clear();
    await GStorage.listCahce.addAll(list);
  }
}