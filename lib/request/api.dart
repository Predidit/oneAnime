import 'package:oneanime/utils/constans.dart';

class Api {
  static const String domain = '${HttpString.baseUrl}/';
  static const String animeList = 'https://d1zquzjgwo9yb.cloudfront.net/';
  static const String videoAPI = 'https://v.anime1.me/api';
  static const String version = '1.4.6';
  static const String sourceUrl = "https://github.com/Predidit/oneAnime";
  static const String bangumiSearch = "https://api.bgmapi.com/search/subject/";
  // danmaku
  static const String dandanIndex = 'https://www.dandanplay.com/';
  static const String dandanAPIDomain = 'https://api.dandanplay.net';
  static const String dandanAPIComment = "/api/v2/comment/";
  static const String dandanAPISearch = "/api/v2/search/anime";
  static const String dandanAPIBgmtv = "/api/v2/bangumi/bgmtv/";
  // github update
  static const String latestApp =
      'https://api.github.com/repos/Predidit/oneAnime/releases/latest'; 
}
