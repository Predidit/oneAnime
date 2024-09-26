import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/router.dart';
import 'package:provider/provider.dart';
import 'package:oneanime/i18n/strings.g.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});
  @override
  State<BottomMenu> createState() => _BottomMenu();
}

class NavigationBarState extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isHide = false;

  int get selectedIndex => _selectedIndex;
  bool get isHide => _isHide;

  void updateSelectedIndex(int pageIndex) {
    _selectedIndex = pageIndex;
    notifyListeners();
  }

  void hideNavigate() {
    _isHide = true;
    notifyListeners();
  }

  void showNavigate() {
    _isHide = false;
    notifyListeners();
  }
}

class _BottomMenu extends State<BottomMenu> {
  var selectedIndex = 0;
  late Translations i18n;
  final PageController _page = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    i18n = Translations.of(context);
    return ChangeNotifierProvider(
        create: (context) => NavigationBarState(),
        child: Scaffold(
          body: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _page,
              itemCount: menu.size,
              onPageChanged: (i) =>
                  Modular.to.navigate("/tab${menu.getPath(i)}/"),
              itemBuilder: (_, __) => const RouterOutlet(),
            ),
          ),
          bottomNavigationBar:
              Consumer<NavigationBarState>(builder: (context, state, child) {
            return state.isHide
                ? const SizedBox(height: 0)
                : NavigationBar(
                    destinations: <Widget>[
                      NavigationDestination(
                        selectedIcon: const Icon(Icons.home),
                        icon: const Icon(Icons.home_outlined),
                        label: i18n.menu.home,
                      ),
                      NavigationDestination(
                        selectedIcon: const Icon(Icons.timeline),
                        icon: const Icon(Icons.timeline_outlined),
                        label: i18n.menu.calendar,
                      ),
                      NavigationDestination(
                        selectedIcon: const Icon(Icons.favorite),
                        icon: const Icon(Icons.favorite_border),
                        label: i18n.menu.favorite,
                      ),
                      NavigationDestination(
                        selectedIcon: const Icon(Icons.settings),
                        icon: const Icon(Icons.settings_outlined),
                        label: i18n.menu.my,
                      ),
                    ],
                    selectedIndex: state.selectedIndex,
                    onDestinationSelected: (int index) {
                      // setState(() {
                      //   selectedIndex = index;
                      // });
                      state.updateSelectedIndex(index);
                      switch (index) {
                        case 0:
                          {
                            Modular.to.navigate('/tab/popular/');
                          }
                          break;
                        case 1:
                          {
                            Modular.to.navigate('/tab/timeline/');
                          }
                          break;
                        case 2:
                          {
                            Modular.to.navigate('/tab/follow/');
                          }
                          break;
                        case 3:
                          {
                            Modular.to.navigate('/tab/my/');
                          }
                          break;
                      }
                    },
                  );
          }),
        ));
  }
}
