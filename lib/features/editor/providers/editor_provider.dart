import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invite/features/editor/models/canvas_element.dart';
import 'package:invite/features/templates/models/template_model.dart';

class EditorState {
  const EditorState({
    this.elements = const [],
    this.selectedElement,
    this.template,
    this.history = const [],
    this.future = const [],
  });

  final List<CanvasElement> elements;
  final CanvasElement? selectedElement;
  final InviteTemplate? template;
  final List<List<CanvasElement>> history;
  final List<List<CanvasElement>> future;

  bool get canUndo => history.isNotEmpty;
  bool get canRedo => future.isNotEmpty;

  EditorState copyWith({
    List<CanvasElement>? elements,
    CanvasElement? selectedElement,
    InviteTemplate? template,
    bool clearSelection = false,
    List<List<CanvasElement>>? history,
    List<List<CanvasElement>>? future,
  }) {
    return EditorState(
      elements: elements ?? this.elements,
      selectedElement:
          clearSelection ? null : selectedElement ?? this.selectedElement,
      template: template ?? this.template,
      history: history ?? this.history,
      future: future ?? this.future,
    );
  }
}

class EditorNotifier extends StateNotifier<EditorState> {
  EditorNotifier() : super(const EditorState());

  void _pushHistory() {
    final newHistory = [...state.history, state.elements];
    state = state.copyWith(
      history: newHistory.length > 50
          ? newHistory.sublist(newHistory.length - 50)
          : newHistory,
      future: [],
    );
  }

  void addElement(CanvasElement element) {
    _pushHistory();
    state = state.copyWith(elements: [...state.elements, element]);
  }

  void removeElement(String id) {
    _pushHistory();
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
    final matches = state.elements.where((e) => e.id == id);
    if (matches.isEmpty) return;
    state = state.copyWith(selectedElement: matches.first);
  }

  void setTemplate(InviteTemplate template) {
    state = state.copyWith(template: template);
  }

  /// Replaces canvas elements without recording a history entry.
  /// Used for the initial template load.
  void loadElements(List<CanvasElement> elements) {
    state = state.copyWith(elements: elements);
  }

  void updateElement(CanvasElement updated) {
    _pushHistory();
    state = state.copyWith(
      elements: state.elements
          .map((e) => e.id == updated.id ? updated : e)
          .toList(),
    );
  }

  /// Move an element without recording a history entry.
  /// Call [pushHistory] before starting a drag, then use this during [onPanUpdate].
  void moveElement(CanvasElement updated) {
    state = state.copyWith(
      elements: state.elements
          .map((e) => e.id == updated.id ? updated : e)
          .toList(),
    );
  }

  void pushHistory() => _pushHistory();

  void undo() {
    if (!state.canUndo) return;
    final previousElements = state.history.last;
    final newHistory = state.history.sublist(0, state.history.length - 1);
    state = state.copyWith(
      elements: previousElements,
      history: newHistory,
      future: [state.elements, ...state.future],
      clearSelection: true,
    );
  }

  void redo() {
    if (!state.canRedo) return;
    final nextElements = state.future.first;
    final newFuture = state.future.sublist(1);
    state = state.copyWith(
      elements: nextElements,
      history: [...state.history, state.elements],
      future: newFuture,
      clearSelection: true,
    );
  }
}

final editorProvider =
    StateNotifierProvider<EditorNotifier, EditorState>((ref) {
  return EditorNotifier();
});
