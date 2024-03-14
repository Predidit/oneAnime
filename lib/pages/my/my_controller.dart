import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:oneanime/request/api.dart';
import 'package:url_launcher/url_launcher.dart';

class MyController {
  Future<bool> checkUpdata() async {
    Utils.latest().then((value) {
      if (Api.version == value) {
        SmartDialog.showToast('当前已经是最新版本！');
      } else {
        SmartDialog.show(
          animationType: SmartAnimationType.centerFade_otherSlide,
          builder: (context) {
            return AlertDialog(
              title: Text('发现新版本 $value'),
              actions: [
                TextButton(
                  onPressed: () => SmartDialog.dismiss(),
                  child: Text(
                    '稍后',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      launchUrl(Uri.parse("${Api.sourceUrl}/releases/latest")),
                  child: const Text('Github'),
                ),
              ],
            );
          },
        );
      }
    }).catchError((err) {
      debugPrint(err.toString());
      SmartDialog.showToast('当前是最新版本！');
      return false;
    });
    return true;
  }
}