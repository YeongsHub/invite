// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'インバイト';

  @override
  String get templates => 'テンプレート';

  @override
  String get editor => 'エディター';

  @override
  String get addText => 'テキストを追加';

  @override
  String get addImage => '画像を追加';

  @override
  String get addSticker => 'スタッカーを追加';

  @override
  String get undo => '元に戻す';

  @override
  String get redo => 'やり直す';

  @override
  String get delete => '削除';

  @override
  String get exportPng => 'PNGとして書き出す';

  @override
  String get backgroundColor => '背景色';

  @override
  String get apply => '適用';

  @override
  String get fontSize => 'フォントサイズ';

  @override
  String get color => '色';

  @override
  String get pickSticker => 'スタッカーを選択';

  @override
  String exportSuccess(String path) {
    return '$pathに保存しました';
  }

  @override
  String get exportFailed => '書き出しに失敗しました';

  @override
  String get wedding => 'ウェディング';

  @override
  String get funeral => '葬儀';

  @override
  String get birthday => '誕生日';

  @override
  String get canvas => 'キャンバスエリア';

  @override
  String get savedTo => '保存先';
}
