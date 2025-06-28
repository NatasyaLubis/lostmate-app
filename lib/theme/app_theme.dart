import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFF875AA);
  static const Color secondary = Color(0xFFFFDFDF);
  static const Color background = Color(0xFFFDF6F0);
  static const Color surface = Colors.white;
  static const Color accent = Color(0xFFFFB4D6);
  static const Color font = Color(0xFF222222);
  static const Color subtitle = Color(0xFF818181);
}

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: AppColors.background,
      onBackground: AppColors.font,
      surface: AppColors.surface,
      onSurface: AppColors.font,
    ),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primary,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.primary),
      titleTextStyle: TextStyle(
        color: AppColors.primary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodyLarge: const TextStyle(
        color: AppColors.font,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: const TextStyle(
        color: AppColors.font,
        fontSize: 14,
      ),
      headlineSmall: const TextStyle(
        color: AppColors.primary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: const TextStyle(
        color: AppColors.font,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      labelLarge: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      labelMedium: const TextStyle(
        color: AppColors.subtitle,
        fontSize: 13,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        elevation: 1.5,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: GoogleFonts.poppins(
          fontSize: 15,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.12), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(0.14), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(
        color: AppColors.subtitle,
        fontSize: 14,
      ),
      hintStyle: GoogleFonts.poppins(
        color: AppColors.subtitle.withOpacity(0.7),
        fontSize: 14,
      ),
      fillColor: Colors.white,
      filled: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.subtitle,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 12,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.primary,
      size: 26,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.secondary.withOpacity(0.5),
      thickness: 1,
      space: 0,
    ),
  );
}
