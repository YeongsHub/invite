import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invite/core/di/providers.dart';
import 'package:invite/features/editor/models/canvas_element.dart';
import 'package:invite/features/editor/providers/editor_provider.dart';
import 'package:invite/features/templates/data/template_data.dart';
import 'package:invite/features/templates/models/template_model.dart';

class EditorPage extends ConsumerStatefulWidget {
  const EditorPage({super.key, this.templateId});

  final String? templateId;

  @override
  ConsumerState<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage> {
  bool _templateLoaded = false;
  final GlobalKey _canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadTemplate();
  }

  void _loadTemplate() {
    if (_templateLoaded || widget.templateId == null) return;
    _templateLoaded = true;
    final template =
        defaultTemplates.where((t) => t.id == widget.templateId).firstOrNull;
    if (template != null) {
      Future.microtask(() {
        final notifier = ref.read(editorProvider.notifier);
        notifier.setTemplate(template);

        final base = DateTime.now().millisecondsSinceEpoch;
        final canvasElements = <CanvasElement>[];
        for (var i = 0; i < template.elements.length; i++) {
          final el = template.elements[i];
          final id = '${base}_$i';
          switch (el.type) {
            case TemplateElementType.text:
              canvasElements.add(TextElement(
                id: id,
                x: el.x,
                y: el.y,
                width: el.width,
                height: el.height,
                text: el.content,
                fontSize: el.fontSize,
                color: template.colorPalette.text,
              ));
            case TemplateElementType.image:
              canvasElements.add(ImageElement(
                id: id,
                x: el.x,
                y: el.y,
                width: el.width,
                height: el.height,
                imagePath: el.content,
              ));
            case TemplateElementType.sticker:
              canvasElements.add(StickerElement(
                id: id,
                x: el.x,
                y: el.y,
                width: el.width,
                height: el.height,
                stickerAsset: el.content,
              ));
          }
        }
        notifier.loadElements(canvasElements);
      });
    }
  }

  Future<void> _exportCanvas() async {
    // Task 4: use exportServiceProvider instead of instantiating directly.
    final path = await ref
        .read(exportServiceProvider)
        .exportToPng(_canvasKey, 'invite_export');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(path != null ? 'Saved to $path' : 'Export failed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider);
    final bgColor =
        editorState.template?.colorPalette.background ?? Colors.white;
    final templateName = editorState.template?.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(templateName ?? 'Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export PNG',
            onPressed: _exportCanvas,
          ),
        ],
      ),
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
                  child: RepaintBoundary(
                    key: _canvasKey,
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
              ),
              _EditorToolbar(canvasSize: canvasSize),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Canvas element widget
// ---------------------------------------------------------------------------

class _CanvasElementWidget extends ConsumerStatefulWidget {
  const _CanvasElementWidget({
    required this.element,
    required this.isSelected,
  });

  final CanvasElement element;
  final bool isSelected;

  @override
  ConsumerState<_CanvasElementWidget> createState() =>
      _CanvasElementWidgetState();
}

class _CanvasElementWidgetState extends ConsumerState<_CanvasElementWidget> {
  double _x = 0;
  double _y = 0;
  double _w = 0;
  double _h = 0;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _x = widget.element.x;
    _y = widget.element.y;
    _w = widget.element.width;
    _h = widget.element.height;
  }

  @override
  void didUpdateWidget(_CanvasElementWidget old) {
    super.didUpdateWidget(old);
    // Sync from provider only when not dragging.
    if (!_dragging) {
      _x = widget.element.x;
      _y = widget.element.y;
      _w = widget.element.width;
      _h = widget.element.height;
    }
  }

