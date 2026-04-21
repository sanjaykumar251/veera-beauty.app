import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Color Palette (Premium Beauty Dark Theme) ───────────────────────────────
  static const Color backgroundDark = Color(0xFF0D0D14);
  static const Color surfaceDark = Color(0xFF16161F);
  static const Color cardDark = Color(0xFF1E1E2A);
  static const Color cardDark2 = Color(0xFF252535);

  // Rose Gold Primary
  static const Color primary = Color(0xFFB76E79);
  static const Color primaryLight = Color(0xFFD4949D);
  static const Color primaryDark = Color(0xFF8B4A54);

  // Gold Accent
  static const Color accent = Color(0xFFD4AF37);
  static const Color accentLight = Color(0xFFE8C96A);
  static const Color accentDark = Color(0xFFA68B2A);

  // Text
  static const Color textPrimary = Color(0xFFF5F0E8);
  static const Color textSecondary = Color(0xFFB8B0C8);
  static const Color textMuted = Color(0xFF6B6480);

  // Status
  static const Color success = Color(0xFF4CAF82);
  static const Color warning = Color(0xFFFFB74D);
  static const Color error = Color(0xFFE57373);
  static const Color info = Color(0xFF64B5F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFB76E79), Color(0xFF8B4A54)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFA68B2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E1E2A), Color(0xFF0D0D14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF252535), Color(0xFF1A1A26)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0D0D14), Color(0xFF1A0A10), Color(0xFF2A1020)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Text Theme ───────────────────────────────────────────────────────────────
  static TextTheme get textTheme => TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 36, fontWeight: FontWeight.bold, color: textPrimary, height: 1.2,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 28, fontWeight: FontWeight.bold, color: textPrimary, height: 1.2,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15, fontWeight: FontWeight.normal, color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, color: textSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12, color: textMuted,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary, letterSpacing: 0.5,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary, letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10, fontWeight: FontWeight.w500, color: textMuted, letterSpacing: 0.8,
        ),
      );

  // ─── Dark Theme ───────────────────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: primary,
          onPrimary: Colors.white,
          secondary: accent,
          onSecondary: Colors.black,
          surface: surfaceDark,
          onSurface: textPrimary,
          error: error,
          background: backgroundDark,
        ),
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary,
          ),
          iconTheme: const IconThemeData(color: textPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: primary, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primary),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardDark,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2A2A3A)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2A2A3A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: error),
          ),
          labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
          hintStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
        ),
        cardTheme: CardThemeData(
          color: cardDark,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surfaceDark,
          selectedItemColor: primary,
          unselectedItemColor: textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surfaceDark,
          indicatorColor: primary.withOpacity(0.2),
          labelTextStyle: WidgetStateProperty.all(
            GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: cardDark,
          selectedColor: primary.withOpacity(0.2),
          labelStyle: GoogleFonts.inter(fontSize: 12, color: textSecondary),
          side: const BorderSide(color: Color(0xFF2A2A3A)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF2A2A3A),
          thickness: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: cardDark2,
          contentTextStyle: GoogleFonts.inter(color: textPrimary, fontSize: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
