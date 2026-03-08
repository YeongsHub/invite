import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Wedding — elegant serif, light weight
  static const TextStyle weddingTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w300,
    fontFamily: 'serif',
    letterSpacing: 2.0,
    height: 1.4,
    color: Color(0xFF4A3728),
  );

  static const TextStyle weddingBody = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    fontFamily: 'serif',
    letterSpacing: 0.8,
    height: 1.6,
    color: Color(0xFF6B5B4E),
  );

  // Funeral — dignified, generous letter-spacing
  static const TextStyle funeralTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 3.0,
    height: 1.5,
    color: Color(0xFF2C2C34),
  );

  static const TextStyle funeralBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.6,
    height: 1.7,
    color: Color(0xFF5C5C66),
  );

  // Birthday — bold, playful, tight spacing
  static const TextStyle birthdayTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
    color: Color(0xFF1A1A2E),
  );

  static const TextStyle birthdayBody = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.5,
    color: Color(0xFF1A1A2E),
  );
}
