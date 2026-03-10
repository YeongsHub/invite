import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invite/features/templates/templates_page.dart';
import 'package:invite/features/editor/editor_page.dart';
import 'package:invite/features/rsvp/rsvp_response_page.dart';
import 'package:invite/features/rsvp/rsvp_list_page.dart';

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
          path: '/rsvp/:eventId',
          builder: (context, state) {
            final eventId = state.pathParameters['eventId']!;
            return RsvpResponsePage(eventId: eventId);
          },
        ),
        GoRoute(
          path: '/rsvp-list/:eventId',
          builder: (context, state) {
            final eventId = state.pathParameters['eventId']!;
            return RsvpListPage(eventId: eventId);
          },
        ),
      ],
    );
