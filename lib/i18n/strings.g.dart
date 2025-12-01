/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 4
/// Strings: 384 (96 per locale)
///
/// Built on 2025-12-01 at 13:41 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	zhCn(languageCode: 'zh', countryCode: 'CN', build: _StringsZhCn.build),
	zhHk(languageCode: 'zh', countryCode: 'HK', build: _StringsZhHk.build),
	zhTw(languageCode: 'zh', countryCode: 'TW', build: _StringsZhTw.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	late final _StringsToastEn toast = _StringsToastEn._(_root);
	late final _StringsDialogEn dialog = _StringsDialogEn._(_root);
	late final _StringsMenuEn menu = _StringsMenuEn._(_root);
	late final _StringsVideoEn video = _StringsVideoEn._(_root);
	late final _StringsAnimeEn anime = _StringsAnimeEn._(_root);
	late final _StringsPopularEn popular = _StringsPopularEn._(_root);
	late final _StringsFavoriteEn favorite = _StringsFavoriteEn._(_root);
	late final _StringsCalendarEn calendar = _StringsCalendarEn._(_root);
	late final _StringsMyEn my = _StringsMyEn._(_root);
}

// Path: toast
class _StringsToastEn {
	_StringsToastEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'Loading';
	String historyToast({required Object episode}) => 'Last watched episode ${episode}';
	String get favoriteToast => 'Make sure to finish watching your favorite shows!';
	String get dismissFavorite => 'Successfully unfollowed';
	String get needReboot => 'Reboot to take effect';
	String get checkUpdateWithNoUpdate => 'You are already on the latest version!';
	String get exitApp => 'Press again to exit the app';
	String get refreshAnimeListWithSuccess => 'List updated successfully';
	String get animeNotExist => 'The first episode of the anime hasn\'t been updated yet >_<';
	String currentEpisode({required Object episode}) => 'Episode ${episode}';
	String get currentEpisodeIsLast => 'This is the latest episode';
	String get danmakuEmpty => 'No comments found for this episode';
	String get danmakuCannotEmpty => 'Comment content cannot be empty';
	String get danmakuTooLong => 'Comment content cannot exceed 100 characters';
	String get danmakuSendSuccess => 'Sent successfully';
}

// Path: dialog
class _StringsDialogEn {
	_StringsDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get confirm => 'Confirm';
	String get dismiss => 'Dismiss';
	String get setDefault => 'Default';
	String get danmakuSending => 'Sending...';
	String get danmakuSend => 'Send';
	String checkUpdateWithUpdate({required Object value}) => 'New version found ${value}';
	String get timeMachine => 'Time Machine';
}

// Path: menu
class _StringsMenuEn {
	_StringsMenuEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get home => 'Home';
	String get calendar => 'Calendar';
	String get favorite => 'Favorite';
	String get my => 'My';
}

// Path: video
class _StringsVideoEn {
	_StringsVideoEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get playSpeed => 'Play Speed';
	String get collection => 'Collection ';
	String playingCollection({required Object title}) => 'Playing: ${title}';
	String get changeEpisode => 'Change Episode';
	String episodeTotal({required Object total}) => 'total ${total} episodes';
}

// Path: anime
class _StringsAnimeEn {
	_StringsAnimeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get anime => 'Anime';
	String get serializing => 'Serializing';
	String get OVA => 'OVA';
	String get OAD => 'OAD';
	String get movie => 'Movie';
	String get year => 'Year';
	late final _StringsAnimeSeaonsEn seaons = _StringsAnimeSeaonsEn._(_root);
	String get singleSeason => 'Season';
}

// Path: popular
class _StringsPopularEn {
	_StringsPopularEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get searchBar => 'Quick search';
	String get empty => 'Empty >_<';
}

// Path: favorite
class _StringsFavoriteEn {
	_StringsFavoriteEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Favorite';
	String get empty => 'Ah (⊙.⊙) There is no follow-up talk';
}

// Path: calendar
class _StringsCalendarEn {
	_StringsCalendarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Calendar';
	String get empty => 'The data has not been updated yet (´;ω;`)';
}

// Path: my
class _StringsMyEn {
	_StringsMyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get private => 'Private Mode';
	String get privateSubtitle => 'won\'t save any watching history';
	late final _StringsMyHistoryEn history = _StringsMyHistoryEn._(_root);
	late final _StringsMyPlayerSettingsEn playerSettings = _StringsMyPlayerSettingsEn._(_root);
	late final _StringsMyDanmakuSettingsEn danmakuSettings = _StringsMyDanmakuSettingsEn._(_root);
	late final _StringsMyThemeSettingsEn themeSettings = _StringsMyThemeSettingsEn._(_root);
	late final _StringsMyOtherSettingsEn otherSettings = _StringsMyOtherSettingsEn._(_root);
	late final _StringsMyAboutEn about = _StringsMyAboutEn._(_root);
}

// Path: anime.seaons
class _StringsAnimeSeaonsEn {
	_StringsAnimeSeaonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get spring => 'Spring';
	String get summer => 'Summer';
	String get autumn => 'Autumn';
	String get winter => 'Winter';
}

// Path: my.history
class _StringsMyHistoryEn {
	_StringsMyHistoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'History';
	String get empty => 'Ah Lie (⊙.⊙) There is no viewing record.';
}

// Path: my.playerSettings
class _StringsMyPlayerSettingsEn {
	_StringsMyPlayerSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Player Settings';
	String get hardwareAcceleration => 'Hardware Acceleration';
	String get autoPlay => 'Auto Play';
	String get autoJump => 'Auto Jump';
	String get autoJumpSubtitle => 'Jump to the position where you stopped last time';
}

// Path: my.danmakuSettings
class _StringsMyDanmakuSettingsEn {
	_StringsMyDanmakuSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Danmaku Settings';
	String get defaultEnable => 'Default Enable';
	String get defaultEnableSubtitle => 'Whether to enable danmaku by default';
	String get enhance => 'Enhance';
	String get stroke => 'Stroke';
	String get fontSize => 'Font Size';
	String get transparency => 'Transparency';
	String get duration => 'Duration';
	String get area => 'Area';
	String areaSubtitleOccupy({required Object value}) => 'Occupy ${value} screen';
}

// Path: my.themeSettings
class _StringsMyThemeSettingsEn {
	_StringsMyThemeSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Theme Settings';
	String get colorPalette => 'Color Palette';
	String get refreshRate => 'Refresh Rate';
	String get refreshRateWarning => 'Not working? Try to restart the app';
	String get refreshRateAuto => 'Auto';
	String get themeMode => 'Theme Mode';
	String get useSystemFont => 'Use System Font';
	String get themeModeSystem => 'System';
	String get themeModeLight => 'Light';
	String get themeModeDark => 'Dark';
	String get OLEDEnhance => 'OLEDEnhance';
	String get OLEDEnhanceSubtitle => 'Use pure black to enhance the OLED effect';
	String get alwaysOntop => 'Always On Top';
	String get alwaysOntopSubtitle => 'Always stay on top of other windows while playing';
}

// Path: my.otherSettings
class _StringsMyOtherSettingsEn {
	_StringsMyOtherSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Other Settings';
	String get searchEnhace => 'Search Enhance';
	String get searchEnhaceSubtitle => 'Auto translate search keywords';
	String get proxySettings => 'Proxy Settings';
	String get proxyHost => 'Proxy Host';
	String get proxyPort => 'Proxy Port';
	String get proxyEnable => 'Proxy Enable';
	String get autoUpdate => 'Auto Update';
}

