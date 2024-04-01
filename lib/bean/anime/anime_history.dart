import 'package:hive/hive.dart';

/// This class parses a Node and stores anime info like anime name, anime link, total episodes, year, season and subtitle group
@HiveType(typeId: 1)
class AnimeHistory extends HiveObject {
  @HiveField(0)
  int? link;
  @HiveField(1)
  int? time;

  AnimeHistory({
    this.link,
    this.time,
  });

  AnimeHistory.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    link = json['link'];
    time = json['time'];
  }
}

class AnimeHistoryAdapter extends TypeAdapter<AnimeHistory> {
  @override
  final int typeId = 1;

  @override
  AnimeHistory read(BinaryReader reader) {
    return AnimeHistory(
      link: reader.readInt(),
      time: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, AnimeHistory obj) {
    writer.writeInt(obj.link ?? 19951);
    writer.writeInt(obj.time ?? 0);
  }
}
