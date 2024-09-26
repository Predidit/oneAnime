import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:oneanime/request/api.dart';
import 'package:url_launcher/url_launcher.dart';

class MyController {
  Future<bool> checkUpdata({String type = 'manual'}) async {
    Utils.latest().then((value) {
      if (Api.version == value) {
        if (type == 'manual') {
          SmartDialog.showToast('Already the latest version!');
        }
      } else {
        SmartDialog.show(
          animationType: SmartAnimationType.centerFade_otherSlide,
          builder: (context) {
            return AlertDialog(
              title: Text('New Version $value'),
              actions: [
                TextButton(
                  onPressed: () => SmartDialog.dismiss(),
                  child: Text(
                    'Dismiss',
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
      if (type == 'manual') {
        SmartDialog.showToast('Already the latest version');
      }
    });
    return true;
  }
}
