import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/app_module.dart';
import 'package:oneanime/app_widget.dart';
import 'package:oneanime/request/request.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Request();
  await Request.setCookie();
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}