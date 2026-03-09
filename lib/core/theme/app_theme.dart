import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          onPrimary: AppColors.onPrimary,
          onSurface: AppColors.onSurface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onSurface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: AppColors.onSurface,
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.heading1.copyWith(
            color: AppColors.onSurface,
          ),
          headlineSmall: AppTextStyles.heading2.copyWith(
            color: AppColors.onSurface,
          ),
          bodyLarge: AppTextStyles.body.copyWith(
            height: 1.5,
            color: AppColors.onSurface,
          ),
          bodySmall: AppTextStyles.caption.copyWith(
            color: AppColors.onSurface,
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.darkSurface,
          onPrimary: AppColors.onPrimary,
          onSurface: AppColors.darkOnSurface,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkOnSurface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: AppColors.darkOnSurface,
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.heading1.copyWith(
            color: AppColors.darkOnSurface,
          ),
          headlineSmall: AppTextStyles.heading2.copyWith(
            color: AppColors.darkOnSurface,
          ),
          bodyLarge: AppTextStyles.body.copyWith(
            height: 1.5,
            color: AppColors.darkOnSurface,
          ),
          bodySmall: AppTextStyles.caption.copyWith(
            color: AppColors.darkOnSurface,
          ),
        ),
      );
}
