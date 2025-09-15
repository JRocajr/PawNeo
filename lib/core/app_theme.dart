import 'package:flutter/material.dart';

class AppTheme {
  static const Color _midnight = Color(0xFF0F172A);
  static const Color _royal = Color(0xFF4659FF);
  static const Color _aqua = Color(0xFF1FC8FF);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _royal,
        brightness: Brightness.light,
      ),
    );

    final cs = base.colorScheme.copyWith(
      primary: _royal,
      onPrimary: Colors.white,
      secondary: _aqua,
      onSecondary: Colors.black,
      background: const Color(0xFFF3F5FA),
      surface: Colors.white,
      surfaceTint: Colors.white,
      outlineVariant: const Color(0xFFE3E7F4),
    );

    return base.copyWith(
      colorScheme: cs,
      scaffoldBackgroundColor: cs.background,
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        foregroundColor: _midnight,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: _midnight,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 74,
        backgroundColor: Colors.white.withOpacity(0.92),
        indicatorColor: _royal.withOpacity(0.16),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(MaterialState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(MaterialState.selected)
                ? _royal
                : _midnight.withOpacity(0.55),
          ),
        ),
        iconTheme: MaterialStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(MaterialState.selected)
                ? _royal
                : _midnight.withOpacity(0.6),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        shadowColor: Colors.black.withOpacity(0.06),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _royal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _royal,
          side: const BorderSide(color: Color(0xFFCBD3FF)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFFE6EAFA),
        selectedColor: _royal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: _midnight.withOpacity(0.45)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE3E7F4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE3E7F4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _royal),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.white,
        dense: true,
        iconColor: _midnight.withOpacity(0.7),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE8EBF6),
        space: 0,
        thickness: 1,
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: _midnight,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: _midnight,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: _midnight,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: _midnight,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: _midnight,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: _midnight.withOpacity(0.7),
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: _midnight.withOpacity(0.84)),
      bodyMedium: base.bodyMedium?.copyWith(color: _midnight.withOpacity(0.7)),
      bodySmall: base.bodySmall?.copyWith(color: _midnight.withOpacity(0.55)),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class AppGradients {
  const AppGradients._();

  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF161C3C), Color(0xFF1C2556), Color(0xFF3452FF)],
  );

  static const LinearGradient action = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3AC8FF), Color(0xFF7DF5D0)],
  );
}

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> primary = [
    BoxShadow(
      color: Color(0x1A1B2559),
      blurRadius: 32,
      offset: Offset(0, 18),
    ),
  ];
}

String money(num n) {
  final value = n.toStringAsFixed(0);
  return '\$$value';
}

