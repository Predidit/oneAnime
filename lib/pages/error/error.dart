import 'package:flutter/material.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  ErrorPage(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SysAppBar(
        title: Text('内部错误'),
      ),
      body: Center(
        child: Text(errorMessage),
      ),
    );
  }
}