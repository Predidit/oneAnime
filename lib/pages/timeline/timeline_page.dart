import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(title: const Text('oneAnime Timeline Test Page')),
      body: Center(
        child: TextButton(
          onPressed: () {
            
          },
          child: const Text('测试'),
        ),
      ),
    );
  }
}