import 'package:flutter/material.dart';

abstract class CanvasElement {
  const CanvasElement({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rotation = 0.0,
  });

  final String id;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;

  CanvasElement copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
  });
}

class TextElement extends CanvasElement {
  const TextElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    super.rotation,
    required this.text,
    required this.fontSize,
    required this.color,
    this.fontFamily,
  });

  final String text;
  final double fontSize;
  final Color color;
  final String? fontFamily;

  @override
  TextElement copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    String? text,
    double? fontSize,
    Color? color,
    Object? fontFamily = _sentinel,
  }) {
    return TextElement(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      fontFamily: fontFamily == _sentinel
          ? this.fontFamily
          : fontFamily as String?,
    );
  }
}

const _sentinel = Object();

class ImageElement extends CanvasElement {
  const ImageElement({
    required super.id,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    super.rotation,
    required this.imagePath,
    this.isPolaroid = false,
  });

  final String imagePath;
  final bool isPolaroid;

  @override
  ImageElement copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    String? imagePath,
    bool? isPolaroid,
  }) {
    return ImageElement(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      imagePath: imagePath ?? this.imagePath,
      isPolaroid: isPolaroid ?? this.isPolaroid,
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
    super.rotation,
    required this.stickerAsset,
  });

  final String stickerAsset;

  @override
  StickerElement copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    String? stickerAsset,
  }) {
    return StickerElement(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
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
    super.rotation,
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
    double? rotation,
    String? data,
  }) {
    return QrElement(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      data: data ?? this.data,
    );
  }
}
