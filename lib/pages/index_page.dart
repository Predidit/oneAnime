import 'package:flutter/material.dart';
import 'package:oneanime/pages/menu/menu.dart';


class IndexPage extends StatefulWidget {
  //const IndexPage({super.key});
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with  WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return const ScaffoldMenu();
  }
}
