library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      textTheme: _lightTextTheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: _lightAppBarTheme,
      cardTheme: _lightCardTheme,
      elevatedButtonTheme: _lightElevatedButtonTheme,
      outlinedButtonTheme: _lightOutlinedButtonTheme,
      textButtonTheme: _lightTextButtonTheme,
      iconTheme: const IconThemeData(color: AppColors.slate700),
      sliderTheme: _lightSliderTheme,
      switchTheme: _lightSwitchTheme,
      navigationBarTheme: _lightNavigationBarTheme,
      floatingActionButtonTheme: _fabTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.slate200,
        thickness: 1,
      ),
      snackBarTheme: _lightSnackBarTheme,
      chipTheme: _lightChipTheme,
      inputDecorationTheme: _lightInputTheme,
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      textTheme: _darkTextTheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: _darkAppBarTheme,
      cardTheme: _darkCardTheme,
      elevatedButtonTheme: _darkElevatedButtonTheme,
      outlinedButtonTheme: _darkOutlinedButtonTheme,
      textButtonTheme: _darkTextButtonTheme,
      iconTheme: const IconThemeData(color: AppColors.slate300),
      sliderTheme: _darkSliderTheme,
      switchTheme: _darkSwitchTheme,
      navigationBarTheme: _darkNavigationBarTheme,
      floatingActionButtonTheme: _fabTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.slate700,
        thickness: 1,
      ),
      snackBarTheme: _darkSnackBarTheme,
      chipTheme: _darkChipTheme,
      inputDecorationTheme: _darkInputTheme,
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFEDE9FE),
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.teal,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFCCFBF1),
    onSecondaryContainer: AppColors.tealDark,
    tertiary: AppColors.rose,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFE4E6),
    onTertiaryContainer: AppColors.roseDark,
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: AppColors.slate900,
    surfaceContainerHighest: AppColors.lightSurfaceElevated,
    onSurfaceVariant: AppColors.slate600,
    outline: AppColors.slate300,
    outlineVariant: AppColors.slate200,
  );

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primaryLight,
    onPrimary: AppColors.primaryDark,
    primaryContainer: Color(0xFF3B2476),
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.tealLight,
    onSecondary: AppColors.tealDark,
    secondaryContainer: Color(0xFF134E4A),
    onSecondaryContainer: AppColors.tealLight,
    tertiary: AppColors.roseLight,
    onTertiary: AppColors.roseDark,
    tertiaryContainer: Color(0xFF4C0519),
    onTertiaryContainer: AppColors.roseLight,
    error: AppColors.errorLight,
    onError: AppColors.slate900,
    surface: AppColors.darkSurface,
    onSurface: AppColors.slate100,
    surfaceContainerHighest: AppColors.darkSurfaceElevated,
    onSurfaceVariant: AppColors.slate400,
    outline: AppColors.slate600,
    outlineVariant: AppColors.slate700,
  );

  static TextTheme get _lightTextTheme {
    return GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(fontSize: 57, fontWeight: FontWeight.w400, color: AppColors.slate900),
      displayMedium: GoogleFonts.outfit(fontSize: 45, fontWeight: FontWeight.w400, color: AppColors.slate900),
      displaySmall: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.slate900),
      headlineLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.slate900),
      headlineMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.slate900),
      headlineSmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.slate900),
      titleLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.slate900),
      titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: AppColors.slate900),
      titleSmall: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: AppColors.slate800),
      bodyLarge: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.slate700),
      bodyMedium: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.slate700),
      bodySmall: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.slate500),
      labelLarge: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: AppColors.slate700),
      labelMedium: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: AppColors.slate600),
      labelSmall: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: AppColors.slate500),
    );
  }

  static TextTheme get _darkTextTheme {
    return GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(fontSize: 57, fontWeight: FontWeight.w400, color: AppColors.slate100),
      displayMedium: GoogleFonts.outfit(fontSize: 45, fontWeight: FontWeight.w400, color: AppColors.slate100),
      displaySmall: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.slate100),
      headlineLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.slate100),
      headlineMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.slate100),
      headlineSmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.slate100),
      titleLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.slate100),
      titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: AppColors.slate100),
      titleSmall: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: AppColors.slate200),
      bodyLarge: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.slate300),
      bodyMedium: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.slate300),
      bodySmall: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.slate400),
      labelLarge: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: AppColors.slate300),
      labelMedium: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: AppColors.slate400),
      labelSmall: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: AppColors.slate500),
    );
  }

  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    backgroundColor: AppColors.lightBackground,
    foregroundColor: AppColors.slate900,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    backgroundColor: AppColors.darkBackground,
    foregroundColor: AppColors.slate100,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  static CardThemeData get _lightCardTheme => CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    color: AppColors.lightSurface,
    surfaceTintColor: Colors.transparent,
    shadowColor: AppColors.primary.withValues(alpha: 0.08),
  );

  static CardThemeData get _darkCardTheme => CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    color: AppColors.darkSurface,
    surfaceTintColor: Colors.transparent,
  );

  static ElevatedButtonThemeData get _lightElevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static ElevatedButtonThemeData get _darkElevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.primaryDark,
          textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static OutlinedButtonThemeData get _lightOutlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static OutlinedButtonThemeData get _darkOutlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
          foregroundColor: AppColors.primaryLight,
          textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static TextButtonThemeData get _lightTextButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      foregroundColor: AppColors.primary,
      textStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );

  static TextButtonThemeData get _darkTextButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      foregroundColor: AppColors.primaryLight,
      textStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );

  static SliderThemeData get _lightSliderTheme => SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.slate200,
    thumbColor: AppColors.primary,
    overlayColor: AppColors.primary.withValues(alpha: 0.15),
    trackHeight: 6,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
  );

  static SliderThemeData get _darkSliderTheme => SliderThemeData(
    activeTrackColor: AppColors.primaryLight,
    inactiveTrackColor: AppColors.slate700,
    thumbColor: AppColors.primaryLight,
    overlayColor: AppColors.primaryLight.withValues(alpha: 0.15),
    trackHeight: 6,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
  );

  static SwitchThemeData get _lightSwitchTheme => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? Colors.white : AppColors.slate400;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? AppColors.primary : AppColors.slate200;
    }),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  );

  static SwitchThemeData get _darkSwitchTheme => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? AppColors.primaryDark : AppColors.slate500;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? AppColors.primaryLight : AppColors.slate700;
    }),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  );

  static NavigationBarThemeData get _lightNavigationBarTheme =>
      NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.slate400, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            );
          }
          return GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.slate400,
          );
        }),
      );

  static NavigationBarThemeData get _darkNavigationBarTheme =>
      NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.primaryLight.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryLight, size: 24);
          }
          return const IconThemeData(color: AppColors.slate500, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLight,
            );
          }
          return GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.slate500,
          );
        }),
      );

  static FloatingActionButtonThemeData get _fabTheme =>
      FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );

  static SnackBarThemeData get _lightSnackBarTheme => SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    backgroundColor: AppColors.slate800,
    contentTextStyle: GoogleFonts.outfit(fontSize: 14, color: Colors.white),
  );

  static SnackBarThemeData get _darkSnackBarTheme => SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    backgroundColor: AppColors.darkSurfaceElevated,
    contentTextStyle: GoogleFonts.outfit(fontSize: 14, color: AppColors.slate100),
  );

  static ChipThemeData get _lightChipTheme => ChipThemeData(
    backgroundColor: AppColors.slate100,
    selectedColor: AppColors.primary.withValues(alpha: 0.12),
    labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate700),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    side: BorderSide.none,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  );

  static ChipThemeData get _darkChipTheme => ChipThemeData(
    backgroundColor: AppColors.slate700,
    selectedColor: AppColors.primaryLight.withValues(alpha: 0.15),
    labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate300),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    side: BorderSide.none,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  );

  static InputDecorationTheme get _lightInputTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.slate50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.slate200),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.slate200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  static InputDecorationTheme get _darkInputTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurfaceElevated,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.slate700),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.slate700),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
