import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/app_module.dart';
import 'package:oneanime/app_widget.dart';
import 'package:oneanime/request/request.dart';
import 'package:media_kit/media_kit.dart';
import 'package:oneanime/utils/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await GStorage.init();
  Request();
  await Request.setCookie();
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}