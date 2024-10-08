import 'package:flutter/material.dart';
import 'package:oneanime/request/api.dart';
import 'package:oneanime/pages/about/about_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AboutModule extends Module {
  @override
  void binds(i) {
    
  }

  @override
  void routes(r) {
    r.child("/", child: (_) => const AboutPage());
    r.child("/license",
        child: (_) => const LicensePage(
              applicationName: 'oneAnime',
              applicationVersion: Api.version,
            ),
        transition: TransitionType.noTransition);
  }
}
