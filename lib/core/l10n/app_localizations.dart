import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get appTitle;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @editor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get editor;

  /// No description provided for @addText.
  ///
  /// In en, this message translates to:
  /// **'Add Text'**
  String get addText;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @addSticker.
  ///
  /// In en, this message translates to:
  /// **'Add Sticker'**
  String get addSticker;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @exportPng.
  ///
  /// In en, this message translates to:
  /// **'Export PNG'**
  String get exportPng;

  /// No description provided for @backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get backgroundColor;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @pickSticker.
  ///
  /// In en, this message translates to:
  /// **'Pick a sticker'**
  String get pickSticker;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved to {path}'**
  String exportSuccess(String path);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @wedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get wedding;

  /// No description provided for @funeral.
  ///
  /// In en, this message translates to:
  /// **'Funeral'**
  String get funeral;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @canvas.
  ///
  /// In en, this message translates to:
  /// **'Canvas Area'**
  String get canvas;

  /// No description provided for @savedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to'**
  String get savedTo;

  /// No description provided for @tmpl_wedding_rose_0.
  ///
  /// In en, this message translates to:
  /// **'Together We Celebrate'**
  String get tmpl_wedding_rose_0;

  /// No description provided for @tmpl_wedding_rose_1.
  ///
  /// In en, this message translates to:
  /// **'Emma & James'**
  String get tmpl_wedding_rose_1;

  /// No description provided for @tmpl_wedding_rose_2.
  ///
  /// In en, this message translates to:
  /// **'Saturday, June 14 · 4:00 PM'**
  String get tmpl_wedding_rose_2;

  /// No description provided for @tmpl_wedding_rose_3.
  ///
  /// In en, this message translates to:
  /// **'The Grand Pavilion, Lake View'**
  String get tmpl_wedding_rose_3;

  /// No description provided for @tmpl_wedding_gold_0.
  ///
  /// In en, this message translates to:
  /// **'You Are Invited'**
  String get tmpl_wedding_gold_0;

  /// No description provided for @tmpl_wedding_gold_1.
  ///
  /// In en, this message translates to:
  /// **'Sophia & William'**
  String get tmpl_wedding_gold_1;

  /// No description provided for @tmpl_wedding_gold_2.
  ///
  /// In en, this message translates to:
  /// **'Friday, August 22 · 5:30 PM'**
  String get tmpl_wedding_gold_2;

  /// No description provided for @tmpl_wedding_gold_3.
  ///
  /// In en, this message translates to:
  /// **'Rose Hall Estate, Hillside'**
  String get tmpl_wedding_gold_3;

  /// No description provided for @tmpl_funeral_navy_0.
  ///
  /// In en, this message translates to:
  /// **'In Loving Memory'**
  String get tmpl_funeral_navy_0;

  /// No description provided for @tmpl_funeral_navy_1.
  ///
  /// In en, this message translates to:
  /// **'Robert James Henderson'**
  String get tmpl_funeral_navy_1;

  /// No description provided for @tmpl_funeral_navy_2.
  ///
  /// In en, this message translates to:
  /// **'1942 – 2024'**
  String get tmpl_funeral_navy_2;

  /// No description provided for @tmpl_funeral_navy_3.
  ///
  /// In en, this message translates to:
  /// **'Memorial Service · Thursday, March 14'**
  String get tmpl_funeral_navy_3;

  /// No description provided for @tmpl_funeral_navy_4.
  ///
  /// In en, this message translates to:
  /// **'St. Michael\'s Chapel, 2:00 PM'**
  String get tmpl_funeral_navy_4;

  /// No description provided for @tmpl_funeral_silver_0.
  ///
  /// In en, this message translates to:
  /// **'A Life Well Lived'**
  String get tmpl_funeral_silver_0;

  /// No description provided for @tmpl_funeral_silver_1.
  ///
  /// In en, this message translates to:
  /// **'Margaret Anne Collins'**
  String get tmpl_funeral_silver_1;

  /// No description provided for @tmpl_funeral_silver_2.
  ///
  /// In en, this message translates to:
  /// **'1950 – 2024'**
  String get tmpl_funeral_silver_2;

  /// No description provided for @tmpl_funeral_silver_3.
  ///
  /// In en, this message translates to:
  /// **'Celebration of Life · Saturday, April 5'**
  String get tmpl_funeral_silver_3;

  /// No description provided for @tmpl_birthday_confetti_0.
  ///
  /// In en, this message translates to:
  /// **'Party Time!'**
  String get tmpl_birthday_confetti_0;

  /// No description provided for @tmpl_birthday_confetti_1.
  ///
  /// In en, this message translates to:
  /// **'You\'re Invited to Alex\'s'**
  String get tmpl_birthday_confetti_1;

  /// No description provided for @tmpl_birthday_confetti_2.
  ///
  /// In en, this message translates to:
  /// **'7th Birthday Bash!'**
  String get tmpl_birthday_confetti_2;

  /// No description provided for @tmpl_birthday_confetti_3.
  ///
  /// In en, this message translates to:
  /// **'Saturday, July 12 · 3:00 PM'**
  String get tmpl_birthday_confetti_3;

  /// No description provided for @tmpl_birthday_confetti_4.
  ///
  /// In en, this message translates to:
  /// **'42 Maple Street, Sunnyside'**
  String get tmpl_birthday_confetti_4;

  /// No description provided for @tmpl_wedding_minimal_0.
  ///
  /// In en, this message translates to:
  /// **'You Are Cordially Invited'**
  String get tmpl_wedding_minimal_0;

  /// No description provided for @tmpl_wedding_minimal_1.
  ///
  /// In en, this message translates to:
  /// **'Olivia & Ethan'**
  String get tmpl_wedding_minimal_1;

  /// No description provided for @tmpl_wedding_minimal_2.
  ///
  /// In en, this message translates to:
  /// **'Saturday, September 20 · 3:00 PM'**
  String get tmpl_wedding_minimal_2;

  /// No description provided for @tmpl_wedding_minimal_3.
  ///
  /// In en, this message translates to:
  /// **'The White Orchid Ballroom, Maplewood'**
  String get tmpl_wedding_minimal_3;

  /// No description provided for @tmpl_birthday_coral_0.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Celebrate!'**
  String get tmpl_birthday_coral_0;

  /// No description provided for @tmpl_birthday_coral_1.
  ///
  /// In en, this message translates to:
  /// **'Jordan turns 30!'**
  String get tmpl_birthday_coral_1;

  /// No description provided for @tmpl_birthday_coral_2.
  ///
  /// In en, this message translates to:
  /// **'Friday, October 3 · 7:00 PM'**
  String get tmpl_birthday_coral_2;

  /// No description provided for @tmpl_birthday_coral_3.
  ///
  /// In en, this message translates to:
  /// **'Rooftop Lounge, Downtown'**
  String get tmpl_birthday_coral_3;

  /// No description provided for @tmpl_birthday_neon_0.
  ///
  /// In en, this message translates to:
  /// **'It\'s Going Down!'**
  String get tmpl_birthday_neon_0;

  /// No description provided for @tmpl_birthday_neon_1.
  ///
  /// In en, this message translates to:
  /// **'Happy Birthday, Sam!'**
  String get tmpl_birthday_neon_1;

  /// No description provided for @tmpl_birthday_neon_2.
  ///
  /// In en, this message translates to:
  /// **'Friday, Nov 7 · 8 PM · Club Neon, Downtown'**
  String get tmpl_birthday_neon_2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
