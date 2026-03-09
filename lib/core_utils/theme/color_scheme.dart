import 'package:flutter/material.dart';

class TColorScheme {
  const TColorScheme._();

  /* ============================================================
   * LIGHT THEME — Expense Tracker
   * Palette:
   * #ff9f1c #ffbf69 #ffffff #cbf3f0 #2ec4b6
   * ============================================================ */

  // Brand
  static const Color lightPrimary = Color(0xFF004F2D); // Teal
  static const Color lightSecondary = Color(0xFFFBFFFE); // Orange

  // Canvas & Surfaces
  static const Color lightBackground = Color(0xFFFBFFFE); // White
  static const Color lightSurface = Color(0xFFFBFFFE); // Cards / sections
  static const Color lightSurfaceContainer = Color(0xFF5DA271); // Soft mint

  // Text
  static const Color lightOnBackground = Color(0xFF0F172A);
  static const Color lightOnSurface = Color(0xFF0F172A);
  static const Color lightOnSurfaceContainer = Color(0xFFFBFFFE);
  // Semantic
  static const Color income = Color(0xFF2EC4B6);
  static const Color expense = Color(0xFFFF9F1C);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color error = Color(0xFFDC2626);

  /* ----------------------------
   * Light ColorScheme
   * ---------------------------- */
  static final ColorScheme light = ColorScheme(
    brightness: Brightness.light,

    primary: lightPrimary,
    onPrimary: Colors.white,

    secondary: lightSecondary,
    onSecondary: Colors.white,

    background: lightBackground,
    onBackground: lightOnBackground,

    surface: lightSurface,
    onSurface: lightOnSurface,

    surfaceContainerHighest: lightSurfaceContainer,

    error: error,
    onError: Colors.white,
  );

  /* ============================================================
   * DARK THEME — Fintech Dark Mode
   * Palette:
   * #0466c8 #0353a4 #023e7d #002855 #001845
   * #001233 #33415c #5c677d #7d8597 #979dac
   * ============================================================ */

  // Brand
  static const Color darkPrimary = Color(0xFF004F2D);
  static const Color darkSecondary = Color(0xFFFBFFFE);

  // Canvas & Surfaces
  static const Color darkBackground = Color(0xFFFBFFFE);
  static const Color darkSurface = Color(0xFFFBFFFE);
  static const Color darkSurfaceContainer = Color(0xFF5DA271);

  // Text
  static const Color darkOnBackground = Color(0xFF0F172A);
  static const Color darkOnSurface = Color(0xFF0F172A);
  static const Color darkTextSecondary = Color(0xFFFBFFFE);

  // Semantic
  static const Color darkDivider = Color(0xFF33415C);

  /* ----------------------------
   * Dark ColorScheme
   * ---------------------------- */
  static final ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,

    primary: darkPrimary,
    onPrimary: Colors.white,

    secondary: darkSecondary,
    onSecondary: Colors.white,

    background: darkBackground,
    onBackground: darkOnBackground,

    surface: darkSurface,
    onSurface: darkOnSurface,

    surfaceContainerHighest: darkSurfaceContainer,

    error: error,
    onError: Colors.white,
  );
}
