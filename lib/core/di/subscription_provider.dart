import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionNotifier extends Notifier<bool> {
  @override
  bool build() => false; // false = free, true = pro

  void upgradeToPro() => state = true;
  void downgradeToFree() => state = false;
}

final subscriptionProvider = NotifierProvider<SubscriptionNotifier, bool>(
  SubscriptionNotifier.new,
);

// Convenience provider
final isProProvider = Provider<bool>((ref) => ref.watch(subscriptionProvider));
