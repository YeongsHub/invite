import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(_categoryLabel, style: AppTextStyles.heading2),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
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

  @override
  Widget build(BuildContext context) {
    final bgColor =
        template.colorPalette['background'] ?? AppColors.surface;
    final primaryColor =
        template.colorPalette['primary'] ?? AppColors.primary;

    return GestureDetector(
      onTap: () => context.go('/editor', extra: template.id),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                template.name,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
