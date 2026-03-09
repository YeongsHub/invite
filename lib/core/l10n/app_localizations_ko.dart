// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '인바이트';

  @override
  String get templates => '템플릿';

  @override
  String get editor => '편집기';

  @override
  String get addText => '텍스트 추가';

  @override
  String get addImage => '이미지 추가';

  @override
  String get addSticker => '스티커 추가';

  @override
  String get undo => '실행 취소';

  @override
  String get redo => '다시 실행';

  @override
  String get delete => '삭제';

  @override
  String get exportPng => 'PNG 내보내기';

  @override
  String get backgroundColor => '배경 색상';

  @override
  String get apply => '적용';

  @override
  String get fontSize => '글자 크기';

  @override
  String get color => '색상';

  @override
  String get pickSticker => '스티커 선택';

  @override
  String exportSuccess(String path) {
    return '$path에 저장됨';
  }

  @override
  String get exportFailed => '내보내기 실패';

  @override
  String get wedding => '결혼식';

  @override
  String get funeral => '장례식';

  @override
  String get birthday => '생일';

  @override
  String get canvas => '캔버스 영역';

  @override
  String get savedTo => '저장 위치';
}
