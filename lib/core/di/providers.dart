import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invite/core/router/app_router.dart';
import 'package:invite/features/export/export_service.dart';
import 'ad_service.dart';
import 'purchase_service.dart';

export 'subscription_provider.dart';
export 'rsvp_provider.dart';
export 'host_settings_provider.dart';
export 'purchase_service.dart' show kProMonthlyId, kProYearlyId;

final appRouterProvider = Provider<GoRouter>((ref) => buildAppRouter());

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});

final adServiceProvider = Provider<AdService>((ref) => AdService());

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final service = PurchaseService(ref);
  ref.onDispose(service.dispose);
  return service;
});
