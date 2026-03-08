import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ExportService {
  Future<void> exportToPng(
    GlobalKey repaintBoundaryKey,
    String fileName,
  ) async {
    final boundary = repaintBoundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return;

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    // TODO: Save byteData.buffer.asUint8List() to file at fileName
    // Use path_provider to get documents directory and write the file
  }
}