// Path: my.about
class _StringsMyAboutEn {
	_StringsMyAboutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'About';
	String get openSourceLicense => 'Open Source License';
	String get openSourceLicenseSubtitle => 'View all open source licenses';
	String get GithubRepo => 'Github Repo';
	String get danmakuSource => 'Danmaku Source';
	String get checkUpdate => 'Check Update';
	String get currentVersion => 'Current Version';
}

// Path: <root>
class _StringsZhCn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsZhCn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhCn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-CN>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsZhCn _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsToastZhCn toast = _StringsToastZhCn._(_root);
	@override late final _StringsDialogZhCn dialog = _StringsDialogZhCn._(_root);
	@override late final _StringsMenuZhCn menu = _StringsMenuZhCn._(_root);
	@override late final _StringsVideoZhCn video = _StringsVideoZhCn._(_root);
	@override late final _StringsAnimeZhCn anime = _StringsAnimeZhCn._(_root);
	@override late final _StringsPopularZhCn popular = _StringsPopularZhCn._(_root);
	@override late final _StringsFavoriteZhCn favorite = _StringsFavoriteZhCn._(_root);
	@override late final _StringsCalendarZhCn calendar = _StringsCalendarZhCn._(_root);
	@override late final _StringsMyZhCn my = _StringsMyZhCn._(_root);
}

// Path: toast
class _StringsToastZhCn implements _StringsToastEn {
	_StringsToastZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get loading => '获取中';
	@override String historyToast({required Object episode}) => '上次观看到第 ${episode} 话';
	@override String get favoriteToast => '自己追的番要好好看完哦';
	@override String get dismissFavorite => '取消追番成功';
	@override String get needReboot => '重启生效';
	@override String get checkUpdateWithNoUpdate => '当前已经是最新版本！';
	@override String get exitApp => '再按一次退出应用';
	@override String get refreshAnimeListWithSuccess => '列表更新完成';
	@override String get animeNotExist => '动画还沒有更新第一集 >_<';
	@override String currentEpisode({required Object episode}) => '第 ${episode} 话';
	@override String get currentEpisodeIsLast => '已经是最新一集';
	@override String get danmakuEmpty => '当前剧集没有找到弹幕的说';
	@override String get danmakuCannotEmpty => '弹幕内容不能为空';
	@override String get danmakuTooLong => '弹幕内容不能超过100个字符';
	@override String get danmakuSendSuccess => '发送成功';
}

// Path: dialog
class _StringsDialogZhCn implements _StringsDialogEn {
	_StringsDialogZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get confirm => '确认';
	@override String get dismiss => '取消';
	@override String get setDefault => '默认设置';
	@override String get danmakuSending => '发送中...';
	@override String get danmakuSend => '发送';
	@override String checkUpdateWithUpdate({required Object value}) => '发现新版本 ${value}';
	@override String get timeMachine => '时间机器';
}

// Path: menu
class _StringsMenuZhCn implements _StringsMenuEn {
	_StringsMenuZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get home => '推荐';
	@override String get calendar => '时间表';
	@override String get favorite => '追番';
	@override String get my => '我的';
}

// Path: video
class _StringsVideoZhCn implements _StringsVideoEn {
	_StringsVideoZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get playSpeed => '播放速度';
	@override String get collection => '合集 ';
	@override String playingCollection({required Object title}) => '正在播放 ${title}';
	@override String get changeEpisode => '切换选集';
	@override String episodeTotal({required Object total}) => '全 ${total} 话';
}

// Path: anime
class _StringsAnimeZhCn implements _StringsAnimeEn {
	_StringsAnimeZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get anime => '新番';
	@override String get serializing => '连载中';
	@override String get OVA => 'OVA';
	@override String get OAD => 'OAD';
	@override String get movie => '剧场版';
	@override String get year => '年';
	@override late final _StringsAnimeSeaonsZhCn seaons = _StringsAnimeSeaonsZhCn._(_root);
	@override String get singleSeason => '季';
}

// Path: popular
class _StringsPopularZhCn implements _StringsPopularEn {
	_StringsPopularZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get searchBar => '快速搜索';
	@override String get empty => '空空如也 >_<';
}

// Path: favorite
class _StringsFavoriteZhCn implements _StringsFavoriteEn {
	_StringsFavoriteZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '追番';
	@override String get empty => '啊咧（⊙.⊙） 没有追番的说';
}

// Path: calendar
class _StringsCalendarZhCn implements _StringsCalendarEn {
	_StringsCalendarZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '时间表';
	@override String get empty => '数据还没有更新 (´;ω;`)';
}

// Path: my
class _StringsMyZhCn implements _StringsMyEn {
	_StringsMyZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get private => '隐身模式';
	@override String get privateSubtitle => '不保留观看记录';
	@override late final _StringsMyHistoryZhCn history = _StringsMyHistoryZhCn._(_root);
	@override late final _StringsMyPlayerSettingsZhCn playerSettings = _StringsMyPlayerSettingsZhCn._(_root);
	@override late final _StringsMyDanmakuSettingsZhCn danmakuSettings = _StringsMyDanmakuSettingsZhCn._(_root);
	@override late final _StringsMyThemeSettingsZhCn themeSettings = _StringsMyThemeSettingsZhCn._(_root);
	@override late final _StringsMyOtherSettingsZhCn otherSettings = _StringsMyOtherSettingsZhCn._(_root);
	@override late final _StringsMyAboutZhCn about = _StringsMyAboutZhCn._(_root);
}

// Path: anime.seaons
class _StringsAnimeSeaonsZhCn implements _StringsAnimeSeaonsEn {
	_StringsAnimeSeaonsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get spring => '春';
	@override String get summer => '夏';
	@override String get autumn => '秋';
	@override String get winter => '冬';
}

// Path: my.history
class _StringsMyHistoryZhCn implements _StringsMyHistoryEn {
	_StringsMyHistoryZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '历史记录';
	@override String get empty => '啊咧（⊙.⊙） 没有观看记录的说';
}

// Path: my.playerSettings
class _StringsMyPlayerSettingsZhCn implements _StringsMyPlayerSettingsEn {
	_StringsMyPlayerSettingsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '播放设置';
	@override String get hardwareAcceleration => '硬件解码';
	@override String get autoPlay => '自动播放';
	@override String get autoJump => '自动跳转';
	@override String get autoJumpSubtitle => '跳转到上次播放位置';
}

// Path: my.danmakuSettings
class _StringsMyDanmakuSettingsZhCn implements _StringsMyDanmakuSettingsEn {
	_StringsMyDanmakuSettingsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '弹幕设置';
	@override String get defaultEnable => '默认开启';
	@override String get defaultEnableSubtitle => '默认是否随视频播放弹幕';
	@override String get enhance => '精准匹配';
	@override String get stroke => '弹幕描边';
	@override String get fontSize => '字体大小';
	@override String get transparency => '弹幕不透明度';
	@override String get duration => '弹幕时长';
	@override String get area => '弹幕区域';
	@override String areaSubtitleOccupy({required Object value}) => '占据 ${value} 屏幕';
}

