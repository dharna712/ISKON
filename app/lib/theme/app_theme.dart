import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Color palette ported from the reference app's CSS custom properties.
class AppColors {
  static const sand = Color(0xFFFBF3E4);
  static const card = Color(0xFFFFFDF8);
  static const marigold = Color(0xFFE8862E);
  static const marigoldDeep = Color(0xFFCC6A14);
  static const turmeric = Color(0xFFF4B740);
  static const teal = Color(0xFF0E7C7B);
  static const tealDeep = Color(0xFF0A5F5E);
  static const ink = Color(0xFF4A2C1A);
  static const heading = Color(0xFF6B2D1A);
  static const soft = Color(0xFF9A7B62);
  static const green = Color(0xFF3F9D4E);
  static const red = Color(0xFFC0492F);
  static const line = Color(0xFFEADCC4);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.sand,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.marigold,
      primary: AppColors.marigold,
      secondary: AppColors.teal,
      surface: AppColors.card,
    ),
  );
  // Sanskrit (IAST diacritics like ṁ, ṭ, ś) and Devanagari (Hindi) glyphs
  // aren't covered by the platform default font everywhere, so pull in
  // Noto Sans + Noto Sans Devanagari explicitly as a fallback chain.
  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: GoogleFonts.notoSans().fontFamily,
      fontFamilyFallback: [GoogleFonts.notoSansDevanagari().fontFamily!],
      bodyColor: AppColors.ink,
      displayColor: AppColors.heading,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.sand,
      foregroundColor: AppColors.heading,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.marigold,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
      ),
    ),
  );
}
