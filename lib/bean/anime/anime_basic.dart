/// A basic anime class that has a name and link
abstract class AnimeBasic {
  String? name;
  String? link;

  /// Check if name contains t
  bool contains(String t) {
    final tL = t.toLowerCase();
    final nL = this.name?.toLowerCase();
    if (nL == null) {
      return false;
    } else {
      return nL.contains(tL);
    }
  }

  AnimeBasic.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    name = json['name'];
    link = json['link'];
  }

  /// Check if name is loaded and not null
  bool valid() {
    return name != null && name!.trim().length > 0;
  }

  /// Move episode number in front ([12] xxxx)
  String? formattedName() {
    if (name == null) {
      return null;
    } else if (name!.endsWith(']')) {
      var group = name!.split(' ');
      String tag = group.removeLast();
      String rest = group.join(' ');
      String last = '$tag $rest';

      // Double check the tag is in front now
      if (last.startsWith('[')) return last;
      return name;
    } else {
      return name;
    }
  }
}