// Path: my.themeSettings
class _StringsMyThemeSettingsZhCn implements _StringsMyThemeSettingsEn {
	_StringsMyThemeSettingsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '外观设置';
	@override String get colorPalette => '配色方案';
	@override String get refreshRate => '屏幕帧率';
	@override String get refreshRateWarning => '没有生效？重启应用试试';
	@override String get refreshRateAuto => '自动';
	@override String get themeMode => '主题模式';
	@override String get useSystemFont => '使用系统字体';
	@override String get themeModeSystem => '跟随系统';
	@override String get themeModeLight => '浅色';
	@override String get themeModeDark => '深色';
	@override String get OLEDEnhance => 'OLED优化';
	@override String get OLEDEnhanceSubtitle => '深色模式下使用纯黑背景';
	@override String get alwaysOntop => '窗口置顶';
	@override String get alwaysOntopSubtitle => '播放时始终保持在其他窗口上方';
}

// Path: my.otherSettings
class _StringsMyOtherSettingsZhCn implements _StringsMyOtherSettingsEn {
	_StringsMyOtherSettingsZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '其他设置';
	@override String get searchEnhace => '搜索优化';
	@override String get searchEnhaceSubtitle => '自动翻译关键词';
	@override String get proxySettings => '配置代理';
	@override String get proxyHost => '代理主机';
	@override String get proxyPort => '代理端口';
	@override String get proxyEnable => '启用代理';
	@override String get autoUpdate => '自动更新';
}

// Path: my.about
class _StringsMyAboutZhCn implements _StringsMyAboutEn {
	_StringsMyAboutZhCn._(this._root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '关于';
	@override String get openSourceLicense => '开源许可证';
	@override String get openSourceLicenseSubtitle => '查看所有开源许可证';
	@override String get GithubRepo => '项目主页';
	@override String get danmakuSource => '弹幕来源';
	@override String get checkUpdate => '检查更新';
	@override String get currentVersion => '当前版本';
}

// Path: <root>
class _StringsZhHk implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsZhHk.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhHk,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-HK>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsZhHk _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsToastZhHk toast = _StringsToastZhHk._(_root);
	@override late final _StringsDialogZhHk dialog = _StringsDialogZhHk._(_root);
	@override late final _StringsMenuZhHk menu = _StringsMenuZhHk._(_root);
	@override late final _StringsVideoZhHk video = _StringsVideoZhHk._(_root);
	@override late final _StringsAnimeZhHk anime = _StringsAnimeZhHk._(_root);
	@override late final _StringsPopularZhHk popular = _StringsPopularZhHk._(_root);
	@override late final _StringsFavoriteZhHk favorite = _StringsFavoriteZhHk._(_root);
	@override late final _StringsCalendarZhHk calendar = _StringsCalendarZhHk._(_root);
	@override late final _StringsMyZhHk my = _StringsMyZhHk._(_root);
}

// Path: toast
class _StringsToastZhHk implements _StringsToastEn {
	_StringsToastZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get loading => '加載中';
	@override String historyToast({required Object episode}) => '上次觀看到第 ${episode} 集';
	@override String get favoriteToast => '自己追的番要好好看完哦';
	@override String get dismissFavorite => '取消追番成功';
	@override String get needReboot => '重啟生效';
	@override String get checkUpdateWithNoUpdate => '當前已經是最新版本！';
	@override String get exitApp => '再按一次退出應用';
	@override String get refreshAnimeListWithSuccess => '列表更新完成';
	@override String get animeNotExist => '動畫還沒有更新第一集 >_<';
	@override String currentEpisode({required Object episode}) => '第 ${episode} 話';
	@override String get currentEpisodeIsLast => '已經是最新一集';
	@override String get danmakuEmpty => '當前劇集沒有找到彈幕的說';
	@override String get danmakuCannotEmpty => '彈幕內容不能為空';
	@override String get danmakuTooLong => '彈幕內容不能超過100個字符';
	@override String get danmakuSendSuccess => '發送成功';
}

// Path: dialog
class _StringsDialogZhHk implements _StringsDialogEn {
	_StringsDialogZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get confirm => '確認';
	@override String get dismiss => '取消';
	@override String get setDefault => '預設設定';
	@override String get danmakuSending => '發送中...';
	@override String get danmakuSend => '發送';
	@override String checkUpdateWithUpdate({required Object value}) => '發現新版本 ${value}';
	@override String get timeMachine => '時間機器';
}

// Path: menu
class _StringsMenuZhHk implements _StringsMenuEn {
	_StringsMenuZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get home => '推薦';
	@override String get calendar => '時間表';
	@override String get favorite => '追番';
	@override String get my => '我的';
}

// Path: video
class _StringsVideoZhHk implements _StringsVideoEn {
	_StringsVideoZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get playSpeed => '播放速度';
	@override String get collection => '合集 ';
	@override String playingCollection({required Object title}) => '正在播放 ${title}';
	@override String get changeEpisode => '切換選集';
	@override String episodeTotal({required Object total}) => '全 ${total} 話';
}

// Path: anime
class _StringsAnimeZhHk implements _StringsAnimeEn {
	_StringsAnimeZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get anime => '新番';
	@override String get serializing => '連載中';
	@override String get OVA => 'OVA';
	@override String get OAD => 'OAD';
	@override String get movie => '劇場版';
	@override String get year => '年';
	@override late final _StringsAnimeSeaonsZhHk seaons = _StringsAnimeSeaonsZhHk._(_root);
	@override String get singleSeason => '季';
}

// Path: popular
class _StringsPopularZhHk implements _StringsPopularEn {
	_StringsPopularZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get searchBar => '快速搜尋';
	@override String get empty => '空空如也 >_<';
}

// Path: favorite
class _StringsFavoriteZhHk implements _StringsFavoriteEn {
	_StringsFavoriteZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get title => '追番';
	@override String get empty => '啊咧（⊙.⊙） 沒有追番的說';
}

// Path: calendar
class _StringsCalendarZhHk implements _StringsCalendarEn {
	_StringsCalendarZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get title => '時間表';
	@override String get empty => '數據還沒有更新 (´;ω;)';
}

// Path: my
class _StringsMyZhHk implements _StringsMyEn {
	_StringsMyZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get private => '隱身模式';
	@override String get privateSubtitle => '不保留觀看記錄';
	@override late final _StringsMyHistoryZhHk history = _StringsMyHistoryZhHk._(_root);
	@override late final _StringsMyPlayerSettingsZhHk playerSettings = _StringsMyPlayerSettingsZhHk._(_root);
	@override late final _StringsMyDanmakuSettingsZhHk danmakuSettings = _StringsMyDanmakuSettingsZhHk._(_root);
	@override late final _StringsMyThemeSettingsZhHk themeSettings = _StringsMyThemeSettingsZhHk._(_root);
	@override late final _StringsMyOtherSettingsZhHk otherSettings = _StringsMyOtherSettingsZhHk._(_root);
	@override late final _StringsMyAboutZhHk about = _StringsMyAboutZhHk._(_root);
}

// Path: anime.seaons
class _StringsAnimeSeaonsZhHk implements _StringsAnimeSeaonsEn {
	_StringsAnimeSeaonsZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get spring => '春';
	@override String get summer => '夏';
	@override String get autumn => '秋';
	@override String get winter => '冬';
}

// Path: my.history
class _StringsMyHistoryZhHk implements _StringsMyHistoryEn {
	_StringsMyHistoryZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get title => '歷史記錄';
	@override String get empty => '啊咧（⊙.⊙） 沒有觀看記錄的說';
}

// Path: my.playerSettings
class _StringsMyPlayerSettingsZhHk implements _StringsMyPlayerSettingsEn {
	_StringsMyPlayerSettingsZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get title => '播放設置';
	@override String get hardwareAcceleration => '硬件解碼';
	@override String get autoPlay => '自動播放';
	@override String get autoJump => '自動跳轉';
	@override String get autoJumpSubtitle => '跳轉到上次播放位置';
}

