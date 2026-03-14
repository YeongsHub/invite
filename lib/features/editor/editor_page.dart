import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invite/core/di/providers.dart';
import 'package:invite/core/theme/app_colors.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:invite/features/editor/models/canvas_element.dart';
import 'package:invite/features/editor/providers/editor_provider.dart';
import 'package:invite/features/templates/data/template_data.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:invite/features/templates/models/template_model.dart';
import 'package:invite/core/di/locale_provider.dart';
import 'package:invite/core/l10n/template_content_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invite/features/editor/models/canvas_pattern.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reference canvas dimensions used by all presets and templates.
const double _kRefWidth = 360.0;
const double _kRefHeight = 600.0;

class EditorPage extends ConsumerStatefulWidget {
  const EditorPage({super.key, this.templateId});

  final String? templateId;

  @override
  ConsumerState<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage> {
  bool _templateLoaded = false;
  final GlobalKey _canvasKey = GlobalKey();

  /// Actual canvas size, captured once the LayoutBuilder has measured it.
  Size? _canvasSize;

  @override
  void initState() {
    super.initState();
    // Template loading is deferred to the first build where canvasSize is known.
  }

  /// Applies responsive scaling from the 360×600 reference space to [canvasSize].
  void _loadTemplate(Size canvasSize) {
    if (_templateLoaded || widget.templateId == null) return;
    _templateLoaded = true;

    final template =
        defaultTemplates.where((t) => t.id == widget.templateId).firstOrNull;
    if (template == null) return;

    final scaleX = canvasSize.width / _kRefWidth;
    final scaleY = canvasSize.height / _kRefHeight;
    final scaleFont = min(scaleX, scaleY);

    final locale = ref.read(localeProvider);

    Future.microtask(() {
      final notifier = ref.read(editorProvider.notifier);
      notifier.setTemplate(template);

      final base = DateTime.now().millisecondsSinceEpoch;
      final canvasElements = <CanvasElement>[];
      for (var i = 0; i < template.elements.length; i++) {
        final el = template.elements[i];
        final id = '${base}_$i';

        final scaledX = (el.x * scaleX).clamp(0.0, canvasSize.width);
        final scaledY = (el.y * scaleY).clamp(0.0, canvasSize.height);
        final scaledW = (el.width * scaleX).clamp(0.0, canvasSize.width);
        final scaledH = (el.height * scaleY).clamp(0.0, canvasSize.height);

        switch (el.type) {
          case TemplateElementType.text:
            final localized =
                TemplateContentLocalizations.get(template.id, i, locale);
            canvasElements.add(TextElement(
              id: id,
              x: scaledX,
              y: scaledY,
              width: scaledW,
              height: scaledH,
              text: localized.isNotEmpty ? localized : el.content,
              fontSize: el.fontSize * scaleFont,
              color: template.colorPalette.text,
            ));
          case TemplateElementType.image:
            canvasElements.add(ImageElement(
              id: id,
              x: scaledX,
              y: scaledY,
              width: scaledW,
              height: scaledH,
              imagePath: el.content,
            ));
          case TemplateElementType.sticker:
            canvasElements.add(StickerElement(
              id: id,
              x: scaledX,
              y: scaledY,
              width: scaledW,
              height: scaledH,
              stickerAsset: el.content,
            ));
        }
      }
      notifier.loadElements(canvasElements);
    });
  }

  Future<void> _exportCanvas() async {
    final isPro = ref.read(isProProvider);
    if (!isPro) {
      await ref.read(adServiceProvider).showInterstitialAd();
    }
    final exportService = ref.read(exportServiceProvider);
    final path = await exportService.exportToPng(_canvasKey, 'invite_export');
    if (!mounted) return;
    if (path != null) {
      await exportService.shareImage(path);
      await _maybeRequestReview();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export failed')),
      );
    }
  }

