import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite/features/editor/models/canvas_element.dart';
import 'package:invite/features/editor/providers/editor_provider.dart';

TextElement _makeTextElement({String id = 'el-1', String text = 'Hello'}) {
  return TextElement(
    id: id,
    x: 10,
    y: 20,
    width: 200,
    height: 50,
    text: text,
    fontSize: 16,
    color: Colors.black,
  );
}

void main() {
  group('EditorNotifier — initial state', () {
    test('elements list is empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(editorProvider).elements, isEmpty);
    });

    test('selectedElement is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(editorProvider).selectedElement, isNull);
    });

    test('canUndo is false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(editorProvider).canUndo, false);
    });

    test('canRedo is false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(editorProvider).canRedo, false);
    });
  });

  group('EditorNotifier — addElement', () {
    test('adds a TextElement to elements list', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final element = _makeTextElement();
      container.read(editorProvider.notifier).addElement(element);

      final state = container.read(editorProvider);
      expect(state.elements.length, 1);
      expect(state.elements.first.id, 'el-1');
    });

    test('canUndo becomes true after addElement', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(editorProvider.notifier).addElement(_makeTextElement());

      expect(container.read(editorProvider).canUndo, true);
    });

    test('adding multiple elements appends in order', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(editorProvider.notifier)
          .addElement(_makeTextElement(id: 'a', text: 'A'));
      container
          .read(editorProvider.notifier)
          .addElement(_makeTextElement(id: 'b', text: 'B'));

      final elements = container.read(editorProvider).elements;
      expect(elements.length, 2);
      expect(elements[0].id, 'a');
      expect(elements[1].id, 'b');
    });
  });

  group('EditorNotifier — removeElement', () {
    test('removes element by id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final element = _makeTextElement();
      container.read(editorProvider.notifier).addElement(element);
      container.read(editorProvider.notifier).removeElement('el-1');

      expect(container.read(editorProvider).elements, isEmpty);
    });

    test('removing non-existent id leaves elements unchanged', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(editorProvider.notifier).addElement(_makeTextElement());
      container
          .read(editorProvider.notifier)
          .removeElement('does-not-exist');

      expect(container.read(editorProvider).elements.length, 1);
    });

    test('clears selection when selected element is removed', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final element = _makeTextElement();
      container.read(editorProvider.notifier).addElement(element);
      container.read(editorProvider.notifier).selectElement('el-1');
      expect(
          container.read(editorProvider).selectedElement?.id, 'el-1');

      container.read(editorProvider.notifier).removeElement('el-1');
      expect(container.read(editorProvider).selectedElement, isNull);
    });
  });

  group('EditorNotifier — undo', () {
    test('undo restores elements to state before addElement', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(editorProvider.notifier)
          .addElement(_makeTextElement());
      expect(container.read(editorProvider).elements.length, 1);

      container.read(editorProvider.notifier).undo();
      expect(container.read(editorProvider).elements, isEmpty);
    });

    test('undo clears selection', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final element = _makeTextElement();
      container.read(editorProvider.notifier).addElement(element);
      container.read(editorProvider.notifier).selectElement('el-1');

      container.read(editorProvider.notifier).undo();
      expect(container.read(editorProvider).selectedElement, isNull);
    });

    test('undo does nothing when canUndo is false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(editorProvider.notifier).undo(); // no-op, no crash
      expect(container.read(editorProvider).elements, isEmpty);
    });

    test('canUndo is false again after undoing the only action', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(editorProvider.notifier)
          .addElement(_makeTextElement());
      container.read(editorProvider.notifier).undo();

      expect(container.read(editorProvider).canUndo, false);
    });
  });

  group('EditorNotifier — selectElement', () {
    test('selectElement sets selectedElement by id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final element = _makeTextElement();
      container.read(editorProvider.notifier).addElement(element);
      container.read(editorProvider.notifier).selectElement('el-1');

      expect(
          container.read(editorProvider).selectedElement?.id, 'el-1');
    });

    test('selectElement with null clears selection', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final element = _makeTextElement();
      container.read(editorProvider.notifier).addElement(element);
      container.read(editorProvider.notifier).selectElement('el-1');
      container.read(editorProvider.notifier).selectElement(null);

      expect(container.read(editorProvider).selectedElement, isNull);
    });

    test('selectElement with unknown id is a no-op', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final element = _makeTextElement();
      container.read(editorProvider.notifier).addElement(element);
      container.read(editorProvider.notifier).selectElement('el-1');
      container
          .read(editorProvider.notifier)
          .selectElement('unknown-id');

      // Previous selection should remain unchanged
      expect(
          container.read(editorProvider).selectedElement?.id, 'el-1');
    });
  });
}
