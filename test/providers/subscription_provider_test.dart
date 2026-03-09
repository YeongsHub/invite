import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite/core/di/subscription_provider.dart';

void main() {
  group('SubscriptionNotifier', () {
    test('initial state is false (free)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(subscriptionProvider), false);
    });

    test('upgradeToPro() sets state to true', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(subscriptionProvider.notifier).upgradeToPro();

      expect(container.read(subscriptionProvider), true);
    });

    test('downgradeToFree() sets state back to false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(subscriptionProvider.notifier).upgradeToPro();
      expect(container.read(subscriptionProvider), true);

      container.read(subscriptionProvider.notifier).downgradeToFree();
      expect(container.read(subscriptionProvider), false);
    });
  });

  group('isProProvider', () {
    test('reflects subscriptionProvider state when free', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(isProProvider), false);
    });

    test('reflects subscriptionProvider state when pro', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(subscriptionProvider.notifier).upgradeToPro();

      expect(container.read(isProProvider), true);
    });

    test('updates when subscriptionProvider changes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(isProProvider), false);

      container.read(subscriptionProvider.notifier).upgradeToPro();
      expect(container.read(isProProvider), true);

      container.read(subscriptionProvider.notifier).downgradeToFree();
      expect(container.read(isProProvider), false);
    });
  });
}
