import 'package:oneanime/pages/follow/follow_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/follow/follow_controller.dart';

class FollowModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(FollowController.new);
  }

  @override
  void routes(r) {
    r.child("/", child: (_) => const FollowPage());
  }
}
