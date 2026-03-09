import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invite/core/di/locale_provider.dart';
import 'package:invite/core/router/app_router.dart';
import 'package:invite/core/theme/app_colors.dart';
import 'package:invite/core/theme/app_text_styles.dart';
import 'package:invite/features/templates/data/template_data.dart';
import 'package:invite/features/templates/models/template_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TemplatesPage extends ConsumerWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.templates),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Select language',
            onPressed: () => _showLanguageSelector(context, ref),
          ),
        ],
      ),
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

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => _LanguageSelectorSheet(
        currentLocale: ref.read(localeProvider),
        onSelected: (locale) {
          ref.read(localeProvider.notifier).state = locale;
          Navigator.of(ctx).pop();
        },
      ),
    );
  }
}

class _LanguageSelectorSheet extends StatelessWidget {
  const _LanguageSelectorSheet({
    required this.currentLocale,
    required this.onSelected,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onSelected;

  static const _languages = [
    (locale: Locale('en'), nativeName: 'English'),
    (locale: Locale('ko'), nativeName: '한국어'),
    (locale: Locale('ja'), nativeName: '日本語'),
    (locale: Locale('es'), nativeName: 'Español'),
    (locale: Locale('fr'), nativeName: 'Français'),
    (locale: Locale('zh'), nativeName: '中文（简体）'),
    (locale: Locale('ar'), nativeName: 'العربية'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          for (final lang in _languages)
            ListTile(
              title: Text(lang.nativeName),
              trailing: currentLocale.languageCode == lang.locale.languageCode
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () => onSelected(lang.locale),
            ),
          const SizedBox(height: 8),
        ],
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

  String _categoryLabel(AppLocalizations l10n) => switch (category) {
        TemplateCategory.wedding => l10n.wedding,
        TemplateCategory.funeral => l10n.funeral,
        TemplateCategory.birthday => l10n.birthday,
      };

  IconData get _categoryIcon => switch (category) {
        TemplateCategory.wedding => Icons.diamond_outlined,
        TemplateCategory.funeral => Icons.church,
        TemplateCategory.birthday => Icons.cake,
      };

  Color get _categoryColor => switch (category) {
        TemplateCategory.wedding => AppColors.weddingRose,
        TemplateCategory.funeral => AppColors.funeralNavy,
        TemplateCategory.birthday => AppColors.birthdayCoral,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(_categoryIcon, color: _categoryColor, size: 22),
              const SizedBox(width: 8),
              Text(_categoryLabel(l10n), style: AppTextStyles.heading2),
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
      onTap: () => context.push('/editor', extra: EditorRouteExtra(templateId: template.id)),
      child: Container(
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
