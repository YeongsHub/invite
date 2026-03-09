import 'package:flutter_test/flutter_test.dart';
import 'package:invite/features/templates/data/text_layout_presets.dart';

void main() {
  group('textLayoutPresets data integrity', () {
    test('textLayoutPresets has exactly 6 presets', () {
      expect(textLayoutPresets.length, equals(6));
    });

    test('first 3 presets are free (isPro == false)', () {
      for (int i = 0; i < 3; i++) {
        expect(
          textLayoutPresets[i].isPro,
          isFalse,
          reason:
              'Preset at index $i ("${textLayoutPresets[i].name}") should be free',
        );
      }
    });

    test('last 3 presets are pro (isPro == true)', () {
      for (int i = 3; i < 6; i++) {
        expect(
          textLayoutPresets[i].isPro,
          isTrue,
          reason:
              'Preset at index $i ("${textLayoutPresets[i].name}") should be pro',
        );
      }
    });

    test('all preset items have x >= 0', () {
      for (final preset in textLayoutPresets) {
        for (final item in preset.items) {
          expect(
            item.x,
            greaterThanOrEqualTo(0),
            reason:
                'Item "${item.label}" in preset "${preset.name}" has x=${item.x}',
          );
        }
      }
    });

    test('all preset items have y >= 0', () {
      for (final preset in textLayoutPresets) {
        for (final item in preset.items) {
          expect(
            item.y,
            greaterThanOrEqualTo(0),
            reason:
                'Item "${item.label}" in preset "${preset.name}" has y=${item.y}',
          );
        }
      }
    });

    test('all preset items have width <= 360', () {
      for (final preset in textLayoutPresets) {
        for (final item in preset.items) {
          expect(
            item.width,
            lessThanOrEqualTo(360),
            reason:
                'Item "${item.label}" in preset "${preset.name}" has width=${item.width}',
          );
        }
      }
    });

    test('all preset items have height <= 600', () {
      for (final preset in textLayoutPresets) {
        for (final item in preset.items) {
          expect(
            item.height,
            lessThanOrEqualTo(600),
            reason:
                'Item "${item.label}" in preset "${preset.name}" has height=${item.height}',
          );
        }
      }
    });

    test('all preset items have fontSize > 0', () {
      for (final preset in textLayoutPresets) {
        for (final item in preset.items) {
          expect(
            item.fontSize,
            greaterThan(0),
            reason:
                'Item "${item.label}" in preset "${preset.name}" has fontSize=${item.fontSize}',
          );
        }
      }
    });
  });
}
