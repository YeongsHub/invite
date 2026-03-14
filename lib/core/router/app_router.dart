import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invite/features/templates/templates_page.dart';
import 'package:invite/features/editor/editor_page.dart';
import 'package:invite/features/settings/settings_page.dart';
import 'package:invite/features/settings/faq_page.dart';
import 'package:invite/features/settings/privacy_policy_page.dart';
import 'package:invite/features/settings/terms_of_service_page.dart';

class EditorRouteExtra {
  const EditorRouteExtra({this.templateId});
  final String? templateId;
}

GoRouter buildAppRouter() => GoRouter(
      initialLocation: '/',
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text('Page not found: ${state.uri}')),
      ),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TemplatesPage(),
        ),
        GoRoute(
          path: '/editor',
          builder: (context, state) {
            final extra = state.extra as EditorRouteExtra?;
            return EditorPage(templateId: extra?.templateId);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/faq',
          builder: (context, state) => const FaqPage(),
        ),
        GoRoute(
          path: '/privacy-policy',
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
        GoRoute(
          path: '/terms-of-service',
          builder: (context, state) => const TermsOfServicePage(),
        ),
      ],
    );
