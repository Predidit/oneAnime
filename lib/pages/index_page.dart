import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:oneanime/pages/menu/side_menu.dart';


class IndexPage extends StatefulWidget {
  //const IndexPage({super.key});
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with  WidgetsBindingObserver {

  final PageController _page = PageController();

  /// 统一处理前后台改变
  void appListener(bool state) {
    if (state) {
      debugPrint("应用前台");
    } else {
      debugPrint("应用后台");
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Row(children: [
    //   AppDrawer(page: _page),
    //   Expanded(
    //     child: PageView.builder(
    //       controller: _page,
    //       itemCount: menu.size,
    //       onPageChanged: (i) => Modular.to.navigate("/tab${menu.getPath(i)}/"),
    //       itemBuilder: (_, __) => const RouterOutlet(),
    //     ),
    //   )
    // ]);
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS ? const SideMenu() : const BottomMenu();
  }
}
