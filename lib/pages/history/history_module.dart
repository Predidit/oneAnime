import 'package:oneanime/pages/history/history_page.dart';
import 'package:flutter_modular/flutter_modular.dart';


class HistoryModule extends Module {
  @override
  void binds(i) {
    
  }

  @override
  void routes(r) {
    r.child("/", child: (_) => const HistoryPage(), transition: TransitionType.noTransition);
  }
}
