import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invite/features/editor/models/canvas_element.dart';
import 'package:invite/features/editor/providers/editor_provider.dart';
import 'package:invite/features/templates/data/template_data.dart';

class EditorPage extends ConsumerStatefulWidget {
  const EditorPage({super.key, this.templateId});

  final String? templateId;

  @override
  ConsumerState<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage> {
  bool _templateLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTemplate();
  }

  void _loadTemplate() {
    if (_templateLoaded || widget.templateId == null) return;
    _templateLoaded = true;
    final template = defaultTemplates
        .where((t) => t.id == widget.templateId)
        .firstOrNull;
    if (template != null) {
      ref.read(editorProvider.notifier).setTemplate(template);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider);
    final bgColor =
        editorState.template?.colorPalette['background'] ?? Colors.white;
    final templateName = editorState.template?.name;

    return Scaffold(
      appBar: AppBar(title: Text(templateName ?? 'Editor')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final canvasHeight = constraints.maxHeight - 56;
          final canvasSize = Size(constraints.maxWidth, canvasHeight);
          return Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(editorProvider.notifier).selectElement(null);
                  },
                  child: Stack(
                    children: [
                      Container(
                        color: bgColor,
                        child: editorState.elements.isEmpty
                            ? const Center(
                                child: Text(
                                  'Canvas Area',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : const SizedBox.expand(),
                      ),
                      for (final element in editorState.elements)
                        _CanvasElementWidget(
                          element: element,
                          isSelected:
                              editorState.selectedElement?.id == element.id,
                        ),
                    ],
                  ),
                ),
              ),
              _EditorToolbar(canvasSize: canvasSize),
            ],
          );
        },
      ),
    );
  }
}

class _CanvasElementWidget extends ConsumerWidget {
  const _CanvasElementWidget({
    required this.element,
    required this.isSelected,
  });

  final CanvasElement element;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      left: element.x,
      top: element.y,
      width: element.width,
      height: element.height,
      child: GestureDetector(
        onTap: () {
          ref.read(editorProvider.notifier).selectElement(element.id);
        },
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: _buildElementContent(),
        ),
      ),
    );
  }

  Widget _buildElementContent() {
    return switch (element) {
      TextElement(:final text, :final fontSize, :final color) => Center(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: color),
            textAlign: TextAlign.center,
          ),
        ),
      ImageElement(:final imagePath) => Image.file(
          File(imagePath),
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Center(
            child: Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      StickerElement(:final stickerAsset) => Center(
          child: Text(
            stickerAsset,
            style: TextStyle(fontSize: element.height * 0.6),
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _EditorToolbar extends ConsumerWidget {
  const _EditorToolbar({required this.canvasSize});

  final Size canvasSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 56,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            tooltip: 'Add Text',
            onPressed: () {
              const elementWidth = 200.0;
              const elementHeight = 50.0;
              ref.read(editorProvider.notifier).addElement(
                    TextElement(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      x: (canvasSize.width - elementWidth) / 2,
                      y: (canvasSize.height - elementHeight) / 2,
                      width: elementWidth,
                      height: elementHeight,
                      text: 'Hello',
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  );
            },
          ),
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: 'Add Image',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Image - coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions),
            tooltip: 'Add Sticker',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Sticker - coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }
}