// Path: my.danmakuSettings
class _StringsMyDanmakuSettingsZhHk implements _StringsMyDanmakuSettingsEn {
	_StringsMyDanmakuSettingsZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get title => '彈幕設置';
	@override String get defaultEnable => '默認開啟';
	@override String get defaultEnableSubtitle => '默認是否隨視頻播放彈幕';
	@override String get enhance => '精準匹配';
	@override String get stroke => '彈幕描邊';
	@override String get fontSize => '字體大小';
	@override String get transparency => '彈幕不透明度';
	@override String get duration => '彈幕時長';
	@override String get area => '彈幕區域';
	@override String areaSubtitleOccupy({required Object value}) => '佔據 ${value} 屏幕';
}

// Path: my.themeSettings
class _StringsMyThemeSettingsZhHk implements _StringsMyThemeSettingsEn {
	_StringsMyThemeSettingsZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get title => '外觀設置';
	@override String get colorPalette => '配色方案';
	@override String get refreshRate => '屏幕幀率';
	@override String get refreshRateWarning => '沒有生效？重啟應用試試';
	@override String get refreshRateAuto => '自動';
	@override String get themeMode => '主題模式';
	@override String get useSystemFont => '使用系統字體';
	@override String get themeModeSystem => '跟隨系統';
	@override String get themeModeLight => '淺色';
	@override String get themeModeDark => '深色';
	@override String get OLEDEnhance => 'OLED優化';
	@override String get OLEDEnhanceSubtitle => '深色模式下使用純黑背景';
	@override String get alwaysOntop => '視窗置頂';
	@override String get alwaysOntopSubtitle => '播放時始終保持在其他視窗上方';
}

// Path: my.otherSettings
class _StringsMyOtherSettingsZhHk implements _StringsMyOtherSettingsEn {
	_StringsMyOtherSettingsZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get title => '其他設置';
	@override String get searchEnhace => '搜索優化';
	@override String get searchEnhaceSubtitle => '自動翻譯關鍵詞';
	@override String get proxySettings => '配置代理';
	@override String get proxyHost => '代理主機';
	@override String get proxyPort => '代理端口';
	@override String get proxyEnable => '啟用代理';
	@override String get autoUpdate => '自動更新';
}

// Path: my.about
class _StringsMyAboutZhHk implements _StringsMyAboutEn {
	_StringsMyAboutZhHk._(this._root);

	@override final _StringsZhHk _root; // ignore: unused_field

	// Translations
	@override String get title => '關於';
	@override String get openSourceLicense => '開源許可證';
	@override String get openSourceLicenseSubtitle => '查看所有開源許可證';
	@override String get GithubRepo => '專案首頁';
	@override String get danmakuSource => '彈幕來源';
	@override String get checkUpdate => '檢查更新';
	@override String get currentVersion => '當前版本';
}

// Path: <root>
class _StringsZhTw implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsZhTw.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhTw,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-TW>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsZhTw _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsToastZhTw toast = _StringsToastZhTw._(_root);
	@override late final _StringsDialogZhTw dialog = _StringsDialogZhTw._(_root);
	@override late final _StringsMenuZhTw menu = _StringsMenuZhTw._(_root);
	@override late final _StringsVideoZhTw video = _StringsVideoZhTw._(_root);
	@override late final _StringsAnimeZhTw anime = _StringsAnimeZhTw._(_root);
	@override late final _StringsPopularZhTw popular = _StringsPopularZhTw._(_root);
	@override late final _StringsFavoriteZhTw favorite = _StringsFavoriteZhTw._(_root);
	@override late final _StringsCalendarZhTw calendar = _StringsCalendarZhTw._(_root);
	@override late final _StringsMyZhTw my = _StringsMyZhTw._(_root);
}

// Path: toast
class _StringsToastZhTw implements _StringsToastEn {
	_StringsToastZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '加載中';
	@override String historyToast({required Object episode}) => '上次觀看到第 ${episode} 集';
	@override String get favoriteToast => '自己追的番要好好看完哦';
	@override String get dismissFavorite => '取消追番成功';
	@override String get needReboot => '重啟生效';
	@override String get checkUpdateWithNoUpdate => '當前已經是最新版本！';
	@override String get exitApp => '再按一次退出應用';
	@override String get refreshAnimeListWithSuccess => '列表更新完成';
	@override String get animeNotExist => '動畫還沒有更新第一集 >_<';
	@override String currentEpisode({required Object episode}) => '第 ${episode} 話';
	@override String get currentEpisodeIsLast => '已經是最新一集';
	@override String get danmakuEmpty => '當前劇集沒有找到彈幕的說';
	@override String get danmakuCannotEmpty => '彈幕內容不能為空';
	@override String get danmakuTooLong => '彈幕內容不能超過100個字符';
	@override String get danmakuSendSuccess => '發送成功';
}

// Path: dialog
class _StringsDialogZhTw implements _StringsDialogEn {
	_StringsDialogZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get confirm => '確認';
	@override String get dismiss => '取消';
	@override String get setDefault => '預設設定';
	@override String get danmakuSending => '發送中...';
	@override String get danmakuSend => '發送';
	@override String checkUpdateWithUpdate({required Object value}) => '發現新版本 ${value}';
	@override String get timeMachine => '時間機器';
}

// Path: menu
class _StringsMenuZhTw implements _StringsMenuEn {
	_StringsMenuZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get home => '推薦';
	@override String get calendar => '時間表';
	@override String get favorite => '追番';
	@override String get my => '我的';
}

// Path: video
class _StringsVideoZhTw implements _StringsVideoEn {
	_StringsVideoZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get playSpeed => '播放速度';
	@override String get collection => '合集 ';
	@override String playingCollection({required Object title}) => '正在播放 ${title}';
	@override String get changeEpisode => '切換選集';
	@override String episodeTotal({required Object total}) => '全 ${total} 話';
}

// Path: anime
class _StringsAnimeZhTw implements _StringsAnimeEn {
	_StringsAnimeZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get anime => '新番';
	@override String get serializing => '連載中';
	@override String get OVA => 'OVA';
	@override String get OAD => 'OAD';
	@override String get movie => '劇場版';
	@override String get year => '年';
	@override late final _StringsAnimeSeaonsZhTw seaons = _StringsAnimeSeaonsZhTw._(_root);
	@override String get singleSeason => '季';
}

// Path: popular
class _StringsPopularZhTw implements _StringsPopularEn {
	_StringsPopularZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get searchBar => '快速搜尋';
	@override String get empty => '空空如也 >_<';
}

// Path: favorite
class _StringsFavoriteZhTw implements _StringsFavoriteEn {
	_StringsFavoriteZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '追番';
	@override String get empty => '啊咧（⊙.⊙） 沒有追番的說';
}

// Path: calendar
class _StringsCalendarZhTw implements _StringsCalendarEn {
	_StringsCalendarZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '時間表';
	@override String get empty => '數據還沒有更新 (´;ω;)';
}

