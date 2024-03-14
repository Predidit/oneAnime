import 'package:oneanime/request/api.dart';

/// This class asks for DateTime to get a string to indicate seasonal anime
class AnimeSeason {
  late DateTime _date;
  final _seasons = ['冬季', '春季', '夏季', '秋季'];

  AnimeSeason(DateTime date) {
    this._date = date;
  }

  String getLink() {
    return '${Api.domain}$this'; 
  }

  /// Link for Anime page to use
  String getAnimeLink() {
    return '${Api.domain}category/$this'.replaceFirst('新番', '');
  }

  /// some preset filters
  List<String> getQuickFilters() {
    List<String> filters = ['連載中', '劇場版', 'OVA', 'OAD'];

    // Add recent 4 seasons
    int offset = 0;
    for (int i = 0; i < 4; i++, offset -= 3) {
      // Keep updating the date
      var temp =
          this._getYearAndSeason(this._date.add(Duration(days: offset * 30)));
      filters.add('${temp[0]}${this._seasons[temp[1]][0]}');
    }

    return filters;
  }

  List<int> _getYearAndSeason(DateTime dt) {
    int year = dt.year;
    int month = dt.month;

    int season;
    if (month < 4)
      season = 0;
    else if (month < 7)
      season = 1;
    else if (month < 10)
      season = 2;
    else
      season = 3;

    return [year, season];
  }

  @override
  String toString() {
    var yas = this._getYearAndSeason(this._date);
    
    return '${yas[0]}年${this._seasons[yas[1]]}新番';
  }
}
