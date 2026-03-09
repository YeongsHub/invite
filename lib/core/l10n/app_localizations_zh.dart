// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '邀请';

  @override
  String get templates => '模板';

  @override
  String get editor => '编辑器';

  @override
  String get addText => '添加文字';

  @override
  String get addImage => '添加图片';

  @override
  String get addSticker => '添加贴纸';

  @override
  String get undo => '撤销';

  @override
  String get redo => '重做';

  @override
  String get delete => '删除';

  @override
  String get exportPng => '导出PNG';

  @override
  String get backgroundColor => '背景颜色';

  @override
  String get apply => '应用';

  @override
  String get fontSize => '字体大小';

  @override
  String get color => '颜色';

  @override
  String get pickSticker => '选择贴纸';

  @override
  String exportSuccess(String path) {
    return '已保存到 $path';
  }

  @override
  String get exportFailed => '导出失败';

  @override
  String get wedding => '婚礼';

  @override
  String get funeral => '葬礼';

  @override
  String get birthday => '生日';

  @override
  String get canvas => '画布区域';

  @override
  String get savedTo => '保存到';
}