// Path: my
class _StringsMyZhTw implements _StringsMyEn {
	_StringsMyZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get private => '隱身模式';
	@override String get privateSubtitle => '不保留觀看記錄';
	@override late final _StringsMyHistoryZhTw history = _StringsMyHistoryZhTw._(_root);
	@override late final _StringsMyPlayerSettingsZhTw playerSettings = _StringsMyPlayerSettingsZhTw._(_root);
	@override late final _StringsMyDanmakuSettingsZhTw danmakuSettings = _StringsMyDanmakuSettingsZhTw._(_root);
	@override late final _StringsMyThemeSettingsZhTw themeSettings = _StringsMyThemeSettingsZhTw._(_root);
	@override late final _StringsMyOtherSettingsZhTw otherSettings = _StringsMyOtherSettingsZhTw._(_root);
	@override late final _StringsMyAboutZhTw about = _StringsMyAboutZhTw._(_root);
}

// Path: anime.seaons
class _StringsAnimeSeaonsZhTw implements _StringsAnimeSeaonsEn {
	_StringsAnimeSeaonsZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get spring => '春';
	@override String get summer => '夏';
	@override String get autumn => '秋';
	@override String get winter => '冬';
}

// Path: my.history
class _StringsMyHistoryZhTw implements _StringsMyHistoryEn {
	_StringsMyHistoryZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '歷史記錄';
	@override String get empty => '啊咧（⊙.⊙） 沒有觀看記錄的說';
}

// Path: my.playerSettings
class _StringsMyPlayerSettingsZhTw implements _StringsMyPlayerSettingsEn {
	_StringsMyPlayerSettingsZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '播放設置';
	@override String get hardwareAcceleration => '硬件解碼';
	@override String get autoPlay => '自動播放';
	@override String get autoJump => '自動跳轉';
	@override String get autoJumpSubtitle => '跳轉到上次播放位置';
}

// Path: my.danmakuSettings
class _StringsMyDanmakuSettingsZhTw implements _StringsMyDanmakuSettingsEn {
	_StringsMyDanmakuSettingsZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '彈幕設置';
	@override String get defaultEnable => '默認開啟';
	@override String get defaultEnableSubtitle => '默認是否隨視頻播放彈幕';
	@override String get enhance => '精準匹配';
	@override String get stroke => '彈幕描邊';
	@override String get fontSize => '字體大小';
	@override String get transparency => '彈幕不透明度';
	@override String get duration => '彈幕時長';
	@override String get area => '彈幕區域';
	@override String areaSubtitleOccupy({required Object value}) => '佔據 ${value} 屏幕';
}

// Path: my.themeSettings
class _StringsMyThemeSettingsZhTw implements _StringsMyThemeSettingsEn {
	_StringsMyThemeSettingsZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '外觀設置';
	@override String get colorPalette => '配色方案';
	@override String get refreshRate => '屏幕幀率';
	@override String get refreshRateWarning => '沒有生效？重啟應用試試';
	@override String get refreshRateAuto => '自動';
	@override String get themeMode => '主題模式';
	@override String get useSystemFont => '使用系統字體';
	@override String get themeModeSystem => '跟隨系統';
	@override String get themeModeLight => '淺色';
	@override String get themeModeDark => '深色';
	@override String get OLEDEnhance => 'OLED優化';
	@override String get OLEDEnhanceSubtitle => '深色模式下使用純黑背景';
	@override String get alwaysOntop => '視窗置頂';
	@override String get alwaysOntopSubtitle => '播放時始終保持在其他視窗上方';
}

// Path: my.otherSettings
class _StringsMyOtherSettingsZhTw implements _StringsMyOtherSettingsEn {
	_StringsMyOtherSettingsZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '其他設置';
	@override String get searchEnhace => '搜索優化';
	@override String get searchEnhaceSubtitle => '自動翻譯關鍵詞';
	@override String get proxySettings => '配置代理';
	@override String get proxyHost => '代理主機';
	@override String get proxyPort => '代理端口';
	@override String get proxyEnable => '啟用代理';
	@override String get autoUpdate => '自動更新';
}

// Path: my.about
class _StringsMyAboutZhTw implements _StringsMyAboutEn {
	_StringsMyAboutZhTw._(this._root);

	@override final _StringsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '關於';
	@override String get openSourceLicense => '開源許可證';
	@override String get openSourceLicenseSubtitle => '查看所有開源許可證';
	@override String get GithubRepo => '專案首頁';
	@override String get danmakuSource => '彈幕來源';
	@override String get checkUpdate => '檢查更新';
	@override String get currentVersion => '當前版本';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'toast.loading': return 'Loading';
			case 'toast.historyToast': return ({required Object episode}) => 'Last watched episode ${episode}';
			case 'toast.favoriteToast': return 'Make sure to finish watching your favorite shows!';
			case 'toast.dismissFavorite': return 'Successfully unfollowed';
			case 'toast.needReboot': return 'Reboot to take effect';
			case 'toast.checkUpdateWithNoUpdate': return 'You are already on the latest version!';
			case 'toast.exitApp': return 'Press again to exit the app';
			case 'toast.refreshAnimeListWithSuccess': return 'List updated successfully';
			case 'toast.animeNotExist': return 'The first episode of the anime hasn\'t been updated yet >_<';
			case 'toast.currentEpisode': return ({required Object episode}) => 'Episode ${episode}';
			case 'toast.currentEpisodeIsLast': return 'This is the latest episode';
			case 'toast.danmakuEmpty': return 'No comments found for this episode';
			case 'toast.danmakuCannotEmpty': return 'Comment content cannot be empty';
			case 'toast.danmakuTooLong': return 'Comment content cannot exceed 100 characters';
			case 'toast.danmakuSendSuccess': return 'Sent successfully';
			case 'dialog.confirm': return 'Confirm';
			case 'dialog.dismiss': return 'Dismiss';
			case 'dialog.setDefault': return 'Default';
			case 'dialog.danmakuSending': return 'Sending...';
			case 'dialog.danmakuSend': return 'Send';
			case 'dialog.checkUpdateWithUpdate': return ({required Object value}) => 'New version found ${value}';
			case 'dialog.timeMachine': return 'Time Machine';
			case 'menu.home': return 'Home';
			case 'menu.calendar': return 'Calendar';
			case 'menu.favorite': return 'Favorite';
			case 'menu.my': return 'My';
			case 'video.playSpeed': return 'Play Speed';
			case 'video.collection': return 'Collection ';
			case 'video.playingCollection': return ({required Object title}) => 'Playing: ${title}';
			case 'video.changeEpisode': return 'Change Episode';
			case 'video.episodeTotal': return ({required Object total}) => 'total ${total} episodes';
			case 'anime.anime': return 'Anime';
			case 'anime.serializing': return 'Serializing';
			case 'anime.OVA': return 'OVA';
			case 'anime.OAD': return 'OAD';
			case 'anime.movie': return 'Movie';
			case 'anime.year': return 'Year';
			case 'anime.seaons.spring': return 'Spring';
			case 'anime.seaons.summer': return 'Summer';
			case 'anime.seaons.autumn': return 'Autumn';
			case 'anime.seaons.winter': return 'Winter';
			case 'anime.singleSeason': return 'Season';
			case 'popular.searchBar': return 'Quick search';
			case 'popular.empty': return 'Empty >_<';
			case 'favorite.title': return 'Favorite';
			case 'favorite.empty': return 'Ah (⊙.⊙) There is no follow-up talk';
			case 'calendar.title': return 'Calendar';
			case 'calendar.empty': return 'The data has not been updated yet (´;ω;`)';
			case 'my.private': return 'Private Mode';
			case 'my.privateSubtitle': return 'won\'t save any watching history';
			case 'my.history.title': return 'History';
			case 'my.history.empty': return 'Ah Lie (⊙.⊙) There is no viewing record.';
			case 'my.playerSettings.title': return 'Player Settings';
			case 'my.playerSettings.hardwareAcceleration': return 'Hardware Acceleration';
			case 'my.playerSettings.autoPlay': return 'Auto Play';
			case 'my.playerSettings.autoJump': return 'Auto Jump';
			case 'my.playerSettings.autoJumpSubtitle': return 'Jump to the position where you stopped last time';
			case 'my.danmakuSettings.title': return 'Danmaku Settings';
			case 'my.danmakuSettings.defaultEnable': return 'Default Enable';
			case 'my.danmakuSettings.defaultEnableSubtitle': return 'Whether to enable danmaku by default';
			case 'my.danmakuSettings.enhance': return 'Enhance';
			case 'my.danmakuSettings.stroke': return 'Stroke';
			case 'my.danmakuSettings.fontSize': return 'Font Size';
			case 'my.danmakuSettings.transparency': return 'Transparency';
			case 'my.danmakuSettings.duration': return 'Duration';
			case 'my.danmakuSettings.area': return 'Area';
			case 'my.danmakuSettings.areaSubtitleOccupy': return ({required Object value}) => 'Occupy ${value} screen';
			case 'my.themeSettings.title': return 'Theme Settings';
			case 'my.themeSettings.colorPalette': return 'Color Palette';
			case 'my.themeSettings.refreshRate': return 'Refresh Rate';
			case 'my.themeSettings.refreshRateWarning': return 'Not working? Try to restart the app';
			case 'my.themeSettings.refreshRateAuto': return 'Auto';
			case 'my.themeSettings.themeMode': return 'Theme Mode';
			case 'my.themeSettings.useSystemFont': return 'Use System Font';
			case 'my.themeSettings.themeModeSystem': return 'System';
			case 'my.themeSettings.themeModeLight': return 'Light';
			case 'my.themeSettings.themeModeDark': return 'Dark';
			case 'my.themeSettings.OLEDEnhance': return 'OLEDEnhance';
			case 'my.themeSettings.OLEDEnhanceSubtitle': return 'Use pure black to enhance the OLED effect';
			case 'my.themeSettings.alwaysOntop': return 'Always On Top';
			case 'my.themeSettings.alwaysOntopSubtitle': return 'Always stay on top of other windows while playing';
			case 'my.otherSettings.title': return 'Other Settings';
			case 'my.otherSettings.searchEnhace': return 'Search Enhance';
			case 'my.otherSettings.searchEnhaceSubtitle': return 'Auto translate search keywords';
			case 'my.otherSettings.proxySettings': return 'Proxy Settings';
			case 'my.otherSettings.proxyHost': return 'Proxy Host';
			case 'my.otherSettings.proxyPort': return 'Proxy Port';
			case 'my.otherSettings.proxyEnable': return 'Proxy Enable';
			case 'my.otherSettings.autoUpdate': return 'Auto Update';
			case 'my.about.title': return 'About';
			case 'my.about.openSourceLicense': return 'Open Source License';
			case 'my.about.openSourceLicenseSubtitle': return 'View all open source licenses';
			case 'my.about.GithubRepo': return 'Github Repo';
			case 'my.about.danmakuSource': return 'Danmaku Source';
			case 'my.about.checkUpdate': return 'Check Update';
			case 'my.about.currentVersion': return 'Current Version';
			default: return null;
		}
	}
}

