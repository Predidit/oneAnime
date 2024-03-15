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
    final PopularController popularController =
        Modular.get<PopularController>();
    final VideoController videoController = Modular.get<VideoController>();
    late final navigationBarState;
    // final navigationBarState = Platform.isWindows
    //           ? Provider.of<SideNavigationBarState>(context, listen: false)
    //           : Provider.of<NavigationBarState>(context, listen: false);
    // late final navigationBarState = Provider.of<SideNavigationBarState>(context, listen: false);

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
          debugPrint('AnimeButton被按下 对应链接为 ${info.link}');
          await popularController.getVideoLink(info.link ?? '');
          debugPrint('链接解析成功 ${videoController.videoUrl}');
          await popularController.getPageTitle(info.name ?? '');
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: Platform.isWindows ? 800 : 200,
                    child: Text(
                      info.name ?? '',
                      maxLines: 2,
                      softWrap: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      info.episode ?? "77",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    (info.year ?? "2077") + (info.season ?? ""),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                  info.subtitle != ''
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            info.subtitle ?? "",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