  Future<void> _maybeRequestReview() async {
    const exportCountKey = 'export_count';
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(exportCountKey) ?? 0) + 1;
    await prefs.setInt(exportCountKey, count);
    // 3번째 export마다 리뷰 요청 (3, 6, 9, ...)
    if (count % 3 == 0) {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    }
  }

  void _showUpgradeSheet(BuildContext context) {
    final purchaseService = ref.read(purchaseServiceProvider);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) {
          return StatefulBuilder(
            builder: (ctx, setSheetState) {
              bool isLoading = false;

              // Resolve live product prices when available, fall back to
              // hard-coded display prices.
              final products = purchaseService.products;
              ProductDetails? monthly;
              ProductDetails? yearly;
              for (final p in products) {
                if (p.id == kProMonthlyId) monthly = p;
                if (p.id == kProYearlyId) yearly = p;
              }
              final monthlyPrice = monthly?.price ?? r'$4.99';
              final yearlyPrice = yearly?.price ?? r'$19.99';

              Future<void> handlePurchase(
                  Future<bool> Function() buyFn) async {
                setSheetState(() => isLoading = true);
                try {
                  final success = await buyFn();
                  if (success && ctx.mounted) {
                    Navigator.pop(ctx);
                  }
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text('Purchase failed: $e')),
                    );
                  }
                } finally {
                  if (ctx.mounted) {
                    setSheetState(() => isLoading = false);
                  }
                }
              }

              Future<void> handleRestore() async {
                setSheetState(() => isLoading = true);
                try {
                  await purchaseService.restorePurchases();
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('Purchases restored')),
                    );
                  }
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text('Restore failed: $e')),
                    );
                  }
                } finally {
                  if (ctx.mounted) {
                    setSheetState(() => isLoading = false);
                  }
                }
              }

              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.fromLTRB(
                        24,
                        0,
                        24,
                        MediaQuery.of(ctx).viewInsets.bottom + 24,
                      ),
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            margin:
                                const EdgeInsets.only(top: 12, bottom: 20),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Header — gradient star icon + bold title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary
                                ],
                              ).createShader(bounds),
                              child: const Icon(
                                Icons.auto_awesome,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Upgrade to Pro',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Feature list with green circle-check icons
                        ...[
                          'All templates',
                          'All text layouts',
                          'Photo & camera',
                          'Full color palette',
                          'No ads',
                          'High-res export',
                        ].map(
                          (feature) => Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F5E9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Color(0xFF2E7D32),
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  feature,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Product cards row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Monthly card — grey border
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      'Monthly',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      monthlyPrice,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.onSurface,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Text(
                                      '/month',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () => handlePurchase(
                                              purchaseService.buyMonthly),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        side: const BorderSide(
                                            color: AppColors.primary),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Buy',
                                        style: TextStyle(
                                            color: AppColors.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Yearly card — primary border, tinted background
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  color: const Color(0xFFF3F0FF),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Label + SAVE badge
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Yearly',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2E7D32),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Text(
                                            'SAVE 49%',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      yearlyPrice,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Text(
                                      '/year',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.primary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    FilledButton(
                                      onPressed: isLoading
                                          ? null
                                          : () => handlePurchase(
                                              purchaseService.buyYearly),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('Buy'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Restore Purchases
                        Center(
                          child: TextButton(
                            onPressed:
                                isLoading ? null : handleRestore,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade600,
                            ),
                            child: const Text(
                              'Restore Purchases',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),

                        // Maybe Later
                        Center(
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.pop(ctx),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade400,
                            ),
                            child: const Text(
                              'Maybe Later',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Full-sheet loading overlay
                  if (isLoading)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider);
    final bgColor = editorState.canvasColor;
    final bgPattern = editorState.canvasPattern;
    final templateName = editorState.template?.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(templateName ?? 'Editor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export PNG',
            onPressed: _exportCanvas,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final canvasHeight = constraints.maxHeight - 56;
          final canvasSize = Size(constraints.maxWidth, canvasHeight);

          // Trigger template loading once the real canvas size is known.
          if (_canvasSize == null) {
            _canvasSize = canvasSize;
            // Schedule after this build frame to avoid calling setState
            // or provider writes during build.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadTemplate(canvasSize);
            });
          }

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
                        // Background: pattern or solid color
                        if (bgPattern != null)
                          CustomPaint(
                            painter: getPatternPainter(bgPattern),
                            child: SizedBox.expand(
                              child: editorState.elements.isEmpty
                                  ? const Center(
                                      child: Text('Canvas Area',
                                          style: TextStyle(color: Colors.grey)))
                                  : null,
                            ),
                          )
                        else
                          Container(
                            color: bgColor,
                            child: editorState.elements.isEmpty
                                ? const Center(
                                    child: Text('Canvas Area',
                                        style: TextStyle(color: Colors.grey)),
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
              _EditorToolbar(
                canvasSize: canvasSize,
                onShowUpgradeSheet: () => _showUpgradeSheet(context),
              ),
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
  double _rotation = 0;
  bool _dragging = false;

  // Used to find the element's center in global coordinates for rotation.
  final _elementKey = GlobalKey();
  Offset? _rotateStartVec;
  double _rotationAtStart = 0;

  @override
  void initState() {
    super.initState();
    _x = widget.element.x;
    _y = widget.element.y;
    _w = widget.element.width;
    _h = widget.element.height;
    _rotation = widget.element.rotation;
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
      _rotation = widget.element.rotation;
    }
  }

  // Free fonts available to all users.
  static const List<(String label, String? family)> _freeFonts = [
    ('Default', null),
    ('Serif', 'Playfair Display'),
    ('Mono', 'Roboto Mono'),
  ];

  // Premium fonts (Pro only).
  static const List<(String label, String? family)> _proFonts = [
    ('Dancing Script', 'Dancing Script'),
    ('Pacifico', 'Pacifico'),
    ('Lobster', 'Lobster'),
    ('Montserrat', 'Montserrat'),
    ('Oswald', 'Oswald'),
    ('Great Vibes', 'Great Vibes'),
    ('Raleway', 'Raleway'),
    ('Lato', 'Lato'),
  ];

  static const List<Color> _freeColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
  ];

  // Task 6: text editing bottom sheet.
  void _openTextEditSheet(BuildContext context) {
    final el = widget.element;
    if (el is! TextElement) return;
    final isPro = ref.read(isProProvider);

    final textController = TextEditingController(text: el.text);
    String text = el.text;
    double fontSize = el.fontSize;
    Color color = el.color;
    String? fontFamily = el.fontFamily;

    final allFonts = isPro ? [..._freeFonts, ..._proFonts] : _freeFonts;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => SingleChildScrollView(
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

              // ── Font picker ──────────────────────────────────────
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Font', style: TextStyle(fontWeight: FontWeight.w600)),
                  if (!isPro) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Pro unlocks 8 more',
                          style: TextStyle(fontSize: 10, color: Colors.orange)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: allFonts.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final (label, family) = allFonts[i];
                    final isSelected = fontFamily == family;
                    TextStyle chipStyle = TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : Colors.black87,
                    );
                    if (family != null) {
                      try {
                        chipStyle = GoogleFonts.getFont(family, textStyle: chipStyle);
                      } catch (_) {}
                    }
                    return GestureDetector(
                      onTap: () => setSheetState(() => fontFamily = family),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(ctx).colorScheme.primary : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Theme.of(ctx).colorScheme.primary : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(label, style: chipStyle),
                      ),
                    );
                  },
                ),
              ),

              // ── Color picker ─────────────────────────────────────
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
                  if (!isPro) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Pro: custom color',
                          style: TextStyle(fontSize: 10, color: Colors.orange)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._freeColors.map(
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
                  ),
                  // Pro: custom color picker button
                  if (isPro)
                    GestureDetector(
                      onTap: () async {
                        Color picked = color;
                        await showDialog<void>(
                          context: ctx,
                          builder: (dlgCtx) => AlertDialog(
                            title: const Text('Pick a color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: picked,
                                onColorChanged: (c) => picked = c,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dlgCtx),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(dlgCtx),
                                child: const Text('Select'),
                              ),
                            ],
                          ),
                        );
                        setSheetState(() => color = picked);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const SweepGradient(colors: [
                            Colors.red, Colors.orange, Colors.yellow,
                            Colors.green, Colors.blue, Colors.purple, Colors.red,
                          ]),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                ],
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
                            fontFamily: fontFamily,
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

  void _syncElement() {
    ref.read(editorProvider.notifier).moveElement(
          widget.element.copyWith(
            x: _x,
            y: _y,
            width: _w,
            height: _h,
            rotation: _rotation,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    // Extra space above the element to fit the rotation handle touch target.
    // 56px keeps the 48px touch target fully within hit-testable bounds.
    const double rotateHandleHeight = 56.0;
    const double touchTargetSize = 48.0;
    final double extraTop = widget.isSelected ? rotateHandleHeight : 0.0;

    return Positioned(
      left: _x,
      top: _y - extraTop,
      width: _w,
      height: _h + extraTop,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Rotation handle – 48×48 touch target so it's reachable on real devices.
          if (widget.isSelected)
            Positioned(
              top: rotateHandleHeight - touchTargetSize, // = 8, within bounds
              left: _w / 2 - touchTargetSize / 2,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (details) {
                  ref.read(editorProvider.notifier).pushHistory();
                  _rotationAtStart = _rotation;
                  final box = _elementKey.currentContext?.findRenderObject() as RenderBox?;
                  if (box == null) return;
                  final center = box.localToGlobal(Offset(_w / 2, _h / 2));
                  _rotateStartVec = details.globalPosition - center;
                },
                onPanUpdate: (details) {
                  final box = _elementKey.currentContext?.findRenderObject() as RenderBox?;
                  if (box == null || _rotateStartVec == null) return;
                  final center = box.localToGlobal(Offset(_w / 2, _h / 2));
                  final currentVec = details.globalPosition - center;
                  final startAngle = atan2(_rotateStartVec!.dy, _rotateStartVec!.dx);
                  final currentAngle = atan2(currentVec.dy, currentVec.dx);
                  setState(() {
                    _rotation = _rotationAtStart + (currentAngle - startAngle);
                  });
                  _syncElement();
                },
                onPanEnd: (_) => _rotateStartVec = null,
                child: SizedBox(
                  width: touchTargetSize,
                  height: touchTargetSize,
                  child: Center(
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.rotate_right, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ),
            ),
          // Element content, offset down by extraTop so it stays at (_x, _y).
          Positioned(
            top: extraTop,
            left: 0,
            width: _w,
            height: _h,
            child: Transform.rotate(
              angle: _rotation,
              child: GestureDetector(
                key: _elementKey,
                onTap: () {
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
                  _syncElement();
                },
                onPanEnd: (_) => _dragging = false,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: widget.isSelected
                          ? BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(4),
                            )
                          : null,
                      child: _buildElementContent(),
                    ),
                    if (widget.isSelected) ..._buildResizeHandles(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Task 9: four corner resize handles.
  List<Widget> _buildResizeHandles() {
    void pushHistory() => ref.read(editorProvider.notifier).pushHistory();

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
            _syncElement();
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
            _syncElement();
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
            _syncElement();
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
            _syncElement();
          },
        ),
      ),
    ];
  }

  TextStyle _buildTextStyle({
    required double fontSize,
    required Color color,
    String? fontFamily,
  }) {
    final base = TextStyle(fontSize: fontSize, color: color);
    if (fontFamily == null) return base;
    try {
      return GoogleFonts.getFont(fontFamily, textStyle: base);
    } catch (_) {
      return base;
    }
  }

  Widget _buildElementContent() {
    return switch (widget.element) {
      TextElement(:final text, :final fontSize, :final color, :final fontFamily) => Center(
          child: Text(
            text,
            style: _buildTextStyle(fontSize: fontSize, color: color, fontFamily: fontFamily),
            textAlign: TextAlign.center,
          ),
        ),
      ImageElement(:final imagePath, :final isPolaroid) when isPolaroid => PolaroidFrame(
          imagePath: imagePath,
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
      QrElement(:final data) => QrImageView(
          data: data,
          version: QrVersions.auto,
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
  const _EditorToolbar({
    required this.canvasSize,
    required this.onShowUpgradeSheet,
  });

  final Size canvasSize;
  final VoidCallback onShowUpgradeSheet;

  // Free tier: first 8 basic colors only.
  static const List<Color> _freeColors = [
    Colors.white,
    Color(0xFFF5F5F5),
    Color(0xFFFFFDE7),
    Color(0xFFFCE4EC),
    Color(0xFFE8F5E9),
    Color(0xFFE3F2FD),
    Color(0xFFEDE7F6),
    Color(0xFFFFF9C4),
  ];

  // Pro palette — organized by section.
  static const Map<String, List<Color>> _proSections = {
    'Neutrals': [
      Colors.white,
      Color(0xFFF5F5F5),
      Color(0xFFE0E0E0),
      Color(0xFF9E9E9E),
      Color(0xFF616161),
      Color(0xFF424242),
      Color(0xFF212121),
      Colors.black,
    ],
    'Pastels': [
      Color(0xFFF8BBD0), // baby pink
      Color(0xFFE1BEE7), // lavender
      Color(0xFFC8E6C9), // mint
      Color(0xFFB3E5FC), // sky blue
      Color(0xFFFFCCBC), // peach
      Color(0xFFFFF9C4), // lemon
      Color(0xFFD1C4E9), // lilac
      Color(0xFFC5E1A5), // sage
      Color(0xFFF48FB1), // blush
      Color(0xFFB3D4F5), // powder blue
    ],
    'Vivid': [
      Color(0xFFE91E63), // rose
      Color(0xFFFF5722), // coral
      Color(0xFFFFC107), // gold
      Color(0xFF4CAF50), // emerald
      Color(0xFF3F51B5), // royal blue
      Color(0xFF9C27B0), // purple
      Color(0xFF009688), // teal
      Color(0xFFFF9800), // orange
      Color(0xFFB71C1C), // crimson
      Color(0xFF0D47A1), // navy
    ],
    'Dark / Rich': [
      Color(0xFF4A0E2A), // deep burgundy
      Color(0xFF1B5E20), // forest green
      Color(0xFF0D1B4B), // midnight blue
      Color(0xFF311B92), // deep purple
      Color(0xFF3E2723), // chocolate
      Color(0xFF004D40), // dark teal
      Color(0xFF880E4F), // dark rose
      Color(0xFF37474F), // slate
    ],
  };

  void _showBgColorPicker(BuildContext context, WidgetRef ref) {
    final isPro = ref.read(isProProvider);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final current = ref.read(editorProvider).canvasColor;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            Color selected = current;

            Widget colorSwatch(Color c, {bool locked = false}) {
              final isSelected = selected == c;
              return GestureDetector(
                onTap: locked
                    ? () {
                        Navigator.pop(ctx);
                        onShowUpgradeSheet();
                      }
                    : () {
                        ref
                            .read(editorProvider.notifier)
                            .updateCanvasColor(c);
                        Navigator.pop(ctx);
                      },
                child: Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: Colors.blue, width: 3)
                            : Border.all(
                                color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    if (locked)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.lock,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }

            if (!isPro) {
              // Free layout: first 8 colors + locked remaining colors.
              const allFreeColors = [
                Colors.white,
                Color(0xFFF5F5F5),
                Color(0xFFFFFDE7),
                Color(0xFFFCE4EC),
                Color(0xFFE8F5E9),
                Color(0xFFE3F2FD),
                Color(0xFFEDE7F6),
                Color(0xFFFFF9C4),
                // Locked previews
                Color(0xFFFFE0B2),
                Color(0xFFE0F7FA),
                Color(0xFFF3E5F5),
                Color(0xFFE8EAF6),
                Color(0xFFEF9A9A),
                Color(0xFF90CAF9),
                Color(0xFFA5D6A7),
                Color(0xFF1A237E),
              ];

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Canvas background',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: allFreeColors.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final c = entry.value;
                        return colorSwatch(c, locked: idx >= _freeColors.length);
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Upgrade to Pro for full palette',
                            style: TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            onShowUpgradeSheet();
                          },
                          child: const Text('Upgrade'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            // Pro layout: patterns + color sections + custom color button.
            final sections = _proSections.entries.toList();
            final currentPattern = ref.read(editorProvider).canvasPattern;
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.75,
              minChildSize: 0.4,
              maxChildSize: 0.92,
              builder: (ctx2, scrollController) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: ListView(
                  controller: scrollController,
                  children: [
                    const Text(
                      'Canvas background',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    // ── Patterns section ──────────────────────────────────
                    const Text(
                      'Patterns',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: proPatterns.map((p) {
                        final isSelected = currentPattern == p.id;
                        return GestureDetector(
                          onTap: () {
                            ref.read(editorProvider.notifier).updateCanvasPattern(p.id);
                            Navigator.pop(ctx);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: isSelected
                                      ? Border.all(color: Colors.blue, width: 3)
                                      : Border.all(color: Colors.grey.shade300),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: CustomPaint(
                                  painter: getPatternPainter(p.id),
                                  child: const SizedBox.expand(),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 58,
                                child: Text(
                                  p.label,
                                  style: const TextStyle(fontSize: 9),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    // ── Solid colors ──────────────────────────────────────
                    ...sections.map((section) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.key,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: section.value.map((c) => colorSwatch(c)).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                    const Divider(),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.color_lens_outlined),
                      label: const Text('Custom Color'),
                      onPressed: () async {
                        Color pickerColor = selected;
                        final confirmed = await showDialog<bool>(
                          context: ctx,
                          builder: (dialogCtx) => AlertDialog(
                            title: const Text('Pick a color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: (c) => pickerColor = c,
                                enableAlpha: false,
                                labelTypes: const [],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogCtx, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(dialogCtx, true),
                                child: const Text('Apply'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          ref
                              .read(editorProvider.notifier)
                              .updateCanvasColor(pickerColor);
                          if (ctx.mounted) Navigator.pop(ctx);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // QR code dialog + bottom sheet.
  Future<void> _showQrDialog(BuildContext context, WidgetRef ref) async {
    // Check host email is configured first
    final hostEmail = ref.read(hostSettingsProvider).valueOrNull ?? '';
    if (hostEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set your email in Settings first.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final title = await showDialog<String>(
      context: context,
      builder: (ctx) {
        String value = '';
        return AlertDialog(
          title: const Text('QR Code'),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Event Title'),
            onChanged: (v) => value = v,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(
                  ctx, value.trim().isEmpty ? 'My Event' : value.trim()),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (title == null || !context.mounted) return;

    final subject = Uri.encodeComponent('RSVP: $title');
    final body = Uri.encodeComponent(
      'Name: \nAttending: Yes / No\nNumber of guests: \nMessage: ',
    );
    final qrData = 'mailto:$hostEmail?subject=$subject&body=$body';
    final qrId = DateTime.now().millisecondsSinceEpoch.toString();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200,
            ),
            const SizedBox(height: 12),
            const Text(
              'Share this QR for guests to RSVP',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add to Canvas'),
              onPressed: () {
                ref.read(editorProvider.notifier).addElement(
                      QrElement(
                        id: qrId,
                        x: (canvasSize.width - 150) / 2,
                        y: (canvasSize.height - 150) / 2,
                        width: 150,
                        height: 150,
                        data: qrData,
                      ),
                    );
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Task 8: emoji sticker picker bottom sheet.
  void _showStickerPicker(BuildContext context, WidgetRef ref) {
    const groups = [
      (label: 'Decorative', stickers: ['✨', '🌟', '⭐', '💫', '🎀', '🌈', '🦋', '🌸', '🌺', '🌻']),
      (label: 'Wedding', stickers: ['💍', '👰', '🤵', '💒', '🥂', '🌹', '💐', '🕊️', '💝', '🎊']),
      (label: 'Funeral', stickers: ['🕊️', '🙏', '🪻', '🕯️', '🌿', '🌾', '💙', '🌙', '✝️', '🫶']),
      (label: 'Birthday', stickers: ['🎂', '🎉', '🎈', '🎁', '🥳', '🍰', '🎊', '🎶', '🎵', '🏆']),
    ];
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.85,
        builder: (ctx, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const Text(
              'Pick a sticker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            for (final group in groups) ...[
              Text(
                group.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: group.stickers
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
              const SizedBox(height: 16),
            ],
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
            icon: const Icon(Icons.format_color_fill),
            tooltip: 'Background color',
            onPressed: () => _showBgColorPicker(context, ref),
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
          // Image picker — Pro only
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: 'Add Image (Pro)',
            onPressed: () async {
              final isPro = ref.read(isProProvider);
              if (!isPro) {
                onShowUpgradeSheet();
                return;
              }
              // Show bottom sheet: gallery, camera, or polaroid
              final pick = await showModalBottomSheet<(ImageSource, bool)>(
                context: context,
                builder: (ctx) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Choose from Gallery'),
                        onTap: () => Navigator.pop(ctx, (ImageSource.gallery, false)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('Take a Photo'),
                        onTap: () => Navigator.pop(ctx, (ImageSource.camera, false)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera_outlined),
                        title: const Text('Polaroid Photo'),
                        subtitle: const Text('사진을 폴라로이드 프레임으로 추가'),
                        onTap: () => Navigator.pop(ctx, (ImageSource.camera, true)),
                      ),
                    ],
                  ),
                ),
              );
              if (pick == null) return;
              final (source, isPolaroid) = pick;
              final picked = await ImagePicker().pickImage(source: source);
              if (picked == null) return;
              ref.read(editorProvider.notifier).addElement(
                    ImageElement(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      x: (canvasSize.width - 200) / 2,
                      y: (canvasSize.height - 200) / 2,
                      width: 200,
                      height: isPolaroid ? 240 : 200,
                      imagePath: picked.path,
                      isPolaroid: isPolaroid,
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
          IconButton(
            icon: const Icon(Icons.qr_code),
            tooltip: 'RSVP QR Code',
            onPressed: () => _showQrDialog(context, ref),
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Polaroid frame widget
// ---------------------------------------------------------------------------

class PolaroidFrame extends StatelessWidget {
  const PolaroidFrame({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 28),
      child: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Center(
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }
}
