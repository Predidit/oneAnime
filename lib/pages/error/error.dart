import 'dart:io';

import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  const ErrorPage(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('内部错误'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(errorMessage),
            TextButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text('退出程序'))
          ],
        ),
      ),
    );
  }
}
