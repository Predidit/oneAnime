import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:flutter/material.dart';

/// Takes an AnimeInfo object and render it to a card
class AnimeInfoCard extends StatelessWidget {
  AnimeInfoCard({
    Key? key,
    required this.info,
    required this.index,
  }) : super(key: key);

  final AnimeInfo info;
  final int index;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final first = isDark ? Colors.grey[900] : Colors.white;
    final second = isDark ? Colors.grey[800] : Colors.grey[200];

    return Material(
      color: index % 2 == 0 ? first : second,
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Anime(link: this.info.link),
          //   ),
          // );
          debugPrint('AnimeButton 被按下');
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                info.name ?? "賽博朋克",
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            Table(children: [
              TableRow(children: [
                Text(info.episode ?? "77", textAlign: TextAlign.center),
                // Cyperpunk?
                Text(
                  (info.year ?? "2077") + (info.season ?? ""),
                  textAlign: TextAlign.center,
                ),
                Text(
                  info.subtitle ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ]),
            ]),
          ],
        ),
      ),
    );
  }
}
