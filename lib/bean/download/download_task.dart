import 'package:hive/hive.dart';

/// Represents a single episode download task
class DownloadTask extends HiveObject {
  @HiveField(0)
  int? link; // anime cat id
  
  @HiveField(1)
  String? title; // anime title
  
  @HiveField(2)
  int? episode; // episode number
  
  @HiveField(3)
  String? token; // video token from VideoRequest.getVideoToken
  
  @HiveField(4)
  String? resolvedUrl; // last resolved video URL
  
  @HiveField(5)
  String? userAgent; // generated once per task
  
  @HiveField(6)
  String? status; // queued/downloading/paused/completed/failed
  
  @HiveField(7)
  int? receivedBytes;
  
  @HiveField(8)
  int? totalBytes;
  
  @HiveField(9)
  String? savePath; // local file path
  
  @HiveField(10)
  String? error; // error message if failed
  
  @HiveField(11)
  int? createdAt; // timestamp
  
  @HiveField(12)
  int? updatedAt; // timestamp
  
  @HiveField(13)
  String? videoCookie; // cookie for video playback

  DownloadTask({
    this.link,
    this.title,
    this.episode,
    this.token,
    this.resolvedUrl,
    this.userAgent,
    this.status,
    this.receivedBytes,
    this.totalBytes,
    this.savePath,
    this.error,
    this.createdAt,
    this.updatedAt,
    this.videoCookie,
  });

  DownloadTask.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    link = json['link'];
    title = json['title'];
    episode = json['episode'];
    token = json['token'];
    resolvedUrl = json['resolvedUrl'];
    userAgent = json['userAgent'];
    status = json['status'];
    receivedBytes = json['receivedBytes'];
    totalBytes = json['totalBytes'];
    savePath = json['savePath'];
    error = json['error'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    videoCookie = json['videoCookie'];
  }

  Map<String, dynamic> toJson() => {
        'link': link,
        'title': title,
        'episode': episode,
        'token': token,
        'resolvedUrl': resolvedUrl,
        'userAgent': userAgent,
        'status': status,
        'receivedBytes': receivedBytes,
        'totalBytes': totalBytes,
        'savePath': savePath,
        'error': error,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'videoCookie': videoCookie,
      };

  String get taskId => '${link}_$episode';
  
  double get progress {
    if (totalBytes == null || totalBytes == 0) return 0.0;
    return (receivedBytes ?? 0) / totalBytes!;
  }
  
  bool get isCompleted => status == 'completed';
  bool get isDownloading => status == 'downloading';
  bool get isFailed => status == 'failed';
  bool get isPaused => status == 'paused';
  bool get isQueued => status == 'queued';
}

class DownloadTaskAdapter extends TypeAdapter<DownloadTask> {
  @override
  final int typeId = 2;

  @override
  DownloadTask read(BinaryReader reader) {
    return DownloadTask(
      link: reader.readInt(),
      title: reader.readString(),
      episode: reader.readInt(),
      token: reader.readString(),
      resolvedUrl: reader.readString(),
      userAgent: reader.readString(),
      status: reader.readString(),
      receivedBytes: reader.readInt(),
      totalBytes: reader.readInt(),
      savePath: reader.readString(),
      error: reader.readString(),
      createdAt: reader.readInt(),
      updatedAt: reader.readInt(),
      videoCookie: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, DownloadTask obj) {
    writer.writeInt(obj.link ?? 0);
    writer.writeString(obj.title ?? '');
    writer.writeInt(obj.episode ?? 0);
    writer.writeString(obj.token ?? '');
    writer.writeString(obj.resolvedUrl ?? '');
    writer.writeString(obj.userAgent ?? '');
    writer.writeString(obj.status ?? 'queued');
    writer.writeInt(obj.receivedBytes ?? 0);
    writer.writeInt(obj.totalBytes ?? 0);
    writer.writeString(obj.savePath ?? '');
    writer.writeString(obj.error ?? '');
    writer.writeInt(obj.createdAt ?? 0);
    writer.writeInt(obj.updatedAt ?? 0);
    writer.writeString(obj.videoCookie ?? '');
  }
}

