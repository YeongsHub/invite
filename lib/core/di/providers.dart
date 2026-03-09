import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invite/core/router/app_router.dart';
import 'package:invite/features/export/export_service.dart';

final appRouterProvider = Provider<GoRouter>((ref) => buildAppRouter());

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});
