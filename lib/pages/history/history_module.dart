import 'package:oneanime/pages/history/history_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/history/history_controller.dart';

class HistoryModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(HistoryController.new);
  }

  @override
  void routes(r) {
    r.child("/", child: (_) => const HistoryPage());
  }
}
