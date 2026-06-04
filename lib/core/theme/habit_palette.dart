import 'package:flutter/material.dart';

/// A habit accent color resolved into a [base] tone and a [soft] background that
/// adapts to light/dark — mirroring `colorOf()` from data.jsx.
@immutable
class HabitColor {
  const HabitColor(this.base, this.soft);
  final Color base;
  final Color soft;
}

/// Habit category accent colors (tokens.hex.json -> habit).
class HabitPalette {
  HabitPalette._();

  static const _green = (
    base: Color(0xFF399D57),
    soft: Color(0xFFD1F2D7),
    softD: Color(0xFF1E4729),
  );
  static const _sky = (
    base: Color(0xFF259ED6),
    soft: Color(0xFFCFEDFF),
    softD: Color(0xFF0B425C),
  );
  static const _violet = (
    base: Color(0xFF9065D0),
    soft: Color(0xFFECE2FF),
    softD: Color(0xFF443261),
  );
  static const _coral = (
    base: Color(0xFFE76250),
    soft: Color(0xFFFFDDD2),
    softD: Color(0xFF6A2D24),
  );
  static const _amber = (
    base: Color(0xFFDE9C31),
    soft: Color(0xFFFDE8C6),
    softD: Color(0xFF604008),
  );
  static const _pink = (
    base: Color(0xFFDB6EA5),
    soft: Color(0xFFFFE1EF),
    softD: Color(0xFF612F48),
  );

  static const _map = {
    'green': _green,
    'sky': _sky,
    'violet': _violet,
    'coral': _coral,
    'amber': _amber,
    'pink': _pink,
  };

  /// Ordered list of selectable color keys (COLOR_CHOICES in data.jsx).
  static const choices = ['green', 'sky', 'violet', 'coral', 'amber', 'pink'];

  /// Accent base colors used by the appearance tweak picker (ACCENTS in app.jsx).
  static const accents = [
    Color(0xFF399D57), // green
    Color(0xFF259ED6), // sky
    Color(0xFF9065D0), // violet
    Color(0xFFE76250), // coral
    Color(0xFFDE9C31), // amber
    Color(0xFFDB6EA5), // pink
  ];

  static HabitColor of(String key, bool dark) {
    final c = _map[key] ?? _green;
    return HabitColor(c.base, dark ? c.softD : c.soft);
  }
}
