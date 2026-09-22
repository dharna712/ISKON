import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Peacock-feather / Krishna-inspired palette: iridescent teals and
/// emeralds as primary, royal purple as secondary, bronze/gold as accent.
class AppColors {
  // Backgrounds
  static const sand = Color(0xFFF6F2E9); // warm cream, reading screens
  static const card = Color(0xFFFFFFFF);
  static const midnight = Color(0xFF0B1E2E); // deep spiritual dark bg
  static const midnightDeep = Color(0xFF071420);

  // Primary — peacock teal / emerald
  static const marigold = Color(0xFF0E8C7A); // primary CTA
  static const marigoldDeep = Color(0xFF0A6156); // pressed/shadow
  static const emerald = Color(0xFF1F9D6F);

  // Secondary — royal purple / peacock blue
  static const teal = Color(0xFF4B2E83); // secondary CTA
  static const tealDeep = Color(0xFF32205A);
  static const royalBlue = Color(0xFF1E4E8C);

  // Accent — bronze / copper / gold
  static const turmeric = Color(0xFFC08A3E); // badges, quote marks, dots
  static const bronze = Color(0xFFA86A32);
  static const gold = Color(0xFFE8C874);

  // Text
  static const ink = Color(0xFF2A2438);
  static const heading = Color(0xFF1E3B3A);
  static const soft = Color(0xFF7C7690);

  // Feedback
  static const green = Color(0xFF2E9C63);
  static const red = Color(0xFFB23A2E);

  static const line = Color(0xFFE4DECF);

  static const peacockGradient = [
    Color(0xFF0B1E2E),
    Color(0xFF0E4C4A),
    Color(0xFF3B2166),
  ];
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.sand,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.marigold,
      primary: AppColors.marigold,
      secondary: AppColors.teal,
      tertiary: AppColors.bronze,
      surface: AppColors.card,
    ),
  );
  // Sanskrit (IAST diacritics like ṁ, ṭ, ś) and Devanagari (Hindi) glyphs
  // aren't covered by the platform default font everywhere, so pull in
  // Noto Sans + Noto Sans Devanagari explicitly as a fallback chain.
  final bodyFallback = [GoogleFonts.notoSansDevanagari().fontFamily!];
  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: GoogleFonts.notoSans().fontFamily,
      fontFamilyFallback: bodyFallback,
      bodyColor: AppColors.ink,
      displayColor: AppColors.heading,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.sand,
      foregroundColor: AppColors.heading,
      elevation: 0,
      titleTextStyle: GoogleFonts.marcellus(
        fontSize: 19,
        color: AppColors.heading,
        fontWeight: FontWeight.w600,
      ),
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

/// Elegant, slightly-traditional heading font (Marcellus) for scripture
/// and section titles, with the Devanagari fallback so Hindi headings
/// (chapter names, etc.) still render correctly.
TextStyle appHeadingStyle({double fontSize = 20, Color? color, FontWeight? weight}) {
  return GoogleFonts.marcellus(
    fontSize: fontSize,
    color: color ?? AppColors.heading,
    fontWeight: weight ?? FontWeight.w600,
  ).copyWith(fontFamilyFallback: [GoogleFonts.notoSansDevanagari().fontFamily!]);
}
