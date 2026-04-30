/// Smart Umbrella App - Premium Color System
///
/// Violet-Indigo × Teal × Rose palette.
/// Designed for premium feel, readability, and rich dark/light themes.
library;

import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // ============================================================
  // PRIMARY - Red
  // ============================================================
  static const Color primary = Color(0xFFEF4444);        // red-500
  static const Color primaryLight = Color(0xFFF87171);   // red-400
  static const Color primaryDark = Color(0xFFDC2626);    // red-600

  // ============================================================
  // SECONDARY - Teal
  // ============================================================
  static const Color teal = Color(0xFF2DD4BF);           // teal-400
  static const Color tealLight = Color(0xFF5EEAD4);      // teal-300
  static const Color tealDark = Color(0xFF0D9488);       // teal-600

  // ============================================================
  // ACCENT - White
  // ============================================================
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteLight = Color(0xFFF9FAFB);     // gray-50
  static const Color whiteDark = Color(0xFFF3F4F6);      // gray-100

  // ============================================================
  // ENERGY - Amber / Yellow
  // ============================================================
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFBBF24);
  static const Color amberDark = Color(0xFFD97706);

  // ============================================================
  // SEMANTIC
  // ============================================================
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFB45309);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  static const Color info = Color(0xFF06B6D4);
  static const Color infoLight = Color(0xFF22D3EE);
  static const Color infoDark = Color(0xFF0E7490);

  // ============================================================
  // LIGHTING FEATURE COLORS (kept for lighting feature)
  // ============================================================
  static const Color ambient = Color(0xFFEC4899);        // pink-500
  static const Color party = Color(0xFF8B5CF6);          // violet-500
  static const Color solar = Color(0xFFFBBF24);          // amber-400
  static const Color solarDark = Color(0xFFD97706);

  // ============================================================
  // NEUTRAL SCALE - Gray
  // ============================================================
  static const Color gray50  = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Keep warmGray aliases so existing code doesn't break
  static const Color warmGray50  = gray50;
  static const Color warmGray100 = gray100;
  static const Color warmGray200 = gray200;
  static const Color warmGray300 = gray300;
  static const Color warmGray400 = gray400;
  static const Color warmGray500 = gray500;
  static const Color warmGray600 = gray600;
  static const Color warmGray700 = gray700;
  static const Color warmGray800 = gray800;
  static const Color warmGray900 = gray900;

  // Keep slate aliases for backward compatibility
  static const Color slate50  = gray50;
  static const Color slate100 = gray100;
  static const Color slate200 = gray200;
  static const Color slate300 = gray300;
  static const Color slate400 = gray400;
  static const Color slate500 = gray500;
  static const Color slate600 = gray600;
  static const Color slate700 = gray700;
  static const Color slate800 = gray800;
  static const Color slate900 = gray900;

  // ============================================================
  // SURFACE COLORS
  // ============================================================

  // Light
  static const Color lightBackground      = Color(0xFFFDF2F2); // red tint
  static const Color lightSurface         = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFFEF2F2);

  // Dark
  static const Color darkBackground      = Color(0xFF111827); // gray-900
  static const Color darkSurface         = Color(0xFF1F2937); // gray-800
  static const Color darkSurfaceElevated = Color(0xFF374151); // gray-700

  // ============================================================
  // GRADIENTS
  // ============================================================

  /// Red-Teal aurora — primary brand gradient
  static const LinearGradient auroraGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFF2DD4BF)],
  );

  /// Red gradient — cards / hero
  static const LinearGradient redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );

  /// Hero gradient - Red to Teal
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFF2DD4BF)],
  );

  /// Ember gradient — red to amber
  static const LinearGradient emberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFF59E0B)],
  );

  /// Teal gradient — secondary accent
  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2DD4BF), Color(0xFF0D9488)],
  );

  /// Solar/amber gradient — energy/battery
  static const LinearGradient solarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
  );

  /// Dark glass gradient (glassmorphism)
  static const LinearGradient darkGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x0AFFFFFF)],
  );

  /// Sunset gradient — kept for backward compat (now red)
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFF59E0B)],
  );

  /// Ocean gradient — kept for backward compat (now teal)
  static const LinearGradient oceanGradient = tealGradient;

  // Backward-compat aliases for removed named colors
  static const Color rose      = Color(0xFFF43F5E);
  static const Color roseLight = Color(0xFFFB7185);
  static const Color roseDark  = Color(0xFFE11D48);

  // violetGradient alias → heroGradient so old references still compile
  static const LinearGradient violetGradient = heroGradient;

  // kept for backward compat
  static const Color sunset     = primary;
  static const Color sunsetLight = primaryLight;
  static const Color sunsetDark  = primaryDark;
  static const Color deepOcean   = tealDark;
  static const Color deepOceanDark = Color(0xFF0F766E);
}
