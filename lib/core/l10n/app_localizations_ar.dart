// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'دعوة';

  @override
  String get templates => 'القوالب';

  @override
  String get editor => 'المحرر';

  @override
  String get addText => 'إضافة نص';

  @override
  String get addImage => 'إضافة صورة';

  @override
  String get addSticker => 'إضافة ملصق';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get delete => 'حذف';

  @override
  String get exportPng => 'تصدير PNG';

  @override
  String get backgroundColor => 'لون الخلفية';

  @override
  String get apply => 'تطبيق';

  @override
  String get fontSize => 'حجم الخط';

  @override
  String get color => 'اللون';

  @override
  String get pickSticker => 'اختر ملصقًا';

  @override
  String exportSuccess(String path) {
    return 'تم الحفظ في $path';
  }

  @override
  String get exportFailed => 'فشل التصدير';

  @override
  String get wedding => 'زفاف';

  @override
  String get funeral => 'جنازة';

  @override
  String get birthday => 'عيد ميلاد';

  @override
  String get canvas => 'منطقة اللوحة';

  @override
  String get savedTo => 'حفظ في';
}
