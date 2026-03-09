import 'package:flutter/material.dart';

enum TemplateCategory { wedding, funeral, birthday }

class ColorPalette {
  const ColorPalette({
    required this.primary,
    required this.accent,
    required this.background,
    required this.text,
  });

  final Color primary;
  final Color accent;
  final Color background;
  final Color text;
}

enum TemplateElementType { text, image, sticker }

class TemplateElement {
  const TemplateElement({
    required this.type,
    required this.x,
    required this.y,
    this.content = '',
    this.width = 260,
    this.height = 40,
    this.fontSize = 16,
  });

  final TemplateElementType type;
  final double x;
  final double y;
  final String content;
  final double width;
  final double height;
  final double fontSize;
}

class InviteTemplate {
  const InviteTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.colorPalette,
    required this.elements,
  });

  final String id;
  final String name;
  final TemplateCategory category;
  final ColorPalette colorPalette;
  final List<TemplateElement> elements;
}
