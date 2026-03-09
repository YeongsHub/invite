// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Invite';

  @override
  String get templates => 'Templates';

  @override
  String get editor => 'Editor';

  @override
  String get addText => 'Add Text';

  @override
  String get addImage => 'Add Image';

  @override
  String get addSticker => 'Add Sticker';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get delete => 'Delete';

  @override
  String get exportPng => 'Export PNG';

  @override
  String get backgroundColor => 'Background Color';

  @override
  String get apply => 'Apply';

  @override
  String get fontSize => 'Font Size';

  @override
  String get color => 'Color';

  @override
  String get pickSticker => 'Pick a sticker';

  @override
  String exportSuccess(String path) {
    return 'Saved to $path';
  }

  @override
  String get exportFailed => 'Export failed';

  @override
  String get wedding => 'Wedding';

  @override
  String get funeral => 'Funeral';

  @override
  String get birthday => 'Birthday';

  @override
  String get canvas => 'Canvas Area';

  @override
  String get savedTo => 'Saved to';
}
