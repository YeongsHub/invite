import 'package:flutter/material.dart';

enum TemplateCategory { wedding, funeral, birthday }

class InviteTemplate {
  const InviteTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.colorPalette,
    required this.thumbnailAsset,
  });

  final String id;
  final String name;
  final TemplateCategory category;
  final Map<String, Color> colorPalette;
  final String thumbnailAsset;
}
