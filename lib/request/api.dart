import 'package:oneanime/utils/constans.dart';

class Api {
  static const String domain = '${HttpString.baseUrl}/';
  static const String animeList = 'https://d1zquzjgwo9yb.cloudfront.net/';
  static const String videoAPI = 'https://v.anime1.me/api';
  static const String version = '1.4.3';
  static const String sourceUrl = "https://github.com/Predidit/oneAnime";
  static const String aniDanmakuAPI = "https://ani.gamer.com.tw/ajax/danmuGet.php";
  static const String aniSearch = "https://ani.gamer.com.tw/search.php";
  static const String bangumiSearch = "https://api.bgm.tv/search/subject/";
  // danmaku
  static const String dandanIndex = 'https://www.dandanplay.com/';
  static const String dandanAPIDomain = 'https://api.dandanplay.net';
  static const String dandanAPIComment = "/api/v2/comment/";
  static const String dandanAPISearch = "/api/v2/search/anime";
  static const String dandanAPIInfo = "/api/v2/bangumi/";
  // github update
  static const String latestApp =
      'https://api.github.com/repos/Predidit/oneAnime/releases/latest'; 
}
