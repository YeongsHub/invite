import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invite/features/editor/models/canvas_element.dart';
import 'package:invite/features/templates/models/template_model.dart';

class EditorState {
  const EditorState({
    this.elements = const [],
    this.selectedElement,
    this.template,
  });

  final List<CanvasElement> elements;
  final CanvasElement? selectedElement;
  final InviteTemplate? template;

  EditorState copyWith({
    List<CanvasElement>? elements,
    CanvasElement? selectedElement,
    InviteTemplate? template,
    bool clearSelection = false,
  }) {
    return EditorState(
      elements: elements ?? this.elements,
      selectedElement:
          clearSelection ? null : selectedElement ?? this.selectedElement,
      template: template ?? this.template,
    );
  }
}

class EditorNotifier extends StateNotifier<EditorState> {
  EditorNotifier() : super(const EditorState());

  void addElement(CanvasElement element) {
    state = state.copyWith(elements: [...state.elements, element]);
  }

  void removeElement(String id) {
    state = state.copyWith(
      elements: state.elements.where((e) => e.id != id).toList(),
      clearSelection: state.selectedElement?.id == id,
    );
  }

  void selectElement(String? id) {
    if (id == null) {
      state = state.copyWith(clearSelection: true);
      return;
    }
    final element = state.elements.firstWhere((e) => e.id == id);
    state = state.copyWith(selectedElement: element);
  }

  void setTemplate(InviteTemplate template) {
    state = state.copyWith(template: template);
  }

  void updateElement(CanvasElement updated) {
    state = state.copyWith(
      elements: state.elements
          .map((e) => e.id == updated.id ? updated : e)
          .toList(),
    );
  }
}

final editorProvider =
    StateNotifierProvider<EditorNotifier, EditorState>((ref) {
  return EditorNotifier();
});
