import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary    = Color(0xFF1B5E20);
  static const Color accent     = Color(0xFFFF8F00);
  static const Color background = Color(0xFFF5F5F0);

  static Color difficultyColor(String d) {
    switch (d) {
      case 'fácil':    return const Color(0xFF43A047);
      case 'moderado': return const Color(0xFFFF8F00);
      case 'difícil':  return const Color(0xFFE53935);
      case 'experto':  return const Color(0xFF6A1B9A);
      default:         return const Color(0xFFFF8F00);
    }
  }

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
