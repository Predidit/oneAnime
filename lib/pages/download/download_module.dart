import 'package:oneanime/pages/download/download_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DownloadModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const DownloadPage());
  }
}

