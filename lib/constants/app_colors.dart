import 'package:flutter/material.dart';

/// AppColors is the centralized color palette for the Sayak Grocery eCommerce App.
/// Derived directly from the official Sayak brand logo (Forest Green, Leaf Green, Kraft Amber, Tomato Red & Fresh Cream).
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Brand Greens (Extracted from the Sayak Logo & Hand Ribbon Graphic)
  static const Color brandDark = Color(0xFF063A20); // Deep Forest Green (Logo Typography)
  static const Color brandPrimary = Color(0xFF0A5830); // Primary Sayak Green
  static const Color brandMedium = Color(0xFF147A46); // Rich Emerald Leaf
  static const Color brandLight = Color(0xFF22C55E); // Speed Trail Leaf Green
  static const Color brandBright = Color(0xFF4ADE80); // Fresh Sprout Green
  
  // Aliases for standard theme usage
  static const Color primary = Color(0xFF0A5830);
  static const Color primaryDark = Color(0xFF063A20);
  static const Color primaryLight = Color(0xFFD8F3DC); // Pale mint tint
  static const Color primarySurface = Color(0xFFEDF8F0); // Subtle background tint
  static const Color primaryBorder = Color(0xFFB7E4C7);

  // Logo Fresh Produce & Bag Accents
  static const Color kraftBag = Color(0xFFD4A373); // Paper grocery bag amber
  static const Color kraftLight = Color(0xFFFAF3EC);
  static const Color accentOrange = Color(0xFFF77F00); // Fresh Carrot Orange
  static const Color accentTomato = Color(0xFFE63946); // Fresh Red Pepper / Tomato
  static const Color accentYellow = Color(0xFFFBBF24); // Fresh Yellow Bell Pepper
  static const Color accent = Color(0xFFF77F00);
  static const Color accentLight = Color(0xFFFFEDD5);

  // Clean Organic Backgrounds & Card Surfaces
  static const Color background = Color(0xFFF5FAF6); // Fresh organic off-white
  static const Color backgroundLight = Color(0xFFFAFDFB);
  static const Color surface = Color(0xFFFFFFFF); // Pure white card surface
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFFF1F7F3); // Soft green-grey input fill
  static const Color inputBackgroundFocused = Color(0xFFFFFFFF);

  // Typography / Text Colors
  static const Color textPrimary = Color(0xFF0B2416); // Deep Forest Slate (High contrast)
  static const Color textSecondary = Color(0xFF385544); // Sage Forest Medium
  static const Color textMuted = Color(0xFF7A9786); // Light Sage Placeholder
  static const Color textLight = Color(0xFFFFFFFF); // Pure White on Buttons
  static const Color textLink = Color(0xFF0A5830); // Forest Green Link

  // Borders & Dividers
  static const Color border = Color(0xFFDDECE1); // Subtle organic border
  static const Color borderFocused = Color(0xFF0A5830); // Focus brand border
  static const Color borderError = Color(0xFFE63946);
  static const Color divider = Color(0xFFE4EFE7);

  // Status & Feedback Colors
  static const Color success = Color(0xFF147A46);
  static const Color successBackground = Color(0xFFD8F3DC);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBackground = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFE63946);
  static const Color errorBackground = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);

  // Social Auth Colors
  static const Color googleBorder = Color(0xFFDDECE1);
  static const Color appleBackground = Color(0xFF000000);
  static const Color phoneOtpBackground = Color(0xFFEDF8F0);

  // Brand Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF063A20), Color(0xFF0A5830), Color(0xFF147A46)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0A5830), Color(0xFF16834B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF042615), Color(0xFF063A20), Color(0xFF0A5830)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardHeaderGradient = LinearGradient(
    colors: [Color(0xFFEDF8F0), Color(0xFFF5FAF6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient badgeGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF147A46)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient carrotGradient = LinearGradient(
    colors: [Color(0xFFF77F00), Color(0xFFE65100)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Modern Soft Shadows
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF0B2416).withValues(alpha: 0.05),
          blurRadius: 20,
          spreadRadius: 1,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get cardElevation => [
        BoxShadow(
          color: const Color(0xFF0A5830).withValues(alpha: 0.08),
          blurRadius: 24,
          spreadRadius: 0,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: const Color(0xFF0A5830).withValues(alpha: 0.38),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get logoGlow => [
        BoxShadow(
          color: const Color(0xFF22C55E).withValues(alpha: 0.25),
          blurRadius: 30,
          spreadRadius: 4,
          offset: const Offset(0, 10),
        ),
      ];
}
