class BangumiInfo {
  String? name;
  String? nameCN;

  BangumiInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    name = json['name'];
    nameCN = json['name_cn'];
  }
}
