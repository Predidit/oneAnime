import 'package:hive/hive.dart';

/// This class parses a Node and stores anime info like anime name, anime link, total episodes, year, season and subtitle group
class AnimeInfo extends HiveObject {
  @HiveField(0)
  int? link;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? episode;
  @HiveField(3)
  String? year;
  @HiveField(4)
  String? season;
  @HiveField(5)
  String? subtitle;
  @HiveField(6)
  bool? follow;
  @HiveField(7)
  int? progress;

  AnimeInfo({
    this.link,
    this.name,
    this.episode,
    this.year,
    this.season,
    this.subtitle,
    this.follow,
    this.progress,
  });

  bool contains(String t) {
    // emm, any better way of writing this?
    if (basicContains(t)) return true;
    if (year != null && season != null && (year! + season!).contains(t))
      return true;
    if (episode != null && episode!.contains(t)) return true;
    if (subtitle != null && subtitle!.contains(t)) return true;

    return false;
  }

  bool basicContains(String t) {
    final tL = t.toLowerCase();
    final nL = this.name?.toLowerCase();
    if (nL == null) {
      return false;
    } else {
      return nL.contains(tL);
    }
  }

  AnimeInfo.fromList(List list) {
    // The ID is the link
    // this.link = 'https://anime1.me/?cat=${list[0]}';
    this.link = list[0];
    this.name = list[1];
    this.episode = list[2];
    this.year = list[3];
    this.season = list[4];
    this.subtitle = list[5];
    this.follow = false;
    this.progress = 1;
  }

  Map<String, dynamic> toJson() => {
        'subtitle': subtitle,
        'season': season,
        'year': year,
        'episode': episode,
        'name': name,
        'link': link,
        'follow': follow,
        'progress': progress
      };

  @override
  String toString() {
    return "Name: $name\nLink: $link\nEpisode: $episode\nYear: $year\nSeason: $season\nSubtitle: $subtitle";
  }
}

class AnimeInfoAdapter extends TypeAdapter<AnimeInfo> {
  @override
  final int typeId = 0;

  @override
  AnimeInfo read(BinaryReader reader) {
    return AnimeInfo(
      link: reader.readInt(),
      name: reader.readString(),
      episode: reader.readString(),
      year: reader.readString(),
      season: reader.readString(),
      subtitle: reader.readString(),
      follow: reader.readBool(),
      progress: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, AnimeInfo obj) {
    writer.writeInt(obj.link ?? 19951);
    writer.writeString(obj.name ?? '');
    writer.writeString(obj.episode ?? '');
    writer.writeString(obj.year ?? '');
    writer.writeString(obj.season ?? '');
    writer.writeString(obj.subtitle ?? '');
    writer.writeBool(obj.follow ?? false);
    writer.writeInt(obj.progress ?? 1);
  }
}
