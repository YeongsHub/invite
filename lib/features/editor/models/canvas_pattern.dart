import 'dart:math';
import 'package:flutter/material.dart';

/// Defines all available Pro background patterns.
class CanvasPatternDef {
  const CanvasPatternDef({
    required this.id,
    required this.label,
    required this.painter,
    required this.previewColor,
  });

  final String id;
  final String label;
  final CustomPainter Function() painter;
  final Color previewColor; // used for the swatch thumbnail
}

final List<CanvasPatternDef> proPatterns = [
  CanvasPatternDef(
    id: 'rose_garden',
    label: 'Rose Garden',
    painter: () => _RoseGardenPainter(),
    previewColor: const Color(0xFFFCE4EC),
  ),
  CanvasPatternDef(
    id: 'cherry_blossom',
    label: 'Cherry Blossom',
    painter: () => _CherryBlossomPainter(),
    previewColor: const Color(0xFFF8BBD0),
  ),
  CanvasPatternDef(
    id: 'golden_leaves',
    label: 'Golden Leaves',
    painter: () => _GoldenLeavesPainter(),
    previewColor: const Color(0xFFFFF8E1),
  ),
  CanvasPatternDef(
    id: 'classic_lace',
    label: 'Classic Lace',
    painter: () => _ClassicLacePainter(),
    previewColor: const Color(0xFFFAFAFA),
  ),
  CanvasPatternDef(
    id: 'midnight_stars',
    label: 'Midnight Stars',
    painter: () => _MidnightStarsPainter(),
    previewColor: const Color(0xFF0D1B4B),
  ),
  CanvasPatternDef(
    id: 'botanical',
    label: 'Botanical',
    painter: () => _BotanicalPainter(),
    previewColor: const Color(0xFFE8F5E9),
  ),
  CanvasPatternDef(
    id: 'art_deco',
    label: 'Art Deco',
    painter: () => _ArtDecoPainter(),
    previewColor: const Color(0xFF1A1A2E),
  ),
  CanvasPatternDef(
    id: 'confetti',
    label: 'Confetti',
    painter: () => _ConfettiPainter(),
    previewColor: const Color(0xFFFFF9C4),
  ),
];

CustomPainter? getPatternPainter(String? id) {
  if (id == null) return null;
  return proPatterns.where((p) => p.id == id).firstOrNull?.painter();
}

// ---------------------------------------------------------------------------
// Painters
// ---------------------------------------------------------------------------

