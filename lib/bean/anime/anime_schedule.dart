import 'package:oneanime/request/api.dart';
import 'package:oneanime/bean/anime/anime_basic.dart';
import 'package:html/dom.dart';
import 'package:oneanime/utils/constans.dart';

/// This class saves anime name, link and schedule (0 - 6)
class AnimeSchedule extends AnimeBasic { 
  int? weekday;

  AnimeSchedule(Node tr, int i) : super.fromJson(null) {
    weekday = i;
    // Fix for Sunday (anime1 puts Sunday first)
    if (weekday == 0) weekday = 7;
    weekday = weekday! - 1;

    // Same are empty
    if (tr.firstChild != null) {
      this.name = tr.firstChild?.text;
      // They haven't put the link so be careful
      String? link = tr.firstChild?.attributes['href'];
      if (link != null) {
        this.link = HttpString.apiBaseUrl + link;
      }
    }
  }

  AnimeSchedule.fromJson(Map<String, dynamic> json)
      : weekday = json['weekday'],
        super.fromJson(json);

  Map<String, dynamic> toJson() => {
        'weekday': weekday!,
        'name': name,
        'link': link,
      };
}
