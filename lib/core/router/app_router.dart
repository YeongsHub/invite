import 'package:go_router/go_router.dart';
import 'package:invite/features/templates/templates_page.dart';
import 'package:invite/features/editor/editor_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TemplatesPage(),
    ),
    GoRoute(
      path: '/editor',
      builder: (context, state) {
        final templateId = state.extra as String?;
        return EditorPage(templateId: templateId);
      },
    ),
  ],
);
