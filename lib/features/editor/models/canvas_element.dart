import 'package:flutter/material.dart';

abstract class CanvasElement {
  const CanvasElement({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final String id;
  final double x;
  final double y;
  final double width;
  final double height;

  CanvasElement copyWith({double? x, double? y, double? width, double? height});
}

class TextElement extends CanvasElement {
  const TextElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required this.text,
    required this.fontSize,
    required this.color,
  });

  final String text;
  final double fontSize;
  final Color color;

  @override
  TextElement copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    String? text,
    double? fontSize,
    Color? color,
  }) {
    return TextElement(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
    );
  }
}

class ImageElement extends CanvasElement {
  const ImageElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required this.imagePath,
  });

  final String imagePath;

  @override
  ImageElement copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    String? imagePath,
  }) {
    return ImageElement(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class StickerElement extends CanvasElement {
  const StickerElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required this.stickerAsset,
  });

  final String stickerAsset;

  @override
  StickerElement copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    String? stickerAsset,
  }) {
    return StickerElement(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      stickerAsset: stickerAsset ?? this.stickerAsset,
    );
  }
}

class QrElement extends CanvasElement {
  const QrElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required this.data,
  });

  final String data;

  @override
  QrElement copyWith({
    String? id,
    double? x,
    double? y,
    double? width,
    double? height,
    String? data,
  }) {
    return QrElement(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      data: data ?? this.data,
    );
  }
}
