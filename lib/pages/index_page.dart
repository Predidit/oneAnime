import 'package:flutter/material.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:oneanime/pages/menu/side_menu.dart';
import 'package:oneanime/utils/utils.dart';


class IndexPage extends StatefulWidget {
  //const IndexPage({super.key});
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with  WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Utils.isCompact() ? const BottomMenu() : const SideMenu();
  }
}
