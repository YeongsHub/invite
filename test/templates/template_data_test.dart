import 'package:flutter_test/flutter_test.dart';
import 'package:invite/features/templates/data/template_data.dart';
import 'package:invite/features/templates/models/template_model.dart';

void main() {
  group('defaultTemplates data integrity', () {
    test('defaultTemplates is not empty', () {
      expect(defaultTemplates, isNotEmpty);
    });

    test('there are at least 4 free templates (isPro == false)', () {
      final freeTemplates =
          defaultTemplates.where((t) => t.isPro == false).toList();
      expect(freeTemplates.length, greaterThanOrEqualTo(4));
    });

    test('there is at least 1 pro template (isPro == true)', () {
      final proTemplates =
          defaultTemplates.where((t) => t.isPro == true).toList();
      expect(proTemplates.length, greaterThanOrEqualTo(1));
    });

    test('every template has non-empty id', () {
      for (final template in defaultTemplates) {
        expect(
          template.id,
          isNotEmpty,
          reason: 'Template with name "${template.name}" has an empty id',
        );
      }
    });

    test('every template has non-empty name', () {
      for (final template in defaultTemplates) {
        expect(
          template.name,
          isNotEmpty,
          reason: 'Template with id "${template.id}" has an empty name',
        );
      }
    });

    test('every template has non-empty elements list', () {
      for (final template in defaultTemplates) {
        expect(
          template.elements,
          isNotEmpty,
          reason:
              'Template "${template.id}" has no elements',
        );
      }
    });

    test('every template has at least 1 text element', () {
      for (final template in defaultTemplates) {
        final textElements = template.elements
            .where((e) => e.type == TemplateElementType.text)
            .toList();
        expect(
          textElements.length,
          greaterThanOrEqualTo(1),
          reason: 'Template "${template.id}" has no text elements',
        );
      }
    });

    test('wedding category has at least 2 templates', () {
      final weddingTemplates = defaultTemplates
          .where((t) => t.category == TemplateCategory.wedding)
          .toList();
      expect(weddingTemplates.length, greaterThanOrEqualTo(2));
    });

    test('funeral category has at least 1 template', () {
      final funeralTemplates = defaultTemplates
          .where((t) => t.category == TemplateCategory.funeral)
          .toList();
      expect(funeralTemplates.length, greaterThanOrEqualTo(1));
    });

    test('birthday category has at least 1 template', () {
      final birthdayTemplates = defaultTemplates
          .where((t) => t.category == TemplateCategory.birthday)
          .toList();
      expect(birthdayTemplates.length, greaterThanOrEqualTo(1));
    });
  });
}
