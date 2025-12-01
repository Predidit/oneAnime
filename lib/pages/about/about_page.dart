import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/request/api.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/pages/my/my_controller.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oneanime/i18n/strings.g.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Box setting = GStorage.setting;
  late dynamic defaultDanmakuArea;
  late dynamic defaultThemeMode;
  late dynamic defaultThemeColor;
  late Translations i18n;
  final MyController _mineController = Modular.get<MyController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    i18n = Translations.of(context);
    return Scaffold(
      appBar: SysAppBar(title: Text(i18n.my.about.title)),
      body: Column(
        children: [
          ListTile(
            title: Text(i18n.my.about.openSourceLicense),
            subtitle: Text(i18n.my.about.openSourceLicenseSubtitle,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.outline)),
            onTap: () {
              Modular.to.pushNamed('/settings/about/license');
            },
          ),
          ListTile(
            onTap: () {
              launchUrl(Uri.parse(Api.sourceUrl),
                  mode: LaunchMode.externalApplication);
            },
            dense: false,
            title: Text(i18n.my.about.GithubRepo),
            trailing: Text('Github',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.outline)),
          ),
          ListTile(
            onTap: () {
              launchUrl(Uri.parse(Api.dandanIndex),
                  mode: LaunchMode.externalApplication);
            },
            dense: false,
            title: Text(i18n.my.about.danmakuSource),
            trailing: Text('DanDanPlay',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.outline)),
          ),
          ListTile(
            onTap: () {
              _mineController.checkUpdata();
            },
            dense: false,
            title: Text(i18n.my.about.checkUpdate),
            trailing: Text('${i18n.my.about.currentVersion} ${Api.version}',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.outline)),
          ),
        ],
      ),
    );
  }
}
