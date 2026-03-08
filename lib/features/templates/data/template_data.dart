import 'package:invite/core/theme/app_colors.dart';
import 'package:invite/features/templates/models/template_model.dart';

final List<InviteTemplate> defaultTemplates = [
  // Wedding — warm ivory & antique gold tones
  InviteTemplate(
    id: 'wedding_rose',
    name: 'Rose Garden',
    category: TemplateCategory.wedding,
    colorPalette: {
      'primary': AppColors.weddingRose,
      'accent': AppColors.weddingGold,
      'background': AppColors.weddingCream,
      'text': AppColors.weddingText,
    },
    thumbnailAsset: 'assets/templates/wedding_rose.png',
  ),
  InviteTemplate(
    id: 'wedding_gold',
    name: 'Golden Elegance',
    category: TemplateCategory.wedding,
    colorPalette: {
      'primary': AppColors.weddingGold,
      'accent': AppColors.weddingBlush,
      'background': AppColors.weddingCream,
      'text': AppColors.weddingText,
    },
    thumbnailAsset: 'assets/templates/wedding_gold.png',
  ),

  // Funeral — muted charcoal & silver dignity
  InviteTemplate(
    id: 'funeral_navy',
    name: 'Quiet Charcoal',
    category: TemplateCategory.funeral,
    colorPalette: {
      'primary': AppColors.funeralNavy,
      'accent': AppColors.funeralSilver,
      'background': AppColors.funeralWhite,
      'text': AppColors.funeralText,
    },
    thumbnailAsset: 'assets/templates/funeral_navy.png',
  ),
  InviteTemplate(
    id: 'funeral_silver',
    name: 'Silver Serenity',
    category: TemplateCategory.funeral,
    colorPalette: {
      'primary': AppColors.funeralSilver,
      'accent': AppColors.funeralSlate,
      'background': AppColors.funeralWhite,
      'text': AppColors.funeralText,
    },
    thumbnailAsset: 'assets/templates/funeral_silver.png',
  ),

  // Birthday — vivid & playful energy
  InviteTemplate(
    id: 'birthday_confetti',
    name: 'Confetti Pop',
    category: TemplateCategory.birthday,
    colorPalette: {
      'primary': AppColors.birthdayPurple,
      'accent': AppColors.birthdayCoral,
      'background': AppColors.birthdayYellow,
      'text': AppColors.birthdayText,
    },
    thumbnailAsset: 'assets/templates/birthday_confetti.png',
  ),
  InviteTemplate(
    id: 'birthday_coral',
    name: 'Coral Fiesta',
    category: TemplateCategory.birthday,
    colorPalette: {
      'primary': AppColors.birthdayCoral,
      'accent': AppColors.birthdayTeal,
      'background': AppColors.birthdayPurple,
      'text': AppColors.surface,
    },
    thumbnailAsset: 'assets/templates/birthday_coral.png',
  ),
];
