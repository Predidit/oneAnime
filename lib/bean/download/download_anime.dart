import 'package:hive/hive.dart';
import 'dart:convert';

/// Represents an anime with its tokens for download management
class DownloadAnime extends HiveObject {
  @HiveField(0)
  int? link; // anime cat id
  
  @HiveField(1)
  String? title; // anime title
  
  @HiveField(2)
  String? tokensJson; // jsonEncode(List<String>)
  
  @HiveField(3)
  int? episodeTotal; // total number of episodes

  DownloadAnime({
    this.link,
    this.title,
    this.tokensJson,
    this.episodeTotal,
  });

  DownloadAnime.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    link = json['link'];
    title = json['title'];
    tokensJson = json['tokensJson'];
    episodeTotal = json['episodeTotal'];
  }

  Map<String, dynamic> toJson() => {
        'link': link,
        'title': title,
        'tokensJson': tokensJson,
        'episodeTotal': episodeTotal,
      };

  List<String> get tokens {
    if (tokensJson == null || tokensJson!.isEmpty) return [];
    try {
      return List<String>.from(jsonDecode(tokensJson!));
    } catch (e) {
      return [];
    }
  }

  void setTokens(List<String> tokens) {
    tokensJson = jsonEncode(tokens);
  }
}

class DownloadAnimeAdapter extends TypeAdapter<DownloadAnime> {
  @override
  final int typeId = 3;

  @override
  DownloadAnime read(BinaryReader reader) {
    return DownloadAnime(
      link: reader.readInt(),
      title: reader.readString(),
      tokensJson: reader.readString(),
      episodeTotal: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DownloadAnime obj) {
    writer.writeInt(obj.link ?? 0);
    writer.writeString(obj.title ?? '');
    writer.writeString(obj.tokensJson ?? '[]');
    writer.writeInt(obj.episodeTotal ?? 0);
  }
}

