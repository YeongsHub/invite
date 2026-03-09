import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // Test ad unit IDs
  static const String _interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712'; // Android test interstitial
  static const String _bannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111'; // Android test banner

  InterstitialAd? _interstitialAd;
  bool _isInterstitialReady = false;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
        },
        onAdFailedToLoad: (error) {
          _isInterstitialReady = false;
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (_isInterstitialReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isInterstitialReady = false;
          _loadInterstitialAd(); // preload next
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isInterstitialReady = false;
          _loadInterstitialAd();
        },
      );
      await _interstitialAd!.show();
    }
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }
}