class _RoseGardenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFFCE4EC);
    canvas.drawRect(Offset.zero & size, bg);

    final paint = Paint()..style = PaintingStyle.fill;
    final rng = Random(42);
    for (int i = 0; i < 40; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final r = 8.0 + rng.nextDouble() * 10;
      _drawRose(canvas, Offset(cx, cy), r, paint);
    }
  }

  void _drawRose(Canvas canvas, Offset center, double r, Paint paint) {
    final petalColors = [
      const Color(0xFFE91E63),
      const Color(0xFFF48FB1),
      const Color(0xFFFFCDD2),
    ];
    for (int p = 0; p < 5; p++) {
      final angle = (p * 2 * pi / 5) - pi / 2;
      final px = center.dx + cos(angle) * r * 0.6;
      final py = center.dy + sin(angle) * r * 0.6;
      paint.color = petalColors[p % 3].withValues(alpha: 0.7);
      canvas.drawCircle(Offset(px, py), r * 0.55, paint);
    }
    paint.color = const Color(0xFFC62828).withValues(alpha: 0.8);
    canvas.drawCircle(center, r * 0.3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _CherryBlossomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFFFF0F5);
    canvas.drawRect(Offset.zero & size, bg);

    final paint = Paint()..style = PaintingStyle.fill;
    final rng = Random(7);
    for (int i = 0; i < 60; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final r = 4.0 + rng.nextDouble() * 7;
      _drawBlossom(canvas, Offset(cx, cy), r, paint);
    }
  }

  void _drawBlossom(Canvas canvas, Offset center, double r, Paint paint) {
    for (int p = 0; p < 5; p++) {
      final angle = p * 2 * pi / 5;
      final px = center.dx + cos(angle) * r;
      final py = center.dy + sin(angle) * r;
      paint.color = const Color(0xFFFFB7C5).withValues(alpha: 0.75);
      canvas.drawCircle(Offset(px, py), r * 0.6, paint);
    }
    paint.color = const Color(0xFFFFD700).withValues(alpha: 0.9);
    canvas.drawCircle(center, r * 0.25, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _GoldenLeavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFFFF8E1);
    canvas.drawRect(Offset.zero & size, bg);

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.5);
    final stemPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFFB8860B).withValues(alpha: 0.5);

    final rng = Random(13);
    for (int i = 0; i < 35; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final angle = rng.nextDouble() * pi;
      final lw = 8.0 + rng.nextDouble() * 12;
      final lh = 14.0 + rng.nextDouble() * 18;
      _drawLeaf(canvas, Offset(cx, cy), lw, lh, angle, paint, stemPaint);
    }
  }

  void _drawLeaf(Canvas canvas, Offset c, double w, double h, double angle,
      Paint fill, Paint stem) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);
    final path = Path()
      ..moveTo(0, -h / 2)
      ..quadraticBezierTo(w / 2, 0, 0, h / 2)
      ..quadraticBezierTo(-w / 2, 0, 0, -h / 2);
    canvas.drawPath(path, fill);
    canvas.drawLine(Offset(0, -h / 2), Offset(0, h / 2), stem);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _ClassicLacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFFAFAFA);
    canvas.drawRect(Offset.zero & size, bg);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = const Color(0xFFBDBDBD).withValues(alpha: 0.6);

    const spacing = 36.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        _drawLaceMotif(canvas, Offset(x, y), spacing * 0.42, paint);
      }
    }
  }

  void _drawLaceMotif(Canvas canvas, Offset center, double r, Paint paint) {
    canvas.drawCircle(center, r, paint);
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final x = center.dx + cos(angle) * r;
      final y = center.dy + sin(angle) * r;
      canvas.drawCircle(Offset(x, y), r * 0.3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _MidnightStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0D1B4B);
    canvas.drawRect(Offset.zero & size, bg);

    final paint = Paint()..style = PaintingStyle.fill;
    final rng = Random(99);
    for (int i = 0; i < 80; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 1.0 + rng.nextDouble() * 3.5;
      final alpha = 0.4 + rng.nextDouble() * 0.6;
      paint.color = Colors.white.withValues(alpha: alpha);
      _drawStar(canvas, Offset(x, y), r, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = i * 2 * pi / 5 - pi / 2;
      final innerAngle = outerAngle + pi / 5;
      final ox = center.dx + cos(outerAngle) * r;
      final oy = center.dy + sin(outerAngle) * r;
      final ix = center.dx + cos(innerAngle) * r * 0.4;
      final iy = center.dy + sin(innerAngle) * r * 0.4;
      if (i == 0) { path.moveTo(ox, oy); } else { path.lineTo(ox, oy); }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _BotanicalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE8F5E9);
    canvas.drawRect(Offset.zero & size, bg);

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF388E3C).withValues(alpha: 0.3);
    final stem = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFF2E7D32).withValues(alpha: 0.4);

    final rng = Random(55);
    for (int i = 0; i < 30; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final scale = 0.6 + rng.nextDouble() * 0.8;
      _drawBranch(canvas, Offset(cx, cy), scale, fill, stem);
    }
  }

  void _drawBranch(Canvas canvas, Offset base, double scale, Paint fill, Paint stem) {
    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.rotate(-pi / 4);
    final stemPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, -30 * scale);
    canvas.drawPath(stemPath, stem);
    for (int j = 0; j < 4; j++) {
      final y = -8.0 * scale * (j + 1);
      final side = j % 2 == 0 ? 1 : -1;
      canvas.save();
      canvas.translate(0, y);
      canvas.rotate(side * pi / 5);
      final lw = (6 + j.toDouble()) * scale;
      final lh = (12 + j * 2.0) * scale;
      final path = Path()
        ..moveTo(0, -lh / 2)
        ..quadraticBezierTo(lw / 2, 0, 0, lh / 2)
        ..quadraticBezierTo(-lw / 2, 0, 0, -lh / 2);
      canvas.drawPath(path, fill);
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _ArtDecoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawRect(Offset.zero & size, bg);

    final gold = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.55);

    const spacing = 50.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        _drawDecoBurst(canvas, Offset(x, y), 18, gold);
      }
    }
  }

  void _drawDecoBurst(Canvas canvas, Offset c, double r, Paint paint) {
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      canvas.drawLine(
        Offset(c.dx + cos(angle) * r * 0.4, c.dy + sin(angle) * r * 0.4),
        Offset(c.dx + cos(angle) * r, c.dy + sin(angle) * r),
        paint,
      );
    }
    canvas.drawCircle(c, r * 0.35, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFFFF9C4);
    canvas.drawRect(Offset.zero & size, bg);

    final colors = [
      const Color(0xFFE91E63),
      const Color(0xFF3F51B5),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
      const Color(0xFF00BCD4),
    ];
    final rng = Random(21);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 80; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final w = 4.0 + rng.nextDouble() * 8;
      final h = 2.0 + rng.nextDouble() * 5;
      final angle = rng.nextDouble() * pi;
      paint.color = colors[i % colors.length].withValues(alpha: 0.7);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: w, height: h), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
