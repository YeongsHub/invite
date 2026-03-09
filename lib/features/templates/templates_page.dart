import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invite/core/router/app_router.dart';
import 'package:invite/core/theme/app_colors.dart';
import 'package:invite/core/theme/app_text_styles.dart';
import 'package:invite/features/templates/data/template_data.dart';
import 'package:invite/features/templates/models/template_model.dart';

class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Templates')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: TemplateCategory.values.map((category) {
          final templates = defaultTemplates
              .where((t) => t.category == category)
              .toList();
          return _CategorySection(category: category, templates: templates);
        }).toList(),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.templates,
  });

  final TemplateCategory category;
  final List<InviteTemplate> templates;

  String get _categoryLabel => switch (category) {
        TemplateCategory.wedding => 'Wedding',
        TemplateCategory.funeral => 'Funeral',
        TemplateCategory.birthday => 'Birthday',
      };

  IconData get _categoryIcon => switch (category) {
        TemplateCategory.wedding => Icons.favorite,
        TemplateCategory.funeral => Icons.local_florist,
        TemplateCategory.birthday => Icons.cake,
      };

  Color get _categoryColor => switch (category) {
        TemplateCategory.wedding => AppColors.weddingRose,
        TemplateCategory.funeral => AppColors.funeralNavy,
        TemplateCategory.birthday => AppColors.birthdayCoral,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(_categoryIcon, color: _categoryColor, size: 22),
              const SizedBox(width: 8),
              Text(_categoryLabel, style: AppTextStyles.heading2),
            ],
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3 / 4,
          children: templates.map((t) => _TemplateCard(template: t)).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});

  final InviteTemplate template;

  TextStyle get _titleStyle => switch (template.category) {
        TemplateCategory.wedding => AppTextStyles.weddingTitle,
        TemplateCategory.funeral => AppTextStyles.funeralTitle,
        TemplateCategory.birthday => AppTextStyles.birthdayTitle,
      };

  TextStyle get _bodyStyle => switch (template.category) {
        TemplateCategory.wedding => AppTextStyles.weddingBody,
        TemplateCategory.funeral => AppTextStyles.funeralBody,
        TemplateCategory.birthday => AppTextStyles.birthdayBody,
      };

  String get _titleSample => switch (template.category) {
        TemplateCategory.wedding => 'Your Names Here',
        TemplateCategory.funeral => 'In Loving Memory',
        TemplateCategory.birthday => 'Party Time!',
      };

  String get _bodySample => switch (template.category) {
        TemplateCategory.wedding => 'Date · Venue',
        TemplateCategory.funeral => 'Date of Service',
        TemplateCategory.birthday => 'Join the celebration',
      };

  @override
  Widget build(BuildContext context) {
    final palette = template.colorPalette;

    return GestureDetector(
      onTap: () => context.go('/editor', extra: EditorRouteExtra(templateId: template.id)),
      child: Container(
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top 45%: styled header band with category title font
            Expanded(
              flex: 45,
              child: Container(
                decoration: BoxDecoration(
                  color: palette.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  _titleSample,
                  style: _titleStyle.copyWith(
                    color: palette.accent,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Bottom 55%: background with layout lines, body sample, and name
            Expanded(
              flex: 55,
              child: Container(
                color: palette.background,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _bodySample,
                          style: _bodyStyle.copyWith(
                            color: palette.text,
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Divider(
                          height: 1,
                          thickness: 0.8,
                          color: palette.text.withValues(alpha: 0.15),
                        ),
                        const SizedBox(height: 4),
                        Divider(
                          height: 1,
                          thickness: 0.8,
                          color: palette.text.withValues(alpha: 0.15),
                        ),
                      ],
                    ),
                    Text(
                      template.name,
                      style: AppTextStyles.caption.copyWith(
                        color: palette.text,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
