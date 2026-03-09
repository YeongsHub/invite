// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Invite';

  @override
  String get templates => 'Modèles';

  @override
  String get editor => 'Éditeur';

  @override
  String get addText => 'Ajouter du texte';

  @override
  String get addImage => 'Ajouter une image';

  @override
  String get addSticker => 'Ajouter un sticker';

  @override
  String get undo => 'Annuler';

  @override
  String get redo => 'Rétablir';

  @override
  String get delete => 'Supprimer';

  @override
  String get exportPng => 'Exporter PNG';

  @override
  String get backgroundColor => 'Couleur de fond';

  @override
  String get apply => 'Appliquer';

  @override
  String get fontSize => 'Taille de police';

  @override
  String get color => 'Couleur';

  @override
  String get pickSticker => 'Choisir un sticker';

  @override
  String exportSuccess(String path) {
    return 'Enregistré dans $path';
  }

  @override
  String get exportFailed => 'Échec de l\'exportation';

  @override
  String get wedding => 'Mariage';

  @override
  String get funeral => 'Funérailles';

  @override
  String get birthday => 'Anniversaire';

  @override
  String get canvas => 'Zone de dessin';

  @override
  String get savedTo => 'Enregistré dans';
}
