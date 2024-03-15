import 'package:html/dom.dart';
import 'package:oneanime/request/api.dart';
import 'package:oneanime/utils/constans.dart';

import 'anime_basic.dart';

/// This class parses a Node and stores anime info like anime name, anime link, total episodes, year, season and subtitle group
class AnimeInfo extends AnimeBasic {
  String? episode;
  String? year;
  String? season;
  String? subtitle;

  AnimeInfo(Node tr) : super.fromJson(null) {
    final list = tr.nodes;
    try {
      this.name = list[0].text;
      final href = list[0].nodes[0].attributes["href"];
      if (href != null) this.link = HttpString.apiBaseUrl + href;
      this.episode = list[1].text;
      this.year = list[2].text;
      this.season = list[3].text;
      this.subtitle = list[4].text ?? "-";
    } catch (e) {
      throw new Exception('AnimeInfo - Tr has been changed\n${e.toString()}');
    }
  }

  @override
  bool contains(String t) {
    // emm, any better way of writing this?
    if (super.contains(t)) return true;
    if (year != null && season != null && (year! + season!).contains(t))
      return true;
    if (episode != null && episode!.contains(t)) return true;
    if (subtitle != null && subtitle!.contains(t)) return true;

    return false;
  }

  AnimeInfo.fromJson(Map<String, dynamic> json)
      : episode = json['episode'],
        year = json['year'],
        season = json['season'],
        subtitle = json['subtitle'],
        super.fromJson(json);

  AnimeInfo.fromList(List list) : super.fromJson(null) {
    // The ID is the link
    this.link = 'https://anime1.me/?cat=${list[0]}';
    this.name = list[1];
    this.episode = list[2];
    this.year = list[3];
    this.season = list[4];
    this.subtitle = list[5];
  }

  Map<String, dynamic> toJson() => {
        'subtitle': subtitle,
        'season': season,
        'year': year,
        'episode': episode,
        'name': name,
        'link': link
      };

  @override
  String toString() {
    return "Name: $name\nLink: $link\nEpisode: $episode\nYear: $year\nSeason: $season\nSubtitle: $subtitle";
  }
}
