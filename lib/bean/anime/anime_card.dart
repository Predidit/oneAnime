import 'dart:io';

import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/menu/side_menu.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:provider/provider.dart';

/// Takes an AnimeInfo object and render it to a card
class AnimeInfoCard extends StatefulWidget {
  AnimeInfoCard({
    Key? key,
    required this.info,
    required this.index,
  }) : super(key: key);

  final AnimeInfo info;
  final int index;
  @override
  _AnimeInfoCardState createState() => _AnimeInfoCardState();
}

class _AnimeInfoCardState extends State<AnimeInfoCard> {
  late bool follow;
  @override
  Widget build(BuildContext context) {
    follow = widget.info.follow ?? false;
    final PopularController popularController =
        Modular.get<PopularController>();
    final VideoController videoController = Modular.get<VideoController>();
    dynamic navigationBarState;

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () async {
          SmartDialog.showLoading(msg: '获取中');
          debugPrint('AnimeButton被按下 对应链接为 https://anime1.me/?cat=${widget.info.link}');
          await popularController.getVideoLink('https://anime1.me/?cat=${widget.info.link}');
          debugPrint('链接解析成功 ${videoController.videoUrl}');
          await popularController.getPageTitle(widget.info.name ?? '');
          SmartDialog.dismiss();
          navigationBarState = Platform.isWindows
              ? Provider.of<SideNavigationBarState>(context, listen: false)
              : Provider.of<NavigationBarState>(context, listen: false);
          navigationBarState.hideNavigate();
          Modular.to.navigate('/tab/video/');
        },
        child: Container(
  padding: EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        width: Platform.isWindows ? 800 : 200,
        child: Text(
          widget.info.name ?? '',
          maxLines: 2,
          softWrap: true,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black),
        ),
      ),
      SizedBox(height: 8.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.info.episode ?? "77",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  (widget.info.year ?? "2077") + (widget.info.season ?? ""),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8.0),
              widget.info.subtitle != ''
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        widget.info.subtitle ?? "",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Container(),
            ],
          ),
          IconButton(
  icon: (follow)
      ? Icon(Icons.favorite, color: Colors.orange)
      : Icon(Icons.favorite_border, color: Colors.orange),
  onPressed: () {
    popularController.updateFollow(widget.info.link ?? 19951, !(follow)); 
    setState(() {
      follow = !follow;
    });
    SmartDialog.showToast(follow ? '自己追的番要好好看完哦' : '取消追番成功');
  },
  splashColor: Colors.orange.withOpacity(0.5),
),
        ],
      ),
    ],
  ),
),

      ),
    );
  }
}
