import 'dart:io';

/// Ad unit IDs for AdMob.
/// TODO: Replace all test IDs with real IDs from AdMob console before release.
class AdConfig {
  static String get bannerId => Platform.isIOS
      ? 'ca-app-pub-3940256099942544/2934735716' // TODO: real iOS banner ID
      : 'ca-app-pub-3940256099942544/6300978111'; // TODO: real Android banner ID

  static String get interstitialId => Platform.isIOS
      ? 'ca-app-pub-3940256099942544/4411468910' // TODO: real iOS interstitial ID
      : 'ca-app-pub-3940256099942544/1033173712'; // TODO: real Android interstitial ID
}