extension on _StringsZhCn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'toast.loading': return '获取中';
			case 'toast.historyToast': return ({required Object episode}) => '上次观看到第 ${episode} 话';
			case 'toast.favoriteToast': return '自己追的番要好好看完哦';
			case 'toast.dismissFavorite': return '取消追番成功';
			case 'toast.needReboot': return '重启生效';
			case 'toast.checkUpdateWithNoUpdate': return '当前已经是最新版本！';
			case 'toast.exitApp': return '再按一次退出应用';
			case 'toast.refreshAnimeListWithSuccess': return '列表更新完成';
			case 'toast.animeNotExist': return '动画还沒有更新第一集 >_<';
			case 'toast.currentEpisode': return ({required Object episode}) => '第 ${episode} 话';
			case 'toast.currentEpisodeIsLast': return '已经是最新一集';
			case 'toast.danmakuEmpty': return '当前剧集没有找到弹幕的说';
			case 'toast.danmakuCannotEmpty': return '弹幕内容不能为空';
			case 'toast.danmakuTooLong': return '弹幕内容不能超过100个字符';
			case 'toast.danmakuSendSuccess': return '发送成功';
			case 'dialog.confirm': return '确认';
			case 'dialog.dismiss': return '取消';
			case 'dialog.setDefault': return '默认设置';
			case 'dialog.danmakuSending': return '发送中...';
			case 'dialog.danmakuSend': return '发送';
			case 'dialog.checkUpdateWithUpdate': return ({required Object value}) => '发现新版本 ${value}';
			case 'dialog.timeMachine': return '时间机器';
			case 'menu.home': return '推荐';
			case 'menu.calendar': return '时间表';
			case 'menu.favorite': return '追番';
			case 'menu.my': return '我的';
			case 'video.playSpeed': return '播放速度';
			case 'video.collection': return '合集 ';
			case 'video.playingCollection': return ({required Object title}) => '正在播放 ${title}';
			case 'video.changeEpisode': return '切换选集';
			case 'video.episodeTotal': return ({required Object total}) => '全 ${total} 话';
			case 'anime.anime': return '新番';
			case 'anime.serializing': return '连载中';
			case 'anime.OVA': return 'OVA';
			case 'anime.OAD': return 'OAD';
			case 'anime.movie': return '剧场版';
			case 'anime.year': return '年';
			case 'anime.seaons.spring': return '春';
			case 'anime.seaons.summer': return '夏';
			case 'anime.seaons.autumn': return '秋';
			case 'anime.seaons.winter': return '冬';
			case 'anime.singleSeason': return '季';
			case 'popular.searchBar': return '快速搜索';
			case 'popular.empty': return '空空如也 >_<';
			case 'favorite.title': return '追番';
			case 'favorite.empty': return '啊咧（⊙.⊙） 没有追番的说';
			case 'calendar.title': return '时间表';
			case 'calendar.empty': return '数据还没有更新 (´;ω;`)';
			case 'my.private': return '隐身模式';
			case 'my.privateSubtitle': return '不保留观看记录';
			case 'my.history.title': return '历史记录';
			case 'my.history.empty': return '啊咧（⊙.⊙） 没有观看记录的说';
			case 'my.playerSettings.title': return '播放设置';
			case 'my.playerSettings.hardwareAcceleration': return '硬件解码';
			case 'my.playerSettings.autoPlay': return '自动播放';
			case 'my.playerSettings.autoJump': return '自动跳转';
			case 'my.playerSettings.autoJumpSubtitle': return '跳转到上次播放位置';
			case 'my.danmakuSettings.title': return '弹幕设置';
			case 'my.danmakuSettings.defaultEnable': return '默认开启';
			case 'my.danmakuSettings.defaultEnableSubtitle': return '默认是否随视频播放弹幕';
			case 'my.danmakuSettings.enhance': return '精准匹配';
			case 'my.danmakuSettings.stroke': return '弹幕描边';
			case 'my.danmakuSettings.fontSize': return '字体大小';
			case 'my.danmakuSettings.transparency': return '弹幕不透明度';
			case 'my.danmakuSettings.duration': return '弹幕时长';
			case 'my.danmakuSettings.area': return '弹幕区域';
			case 'my.danmakuSettings.areaSubtitleOccupy': return ({required Object value}) => '占据 ${value} 屏幕';
			case 'my.themeSettings.title': return '外观设置';
			case 'my.themeSettings.colorPalette': return '配色方案';
			case 'my.themeSettings.refreshRate': return '屏幕帧率';
			case 'my.themeSettings.refreshRateWarning': return '没有生效？重启应用试试';
			case 'my.themeSettings.refreshRateAuto': return '自动';
			case 'my.themeSettings.themeMode': return '主题模式';
			case 'my.themeSettings.useSystemFont': return '使用系统字体';
			case 'my.themeSettings.themeModeSystem': return '跟随系统';
			case 'my.themeSettings.themeModeLight': return '浅色';
			case 'my.themeSettings.themeModeDark': return '深色';
			case 'my.themeSettings.OLEDEnhance': return 'OLED优化';
			case 'my.themeSettings.OLEDEnhanceSubtitle': return '深色模式下使用纯黑背景';
			case 'my.themeSettings.alwaysOntop': return '窗口置顶';
			case 'my.themeSettings.alwaysOntopSubtitle': return '播放时始终保持在其他窗口上方';
			case 'my.otherSettings.title': return '其他设置';
			case 'my.otherSettings.searchEnhace': return '搜索优化';
			case 'my.otherSettings.searchEnhaceSubtitle': return '自动翻译关键词';
			case 'my.otherSettings.proxySettings': return '配置代理';
			case 'my.otherSettings.proxyHost': return '代理主机';
			case 'my.otherSettings.proxyPort': return '代理端口';
			case 'my.otherSettings.proxyEnable': return '启用代理';
			case 'my.otherSettings.autoUpdate': return '自动更新';
			case 'my.about.title': return '关于';
			case 'my.about.openSourceLicense': return '开源许可证';
			case 'my.about.openSourceLicenseSubtitle': return '查看所有开源许可证';
			case 'my.about.GithubRepo': return '项目主页';
			case 'my.about.danmakuSource': return '弹幕来源';
			case 'my.about.checkUpdate': return '检查更新';
			case 'my.about.currentVersion': return '当前版本';
			default: return null;
		}
	}
}

