import 'package:mobx/mobx.dart';
import 'package:oneanime/request/list.dart';
import 'package:oneanime/bean/anime/anime_schedule.dart';

part 'timeline_controller.g.dart';

class TimelineController = _TimelineController with _$TimelineController;

abstract class _TimelineController with Store {
  @observable
  List<AnimeSchedule> schedules = [];

  @observable 
  String sessonName = '';

  DateTime? selectedDate;

  Future getSchedules() async {
    schedules = await ListRequest.getAnimeScedule(selectedDate ?? DateTime.now());
  }
}
