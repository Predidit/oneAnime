/// A basic anime class that has a name and link
abstract class AnimeBasic {
  String? name;
  String? link;

  AnimeBasic.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    name = json['name'];
    link = json['link'];
  }

  /// Check if name is loaded and not null
  bool valid() {
    return name != null && name!.trim().isNotEmpty;
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