extension on _StringsZhHk {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'toast.loading': return '加載中';
			case 'toast.historyToast': return ({required Object episode}) => '上次觀看到第 ${episode} 集';
			case 'toast.favoriteToast': return '自己追的番要好好看完哦';
			case 'toast.dismissFavorite': return '取消追番成功';
			case 'toast.needReboot': return '重啟生效';
			case 'toast.checkUpdateWithNoUpdate': return '當前已經是最新版本！';
			case 'toast.exitApp': return '再按一次退出應用';
			case 'toast.refreshAnimeListWithSuccess': return '列表更新完成';
			case 'toast.animeNotExist': return '動畫還沒有更新第一集 >_<';
			case 'toast.currentEpisode': return ({required Object episode}) => '第 ${episode} 話';
			case 'toast.currentEpisodeIsLast': return '已經是最新一集';
			case 'toast.danmakuEmpty': return '當前劇集沒有找到彈幕的說';
			case 'toast.danmakuCannotEmpty': return '彈幕內容不能為空';
			case 'toast.danmakuTooLong': return '彈幕內容不能超過100個字符';
			case 'toast.danmakuSendSuccess': return '發送成功';
			case 'dialog.confirm': return '確認';
			case 'dialog.dismiss': return '取消';
			case 'dialog.setDefault': return '預設設定';
			case 'dialog.danmakuSending': return '發送中...';
			case 'dialog.danmakuSend': return '發送';
			case 'dialog.checkUpdateWithUpdate': return ({required Object value}) => '發現新版本 ${value}';
			case 'dialog.timeMachine': return '時間機器';
			case 'menu.home': return '推薦';
			case 'menu.calendar': return '時間表';
			case 'menu.favorite': return '追番';
			case 'menu.my': return '我的';
			case 'video.playSpeed': return '播放速度';
			case 'video.collection': return '合集 ';
			case 'video.playingCollection': return ({required Object title}) => '正在播放 ${title}';
			case 'video.changeEpisode': return '切換選集';
			case 'video.episodeTotal': return ({required Object total}) => '全 ${total} 話';
			case 'anime.anime': return '新番';
			case 'anime.serializing': return '連載中';
			case 'anime.OVA': return 'OVA';
			case 'anime.OAD': return 'OAD';
			case 'anime.movie': return '劇場版';
			case 'anime.year': return '年';
			case 'anime.seaons.spring': return '春';
			case 'anime.seaons.summer': return '夏';
			case 'anime.seaons.autumn': return '秋';
			case 'anime.seaons.winter': return '冬';
			case 'anime.singleSeason': return '季';
			case 'popular.searchBar': return '快速搜尋';
			case 'popular.empty': return '空空如也 >_<';
			case 'favorite.title': return '追番';
			case 'favorite.empty': return '啊咧（⊙.⊙） 沒有追番的說';
			case 'calendar.title': return '時間表';
			case 'calendar.empty': return '數據還沒有更新 (´;ω;)';
			case 'my.private': return '隱身模式';
			case 'my.privateSubtitle': return '不保留觀看記錄';
			case 'my.history.title': return '歷史記錄';
			case 'my.history.empty': return '啊咧（⊙.⊙） 沒有觀看記錄的說';
			case 'my.playerSettings.title': return '播放設置';
			case 'my.playerSettings.hardwareAcceleration': return '硬件解碼';
			case 'my.playerSettings.autoPlay': return '自動播放';
			case 'my.playerSettings.autoJump': return '自動跳轉';
			case 'my.playerSettings.autoJumpSubtitle': return '跳轉到上次播放位置';
			case 'my.danmakuSettings.title': return '彈幕設置';
			case 'my.danmakuSettings.defaultEnable': return '默認開啟';
			case 'my.danmakuSettings.defaultEnableSubtitle': return '默認是否隨視頻播放彈幕';
			case 'my.danmakuSettings.enhance': return '精準匹配';
			case 'my.danmakuSettings.stroke': return '彈幕描邊';
			case 'my.danmakuSettings.fontSize': return '字體大小';
			case 'my.danmakuSettings.transparency': return '彈幕不透明度';
			case 'my.danmakuSettings.duration': return '彈幕時長';
			case 'my.danmakuSettings.area': return '彈幕區域';
			case 'my.danmakuSettings.areaSubtitleOccupy': return ({required Object value}) => '佔據 ${value} 屏幕';
			case 'my.themeSettings.title': return '外觀設置';
			case 'my.themeSettings.colorPalette': return '配色方案';
			case 'my.themeSettings.refreshRate': return '屏幕幀率';
			case 'my.themeSettings.refreshRateWarning': return '沒有生效？重啟應用試試';
			case 'my.themeSettings.refreshRateAuto': return '自動';
			case 'my.themeSettings.themeMode': return '主題模式';
			case 'my.themeSettings.useSystemFont': return '使用系統字體';
			case 'my.themeSettings.themeModeSystem': return '跟隨系統';
			case 'my.themeSettings.themeModeLight': return '淺色';
			case 'my.themeSettings.themeModeDark': return '深色';
			case 'my.themeSettings.OLEDEnhance': return 'OLED優化';
			case 'my.themeSettings.OLEDEnhanceSubtitle': return '深色模式下使用純黑背景';
			case 'my.themeSettings.alwaysOntop': return '視窗置頂';
			case 'my.themeSettings.alwaysOntopSubtitle': return '播放時始終保持在其他視窗上方';
			case 'my.otherSettings.title': return '其他設置';
			case 'my.otherSettings.searchEnhace': return '搜索優化';
			case 'my.otherSettings.searchEnhaceSubtitle': return '自動翻譯關鍵詞';
			case 'my.otherSettings.proxySettings': return '配置代理';
			case 'my.otherSettings.proxyHost': return '代理主機';
			case 'my.otherSettings.proxyPort': return '代理端口';
			case 'my.otherSettings.proxyEnable': return '啟用代理';
			case 'my.otherSettings.autoUpdate': return '自動更新';
			case 'my.about.title': return '關於';
			case 'my.about.openSourceLicense': return '開源許可證';
			case 'my.about.openSourceLicenseSubtitle': return '查看所有開源許可證';
			case 'my.about.GithubRepo': return '專案首頁';
			case 'my.about.danmakuSource': return '彈幕來源';
			case 'my.about.checkUpdate': return '檢查更新';
			case 'my.about.currentVersion': return '當前版本';
			default: return null;
		}
	}
}