  // Task 6: text editing bottom sheet.
  void _openTextEditSheet(BuildContext context) {
    final el = widget.element;
    if (el is! TextElement) return;

    final textController = TextEditingController(text: el.text);
    String text = el.text;
    double fontSize = el.fontSize;
    Color color = el.color;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Text'),
                onChanged: (v) => text = v,
              ),
              const SizedBox(height: 12),
              Text('Font size: ${fontSize.round()}'),
              Slider(
                value: fontSize,
                min: 8,
                max: 96,
                onChanged: (v) => setSheetState(() => fontSize = v),
              ),
              const SizedBox(height: 8),
              const Text('Color'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  Colors.black,
                  Colors.white,
                  Colors.red,
                  Colors.pink,
                  Colors.purple,
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.yellow,
                  Colors.brown,
                ]
                    .map(
                      (c) => GestureDetector(
                        onTap: () => setSheetState(() => color = c),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: color == c
                                ? Border.all(color: Colors.blue, width: 3)
                                : Border.all(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    ref.read(editorProvider.notifier).updateElement(
                          el.copyWith(
                            text: text,
                            fontSize: fontSize,
                            color: color,
                          ),
                        );
                    Navigator.pop(ctx);
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(textController.dispose);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _x,
      top: _y,
      width: _w,
      height: _h,
      child: GestureDetector(
        onTap: () {
          // Task 6: tap selected TextElement to open edit sheet.
          if (widget.isSelected && widget.element is TextElement) {
            _openTextEditSheet(context);
          } else {
            ref.read(editorProvider.notifier).selectElement(widget.element.id);
          }
        },
        onPanStart: (_) {
          _dragging = true;
          ref.read(editorProvider.notifier).pushHistory();
        },
        onPanUpdate: (details) {
          setState(() {
            _x += details.delta.dx;
            _y += details.delta.dy;
          });
          ref.read(editorProvider.notifier).moveElement(
                widget.element.copyWith(x: _x, y: _y),
              );
        },
        onPanEnd: (_) => _dragging = false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: widget.isSelected
                  ? BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    )
                  : null,
              child: _buildElementContent(),
            ),
            // Task 9: corner resize handles when selected.
            if (widget.isSelected) ..._buildResizeHandles(),
          ],
        ),
      ),
    );
  }

  // Task 9: four corner resize handles.
  List<Widget> _buildResizeHandles() {
    void pushHistory() => ref.read(editorProvider.notifier).pushHistory();
    void sync() => ref.read(editorProvider.notifier).moveElement(
          widget.element.copyWith(x: _x, y: _y, width: _w, height: _h),
        );

    return [
      // Top-left
      Positioned(
        left: 0,
        top: 0,
        child: _ResizeHandle(
          onDragStart: pushHistory,
          onDrag: (dx, dy) {
            setState(() {
              _x += dx;
              _y += dy;
              _w = (_w - dx).clamp(40, double.infinity);
              _h = (_h - dy).clamp(20, double.infinity);
            });
            sync();
          },
        ),
      ),
      // Top-right
      Positioned(
        right: 0,
        top: 0,
        child: _ResizeHandle(
          onDragStart: pushHistory,
          onDrag: (dx, dy) {
            setState(() {
              _y += dy;
              _w = (_w + dx).clamp(40, double.infinity);
              _h = (_h - dy).clamp(20, double.infinity);
            });
            sync();
          },
        ),
      ),
      // Bottom-left
      Positioned(
        left: 0,
        bottom: 0,
        child: _ResizeHandle(
          onDragStart: pushHistory,
          onDrag: (dx, dy) {
            setState(() {
              _x += dx;
              _w = (_w - dx).clamp(40, double.infinity);
              _h = (_h + dy).clamp(20, double.infinity);
            });
            sync();
          },
        ),
      ),
      // Bottom-right
      Positioned(
        right: 0,
        bottom: 0,
        child: _ResizeHandle(
          onDragStart: pushHistory,
          onDrag: (dx, dy) {
            setState(() {
              _w = (_w + dx).clamp(40, double.infinity);
              _h = (_h + dy).clamp(20, double.infinity);
            });
            sync();
          },
        ),
      ),
    ];
  }

  Widget _buildElementContent() {
    return switch (widget.element) {
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
            style: TextStyle(fontSize: widget.element.height * 0.6),
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

// ---------------------------------------------------------------------------
// Resize handle widget (Task 9)
// ---------------------------------------------------------------------------

class _ResizeHandle extends StatefulWidget {
  const _ResizeHandle({required this.onDragStart, required this.onDrag});

  final VoidCallback onDragStart;
  final void Function(double dx, double dy) onDrag;

  @override
  State<_ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<_ResizeHandle> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (_) => _started = false,
      onPanUpdate: (details) {
        if (!_started) {
          _started = true;
          widget.onDragStart();
        }
        widget.onDrag(details.delta.dx, details.delta.dy);
      },
      onPanEnd: (_) => _started = false,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue, width: 1.5),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Editor toolbar
// ---------------------------------------------------------------------------

class _EditorToolbar extends ConsumerWidget {
  const _EditorToolbar({required this.canvasSize});

  final Size canvasSize;

  // Task 8: emoji sticker picker bottom sheet.
  void _showStickerPicker(BuildContext context, WidgetRef ref) {
    const stickers = [
      '🎉', '❤️', '🌸', '⭐', '🎊', '🌺', '🦋', '🎈', '💐', '🕊️',
      '🎂', '🎁', '🥳', '🌹', '💝', '✨', '🎀', '🌈', '🍾', '💫',
      '🎵', '🎶', '🌻', '🍀', '🦄', '🌙', '☀️', '🔥', '💎', '🏆',
    ];
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pick a sticker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stickers
                  .map(
                    (s) => GestureDetector(
                      onTap: () {
                        ref.read(editorProvider.notifier).addElement(
                              StickerElement(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                x: (canvasSize.width - 80) / 2,
                                y: (canvasSize.height - 80) / 2,
                                width: 80,
                                height: 80,
                                stickerAsset: s,
                              ),
                            );
                        Navigator.pop(ctx);
                      },
                      child: Text(s, style: const TextStyle(fontSize: 36)),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(editorProvider);

    return Container(
      height: 56,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo',
            onPressed: editorState.canUndo
                ? () => ref.read(editorProvider.notifier).undo()
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            tooltip: 'Redo',
            onPressed: editorState.canRedo
                ? () => ref.read(editorProvider.notifier).redo()
                : null,
          ),
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
          // Task 7: wire image_picker.
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: 'Add Image',
            onPressed: () async {
              final picked = await ImagePicker()
                  .pickImage(source: ImageSource.gallery);
              if (picked == null) return;
              ref.read(editorProvider.notifier).addElement(
                    ImageElement(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      x: (canvasSize.width - 200) / 2,
                      y: (canvasSize.height - 200) / 2,
                      width: 200,
                      height: 200,
                      imagePath: picked.path,
                    ),
                  );
            },
          ),
          // Task 8: sticker picker.
          IconButton(
            icon: const Icon(Icons.emoji_emotions),
            tooltip: 'Add Sticker',
            onPressed: () => _showStickerPicker(context, ref),
          ),
          // Task 5: delete selected element.
          if (editorState.selectedElement != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Delete',
              onPressed: () => ref
                  .read(editorProvider.notifier)
                  .removeElement(editorState.selectedElement!.id),
            ),
        ],
      ),
    );
  }
}
