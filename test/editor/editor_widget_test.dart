import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:invite/core/di/providers.dart';
import 'package:invite/core/di/subscription_provider.dart';
import 'package:invite/features/editor/editor_page.dart';
import 'package:invite/features/export/export_service.dart';
import 'package:invite/core/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Minimal fake implementations so we never hit platform channels in tests.
// ---------------------------------------------------------------------------

class _FakeExportService extends ExportService {
  @override
  Future<String?> exportToPng(GlobalKey key, String name) async => null;

  @override
  Future<void> shareImage(String path) async {}
}

/// Builds a testable [EditorPage] widget, wrapped with all required ancestors.
Widget _buildTestEditor({String? templateId}) {
  // A minimal GoRouter that only knows about '/editor' so pop() works.
  final router = GoRouter(
    initialLocation: '/editor',
    routes: [
      GoRoute(
        path: '/editor',
        builder: (_, __) => EditorPage(templateId: templateId),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      // Swap the real export service (uses screenshot plugin) for a no-op.
      exportServiceProvider.overrideWithValue(_FakeExportService()),
      // Keep the user on the free tier (isProProvider reads subscriptionProvider).
      subscriptionProvider.overrideWith(SubscriptionNotifier.new),
      // Provide a real router override so context.pop() doesn't throw.
      appRouterProvider.overrideWithValue(router),
    ],
    child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  // -------------------------------------------------------------------------
  // Test 1 — EditorPage renders without crashing inside a ProviderScope
  // -------------------------------------------------------------------------
  testWidgets('EditorPage renders with ProviderScope', (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    // Let microtasks (template loading via Future.microtask) complete.
    await tester.pumpAndSettle();

    // The Scaffold / AppBar must be present.
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  // -------------------------------------------------------------------------
  // Test 2 — AppBar title shows 'Editor' when no templateId is provided
  // -------------------------------------------------------------------------
  testWidgets('EditorPage shows "Editor" title when no template is given',
      (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    await tester.pumpAndSettle();

    expect(find.text('Editor'), findsOneWidget);
  });

  // -------------------------------------------------------------------------
  // Test 3 — Toolbar has the text_fields icon (Add Text)
  // -------------------------------------------------------------------------
  testWidgets('Toolbar has text_fields icon', (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.text_fields), findsOneWidget);
  });

  // -------------------------------------------------------------------------
  // Test 4 — Toolbar has the export / download icon
  // -------------------------------------------------------------------------
  testWidgets('Toolbar has export (download) icon', (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    await tester.pumpAndSettle();

    // Export button lives in the AppBar actions.
    expect(find.byIcon(Icons.download), findsOneWidget);
  });

  // -------------------------------------------------------------------------
  // Test 5 — Toolbar has undo, redo, and background-colour icons
  // -------------------------------------------------------------------------
  testWidgets('Toolbar contains undo, redo and background-colour icons',
      (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.undo), findsOneWidget);
    expect(find.byIcon(Icons.redo), findsOneWidget);
    expect(find.byIcon(Icons.format_color_fill), findsOneWidget);
  });

  // -------------------------------------------------------------------------
  // Test 6 — Toolbar has image and sticker icons
  // -------------------------------------------------------------------------
  testWidgets('Toolbar contains image, sticker, and layout icons',
      (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.image), findsOneWidget);
    expect(find.byIcon(Icons.emoji_emotions), findsOneWidget);
  });

  // -------------------------------------------------------------------------
  // Test 7 — Empty canvas shows placeholder text 'Canvas Area'
  // -------------------------------------------------------------------------
  testWidgets('Empty canvas shows "Canvas Area" placeholder', (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    await tester.pumpAndSettle();

    expect(find.text('Canvas Area'), findsOneWidget);
  });

  // -------------------------------------------------------------------------
  // Test 8 — Tapping 'Add Text' adds a 'Hello' element to the canvas
  // -------------------------------------------------------------------------
  testWidgets('Tapping Add Text button adds Hello element to canvas',
      (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    await tester.pumpAndSettle();

    // No text element yet.
    expect(find.text('Hello'), findsNothing);

    await tester.tap(find.byIcon(Icons.text_fields));
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
  });

  // -------------------------------------------------------------------------
  // Test 9 — Undo is disabled initially (button icon is greyed / disabled)
  // -------------------------------------------------------------------------
  testWidgets('Undo button is disabled when no history exists', (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    await tester.pumpAndSettle();

    // IconButton is disabled when onPressed is null.
    final undoButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.undo),
    );
    expect(undoButton.onPressed, isNull);
  });

  // -------------------------------------------------------------------------
  // Test 10 — Undo becomes enabled after adding a text element
  // -------------------------------------------------------------------------
  testWidgets('Undo button becomes active after adding text element',
      (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.text_fields));
    await tester.pumpAndSettle();

    final undoButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.undo),
    );
    expect(undoButton.onPressed, isNotNull);
  });

  // -------------------------------------------------------------------------
  // Test 11 — Back button (arrow_back) is present in the AppBar
  // -------------------------------------------------------------------------
  testWidgets('AppBar has back (arrow_back) button', (tester) async {
    await tester.pumpWidget(_buildTestEditor());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
