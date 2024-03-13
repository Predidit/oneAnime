import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(title: const Text('oneAnime Video Test Page')),
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