extension on _StringsZhTw {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'toast.loading': return '加載中';
			case 'toast.historyToast': return ({required Object episode}) => '上次觀看到第 ${episode} 集';
			case 'toast.favoriteToast': return '自己追的番要好好看完哦';
			case 'toast.dismissFavorite': return '取消追番成功';
			case 'toast.needReboot': return '重啟生效';
			case 'toast.checkUpdateWithNoUpdate': return '當前已經是最新版本！';
			case 'toast.exitApp': return '再按一次退出應用';
			case 'toast.refreshAnimeListWithSuccess': return '列表更新完成';
			case 'toast.animeNotExist': return '動畫還沒有更新第一集 >_<';
			case 'toast.currentEpisode': return ({required Object episode}) => '第 ${episode} 話';
			case 'toast.currentEpisodeIsLast': return '已經是最新一集';
			case 'toast.danmakuEmpty': return '當前劇集沒有找到彈幕的說';
			case 'toast.danmakuCannotEmpty': return '彈幕內容不能為空';
			case 'toast.danmakuTooLong': return '彈幕內容不能超過100個字符';
			case 'toast.danmakuSendSuccess': return '發送成功';
			case 'dialog.confirm': return '確認';
			case 'dialog.dismiss': return '取消';
			case 'dialog.setDefault': return '預設設定';
			case 'dialog.danmakuSending': return '發送中...';
			case 'dialog.danmakuSend': return '發送';
			case 'dialog.checkUpdateWithUpdate': return ({required Object value}) => '發現新版本 ${value}';
			case 'dialog.timeMachine': return '時間機器';
			case 'menu.home': return '推薦';
			case 'menu.calendar': return '時間表';
			case 'menu.favorite': return '追番';
			case 'menu.my': return '我的';
			case 'video.playSpeed': return '播放速度';
			case 'video.collection': return '合集 ';
			case 'video.playingCollection': return ({required Object title}) => '正在播放 ${title}';
			case 'video.changeEpisode': return '切換選集';
			case 'video.episodeTotal': return ({required Object total}) => '全 ${total} 話';
			case 'anime.anime': return '新番';
			case 'anime.serializing': return '連載中';
			case 'anime.OVA': return 'OVA';
			case 'anime.OAD': return 'OAD';
			case 'anime.movie': return '劇場版';
			case 'anime.year': return '年';
			case 'anime.seaons.spring': return '春';
			case 'anime.seaons.summer': return '夏';
			case 'anime.seaons.autumn': return '秋';
			case 'anime.seaons.winter': return '冬';
			case 'anime.singleSeason': return '季';
			case 'popular.searchBar': return '快速搜尋';
			case 'popular.empty': return '空空如也 >_<';
			case 'favorite.title': return '追番';
			case 'favorite.empty': return '啊咧（⊙.⊙） 沒有追番的說';
			case 'calendar.title': return '時間表';
			case 'calendar.empty': return '數據還沒有更新 (´;ω;)';
			case 'my.private': return '隱身模式';
			case 'my.privateSubtitle': return '不保留觀看記錄';
			case 'my.history.title': return '歷史記錄';
			case 'my.history.empty': return '啊咧（⊙.⊙） 沒有觀看記錄的說';
			case 'my.playerSettings.title': return '播放設置';
			case 'my.playerSettings.hardwareAcceleration': return '硬件解碼';
			case 'my.playerSettings.autoPlay': return '自動播放';
			case 'my.playerSettings.autoJump': return '自動跳轉';
			case 'my.playerSettings.autoJumpSubtitle': return '跳轉到上次播放位置';
			case 'my.danmakuSettings.title': return '彈幕設置';
			case 'my.danmakuSettings.defaultEnable': return '默認開啟';
			case 'my.danmakuSettings.defaultEnableSubtitle': return '默認是否隨視頻播放彈幕';
			case 'my.danmakuSettings.enhance': return '精準匹配';
			case 'my.danmakuSettings.stroke': return '彈幕描邊';
			case 'my.danmakuSettings.fontSize': return '字體大小';
			case 'my.danmakuSettings.transparency': return '彈幕不透明度';
			case 'my.danmakuSettings.duration': return '彈幕時長';
			case 'my.danmakuSettings.area': return '彈幕區域';
			case 'my.danmakuSettings.areaSubtitleOccupy': return ({required Object value}) => '佔據 ${value} 屏幕';
			case 'my.themeSettings.title': return '外觀設置';
			case 'my.themeSettings.colorPalette': return '配色方案';
			case 'my.themeSettings.refreshRate': return '屏幕幀率';
			case 'my.themeSettings.refreshRateWarning': return '沒有生效？重啟應用試試';
			case 'my.themeSettings.refreshRateAuto': return '自動';
			case 'my.themeSettings.themeMode': return '主題模式';
			case 'my.themeSettings.useSystemFont': return '使用系統字體';
			case 'my.themeSettings.themeModeSystem': return '跟隨系統';
			case 'my.themeSettings.themeModeLight': return '淺色';
			case 'my.themeSettings.themeModeDark': return '深色';
			case 'my.themeSettings.OLEDEnhance': return 'OLED優化';
			case 'my.themeSettings.OLEDEnhanceSubtitle': return '深色模式下使用純黑背景';
			case 'my.themeSettings.alwaysOntop': return '視窗置頂';
			case 'my.themeSettings.alwaysOntopSubtitle': return '播放時始終保持在其他視窗上方';
			case 'my.otherSettings.title': return '其他設置';
			case 'my.otherSettings.searchEnhace': return '搜索優化';
			case 'my.otherSettings.searchEnhaceSubtitle': return '自動翻譯關鍵詞';
			case 'my.otherSettings.proxySettings': return '配置代理';
			case 'my.otherSettings.proxyHost': return '代理主機';
			case 'my.otherSettings.proxyPort': return '代理端口';
			case 'my.otherSettings.proxyEnable': return '啟用代理';
			case 'my.otherSettings.autoUpdate': return '自動更新';
			case 'my.about.title': return '關於';
			case 'my.about.openSourceLicense': return '開源許可證';
			case 'my.about.openSourceLicenseSubtitle': return '查看所有開源許可證';
			case 'my.about.GithubRepo': return '專案首頁';
			case 'my.about.danmakuSource': return '彈幕來源';
			case 'my.about.checkUpdate': return '檢查更新';
			case 'my.about.currentVersion': return '當前版本';
			default: return null;
		}
	}
}
