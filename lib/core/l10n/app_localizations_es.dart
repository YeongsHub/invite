// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Invite';

  @override
  String get templates => 'Plantillas';

  @override
  String get editor => 'Editor';

  @override
  String get addText => 'Agregar texto';

  @override
  String get addImage => 'Agregar imagen';

  @override
  String get addSticker => 'Agregar sticker';

  @override
  String get undo => 'Deshacer';

  @override
  String get redo => 'Rehacer';

  @override
  String get delete => 'Eliminar';

  @override
  String get exportPng => 'Exportar PNG';

  @override
  String get backgroundColor => 'Color de fondo';

  @override
  String get apply => 'Aplicar';

  @override
  String get fontSize => 'Tamaño de fuente';

  @override
  String get color => 'Color';

  @override
  String get pickSticker => 'Selecciona un sticker';

  @override
  String exportSuccess(String path) {
    return 'Guardado en $path';
  }

  @override
  String get exportFailed => 'Error al exportar';

  @override
  String get wedding => 'Boda';

  @override
  String get funeral => 'Funeral';

  @override
  String get birthday => 'Cumpleaños';

  @override
  String get canvas => 'Área del lienzo';

  @override
  String get savedTo => 'Guardado en';
}
