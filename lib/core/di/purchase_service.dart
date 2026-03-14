import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'subscription_provider.dart';

const String kProMonthlyId = 'invite_pro_monthly';
const String kProYearlyId = 'invite_pro_yearly';
const Set<String> _kProductIds = {kProMonthlyId, kProYearlyId};

class PurchaseService {
  PurchaseService(this._ref) {
    _init();
  }

  final Ref _ref;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _available = false;

  List<ProductDetails> get products => _products;
  bool get isAvailable => _available;

  Future<void> _init() async {
    _available = await InAppPurchase.instance.isAvailable();
    if (!_available) return;

    // Listen to purchase updates
    _subscription = InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (_) {},
    );

    // Load products
    final response = await InAppPurchase.instance.queryProductDetails(_kProductIds);
    _products = response.productDetails;
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (_kProductIds.contains(purchase.productID)) {
          _ref.read(subscriptionProvider.notifier).upgradeToPro();
        }
        if (purchase.pendingCompletePurchase) {
          InAppPurchase.instance.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        if (purchase.pendingCompletePurchase) {
          InAppPurchase.instance.completePurchase(purchase);
        }
      }
    }
  }

  Future<bool> buyMonthly() => _buy(kProMonthlyId);
  Future<bool> buyYearly() => _buy(kProYearlyId);

  Future<bool> _buy(String productId) async {
    final product = _products.where((p) => p.id == productId).firstOrNull;
    if (!_available || product == null) {
      // Fallback: store unavailable or product not loaded — upgrade directly.
      _ref.read(subscriptionProvider.notifier).upgradeToPro();
      return true;
    }
    final param = PurchaseParam(productDetails: product);
    return InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    if (!_available) return;
    await InAppPurchase.instance.restorePurchases();
  }

  void dispose() {
    _subscription?.cancel();
  }
}
