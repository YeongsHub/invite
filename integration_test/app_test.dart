// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:invite/main.dart' as app;

/// Integration / e2e tests.
///
/// Run on a connected device or emulator with:
///   flutter test integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------------------
  // 1. App launches and shows the Templates screen
  // ---------------------------------------------------------------------------
  testWidgets('App launches and shows templates screen', (tester) async {
    app.main();
    // Allow time for MobileAds.initialize() and the first frame to settle.
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // The templates page AppBar title is the localised "templates" key.
    // We look for category section icons that are always present.
    expect(find.byIcon(Icons.diamond_outlined), findsOneWidget); // Wedding
    expect(find.byIcon(Icons.church), findsOneWidget); // Funeral
    expect(find.byIcon(Icons.cake), findsOneWidget); // Birthday
  });

  // ---------------------------------------------------------------------------
  // 2. The language-selector button is present on the Templates screen
  // ---------------------------------------------------------------------------
  testWidgets('Language selector button is visible on templates screen',
      (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final languageButton = find.byIcon(Icons.language);
    expect(languageButton, findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // 3. Tapping a free template (Rose Garden) opens the editor
  // ---------------------------------------------------------------------------
  testWidgets('Tapping free template opens editor', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // "Rose Garden" template card shows 'Your Names Here' as the title sample.
    // Tap the first occurrence.
    final templateTitle = find.text('Your Names Here').first;
    await tester.tap(templateTitle);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Editor page shows the toolbar download icon.
    expect(find.byIcon(Icons.download), findsOneWidget);
    // Editor toolbar text_fields button is present.
    expect(find.byIcon(Icons.text_fields), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // 4. Tapping a Pro template shows the locked snack bar (not the editor)
  // ---------------------------------------------------------------------------
  testWidgets('Tapping pro-locked template shows upgrade snackbar',
      (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 'Silver Serenity' is a Pro-only funeral template.
    // Its title sample card shows 'In Loving Memory'.
    // The lock icon overlay is our reliable target.
    final lockIcons = find.byIcon(Icons.lock);
    expect(lockIcons, findsWidgets);
    // Tap the first locked card's parent area (the lock badge is part of the
    // GestureDetector stack, so tapping anywhere on the card works).
    await tester.tap(lockIcons.first);
    await tester.pumpAndSettle();

    expect(
      find.text('Upgrade to Pro to use this template'),
      findsOneWidget,
    );
  });

  // ---------------------------------------------------------------------------
  // 5. Editor back-navigation returns to the Templates screen
  // ---------------------------------------------------------------------------
  testWidgets('Editor back button returns to templates screen', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Tap the first free template card.
    final freeTemplateTitle = find.text('Your Names Here').first;
    await tester.tap(freeTemplateTitle);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Confirm editor opened.
    expect(find.byIcon(Icons.download), findsOneWidget);

    // Tap the back arrow.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Templates screen category icons should be visible again.
    expect(find.byIcon(Icons.diamond_outlined), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // 6. Editor: tapping 'Add Text' button adds a text element to the canvas
  // ---------------------------------------------------------------------------
  testWidgets('Add text button adds Hello text element to canvas',
      (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Open a free template.
    await tester.tap(find.text('Your Names Here').first);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Tap the text_fields toolbar button.
    await tester.tap(find.byIcon(Icons.text_fields));
    await tester.pumpAndSettle();

    // A 'Hello' TextElement should now appear on the canvas.
    expect(find.text('Hello'), findsOneWidget);
  });
}
