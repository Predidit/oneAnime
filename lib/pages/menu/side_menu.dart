import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/router.dart';
import 'package:provider/provider.dart';
import 'package:oneanime/pages/my/my_controller.dart';
import 'package:oneanime/i18n/strings.g.dart';

class SideMenu extends StatefulWidget {
  //const SideMenu({Key? key}) : super(key: key);
  const SideMenu({super.key});
  @override
  State<SideMenu> createState() => _SideMenu();
}

class SideNavigationBarState extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isRailVisible = true;

  int get selectedIndex => _selectedIndex;
  bool get isRailVisible => _isRailVisible;

  void updateSelectedIndex(int pageIndex) {
    _selectedIndex = pageIndex;
    notifyListeners();
  }

  void hideNavigate() {
    debugPrint('尝试隐藏侧边栏');
    _isRailVisible = false;
    notifyListeners();
  }

  void showNavigate() {
    _isRailVisible = true;
    notifyListeners();
  }
}

class _SideMenu extends State<SideMenu> {
  final PageController _page = PageController();
  late Translations i18n;
  final _mineController = Modular.get<MyController>();

  @override
  void initState() {
    super.initState();
    i18n = Translations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SideNavigationBarState(),
      child: Scaffold(
        body: Row(
          children: [
            Consumer<SideNavigationBarState>(builder: (context, state, child) {
              return SafeArea(
                child: Visibility(
                  visible: state.isRailVisible,
                  child: NavigationRail(
                    // extended: true,
                    groupAlignment: 1.0,
                    labelType: NavigationRailLabelType.selected,
                    leading: FloatingActionButton(
                      elevation: 0,
                      onPressed: () {
                        _mineController.checkUpdata();
                      },
                      child: const Icon(Icons.cloud_outlined),
                    ),

                    destinations: <NavigationRailDestination>[
                      NavigationRailDestination(
                        selectedIcon: const Icon(Icons.home),
                        icon: const Icon(Icons.home_outlined),
                        label: Text(i18n.menu.home),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(Icons.timeline),
                        icon: const Icon(Icons.timeline_outlined),
                        label: Text(i18n.menu.calendar),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(Icons.favorite),
                        icon: const Icon(Icons.favorite_border),
                        label: Text(i18n.menu.favorite),
                      ),
                      NavigationRailDestination(
                        selectedIcon: const Icon(Icons.settings),
                        icon: const Icon(Icons.settings_outlined),
                        label: Text(i18n.menu.my),
                      ),
                    ],
                    selectedIndex: state.selectedIndex,
                    onDestinationSelected: (int index) {
                      state.updateSelectedIndex(index);
                      switch (index) {
                        case 0:
                          Modular.to.navigate('/tab/popular/');
                          break;
                        case 1:
                          Modular.to.navigate('/tab/timeline/');
                          break;
                        case 2:
                          Modular.to.navigate('/tab/follow/');
                          break;
                        case 3:
                          Modular.to.navigate('/tab/my/');
                          break;
                      }
                    },
                  ),
                ),
              );
            }),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PageView.builder(
                  controller: _page,
                  itemCount: menu.size,
                  onPageChanged: (i) =>
                      Modular.to.navigate("/tab${menu.getPath(i)}/"),
                  itemBuilder: (_, __) => const RouterOutlet(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
