/// Smart Umbrella App - Color System
///
/// Premium, beach-friendly color palette designed for high contrast
/// readability in sunlight conditions. Uses curated HSL-based colors
/// with ocean blues, sunset oranges, and sandy neutrals.
library;

import 'package:flutter/material.dart';

/// Main color palette for the Smart Umbrella app
class AppColors {
  const AppColors._();

  // ============================================================
  // PRIMARY COLORS - Ocean & Sky Blues
  // ============================================================

  /// Primary ocean blue - main brand color
  static const Color primary = Color(0xFF0EA5E9);
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color primaryDark = Color(0xFF0284C7);

  /// Deep ocean for dark mode surfaces
  static const Color deepOcean = Color(0xFF0C4A6E);
  static const Color deepOceanDark = Color(0xFF082F49);

  // ============================================================
  // SECONDARY COLORS - Sunset & Warmth
  // ============================================================

  /// Sunset orange for accents and highlights
  static const Color sunset = Color(0xFFF97316);
  static const Color sunsetLight = Color(0xFFFB923C);
  static const Color sunsetDark = Color(0xFFEA580C);

  /// Golden hour yellow for solar indicators
  static const Color solar = Color(0xFFFBBF24);
  static const Color solarLight = Color(0xFFFCD34D);
  static const Color solarDark = Color(0xFFF59E0B);

  // ============================================================
  // NEUTRAL COLORS - Sand & Beach
  // ============================================================

  /// Sandy beige neutrals
  static const Color sand = Color(0xFFFEF3C7);
  static const Color sandLight = Color(0xFFFFFBEB);
  static const Color sandDark = Color(0xFFFDE68A);

  /// Warm gray for text and surfaces
  static const Color warmGray50 = Color(0xFFFAFAF9);
  static const Color warmGray100 = Color(0xFFF5F5F4);
  static const Color warmGray200 = Color(0xFFE7E5E4);
  static const Color warmGray300 = Color(0xFFD6D3D1);
  static const Color warmGray400 = Color(0xFFA8A29E);
  static const Color warmGray500 = Color(0xFF78716C);
  static const Color warmGray600 = Color(0xFF57534E);
  static const Color warmGray700 = Color(0xFF44403C);
  static const Color warmGray800 = Color(0xFF292524);
  static const Color warmGray900 = Color(0xFF1C1917);

  // ============================================================
  // SEMANTIC COLORS
  // ============================================================

  /// Success - sea foam green
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  /// Warning - amber
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  /// Error - coral red
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  /// Info - sky blue
  static const Color info = Color(0xFF06B6D4);
  static const Color infoLight = Color(0xFF22D3EE);
  static const Color infoDark = Color(0xFF0891B2);

  // ============================================================
  // LIGHTING FEATURE COLORS
  // ============================================================

  /// Ambient mode - soft purple glow
  static const Color ambient = Color(0xFFA855F7);

  /// Party mode - vibrant pink
  static const Color party = Color(0xFFEC4899);

  /// Static mode - warm white
  static const Color staticMode = Color(0xFFFFFBEB);

  // ============================================================
  // DARK MODE SURFACE COLORS
  // ============================================================

  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceElevated = Color(0xFF334155);
  static const Color darkBackground = Color(0xFF0F172A);

  // ============================================================
  // LIGHT MODE SURFACE COLORS
  // ============================================================

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF8FAFC);
  static const Color lightBackground = Color(0xFFF1F5F9);

  // ============================================================
  // GRADIENTS
  // ============================================================

  /// Ocean gradient for headers
  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, deepOcean],
  );

  /// Sunset gradient for accent elements
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [sunsetLight, sunset],
  );

  /// Solar gradient for battery/charging indicators
  static const LinearGradient solarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [solarLight, solar],
  );

  /// Party gradient for party mode lighting
  static const LinearGradient partyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [party, ambient],
  );

  /// Dark mode surface gradient (glassmorphism effect)
  static const LinearGradient darkGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x0DFFFFFF)],
  );
}
