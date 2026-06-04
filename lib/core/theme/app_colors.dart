import 'package:flutter/material.dart';

/// Semantic color tokens for the app, mirroring the CSS variables used in the
/// original Sprout design (see handoff/tokens.hex.json). Exposed as a
/// [ThemeExtension] so widgets can read them via
/// `Theme.of(context).extension<AppColors>()!`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryPress,
    required this.onPrimary,
    required this.primarySoft,
    required this.primarySoft2,
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.surface3,
    required this.text,
    required this.textDim,
    required this.textFaint,
    required this.border,
    required this.borderStrong,
    required this.amber,
    required this.coral,
    required this.sky,
    required this.violet,
    required this.pink,
    required this.isDark,
  });

  final Color primary;
  final Color primaryPress;
  final Color onPrimary;
  final Color primarySoft;
  final Color primarySoft2;
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color surface3;
  final Color text;
  final Color textDim;
  final Color textFaint;
  final Color border;
  final Color borderStrong;
  final Color amber;
  final Color coral;
  final Color sky;
  final Color violet;
  final Color pink;
  final bool isDark;

  /// Base light palette (tokens.hex.json -> light).
  static const _light = AppColors(
    primary: Color(0xFF399D57),
    primaryPress: Color(0xFF1C8742),
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0xFFD1F2D7),
    primarySoft2: Color(0xFFB7E5C0),
    bg: Color(0xFFF2F9F3),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFECF4EE),
    surface3: Color(0xFFE1EBE3),
    text: Color(0xFF18281E),
    textDim: Color(0xFF606D64),
    textFaint: Color(0xFF919B94),
    border: Color(0xFFDAE4DD),
    borderStrong: Color(0xFFC4D2C8),
    amber: Color(0xFFE8AA4E),
    coral: Color(0xFFEA6C5A),
    sky: Color(0xFF4EA8E1),
    violet: Color(0xFF956ED2),
    pink: Color(0xFFE57DB1),
    isDark: false,
  );

  /// Base dark palette (tokens.hex.json -> dark).
  static const _dark = AppColors(
    primary: Color(0xFF5BCC80),
    primaryPress: Color(0xFF46B86E),
    onPrimary: Color(0xFF051B0E),
    primarySoft: Color(0xFF183B23),
    primarySoft2: Color(0xFF1A4E2C),
    bg: Color(0xFF101511),
    surface: Color(0xFF181F1A),
    surface2: Color(0xFF202923),
    surface3: Color(0xFF29332C),
    text: Color(0xFFE9F1EC),
    textDim: Color(0xFFA7B1AA),
    textFaint: Color(0xFF7A837C),
    border: Color(0xFF2B332D),
    borderStrong: Color(0xFF3A463E),
    amber: Color(0xFFE8AA4E),
    coral: Color(0xFFEA6C5A),
    sky: Color(0xFF4EA8E1),
    violet: Color(0xFF956ED2),
    pink: Color(0xFFE57DB1),
    isDark: true,
  );

  /// Builds the active palette for a given [dark] mode and a chosen [accent].
  ///
  /// The original applies the accent as an override on top of the base theme:
  /// `--primary` becomes the accent and the soft variants are mixed against the
  /// current surface, mirroring the `themeStyle` block in app.jsx.
  factory AppColors.resolve({required bool dark, required Color accent}) {
    final base = dark ? _dark : _light;
    return base.copyWith(
      primary: accent,
      primaryPress: Color.lerp(accent, Colors.black, 0.14)!,
      primarySoft: Color.lerp(base.surface, accent, 0.14)!,
      primarySoft2: Color.lerp(base.surface, accent, 0.26)!,
    );
  }

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryPress,
    Color? onPrimary,
    Color? primarySoft,
    Color? primarySoft2,
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? surface3,
    Color? text,
    Color? textDim,
    Color? textFaint,
    Color? border,
    Color? borderStrong,
    Color? amber,
    Color? coral,
    Color? sky,
    Color? violet,
    Color? pink,
    bool? isDark,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryPress: primaryPress ?? this.primaryPress,
      onPrimary: onPrimary ?? this.onPrimary,
      primarySoft: primarySoft ?? this.primarySoft,
      primarySoft2: primarySoft2 ?? this.primarySoft2,
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      text: text ?? this.text,
      textDim: textDim ?? this.textDim,
      textFaint: textFaint ?? this.textFaint,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      amber: amber ?? this.amber,
      coral: coral ?? this.coral,
      sky: sky ?? this.sky,
      violet: violet ?? this.violet,
      pink: pink ?? this.pink,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryPress: Color.lerp(primaryPress, other.primaryPress, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      primarySoft2: Color.lerp(primarySoft2, other.primarySoft2, t)!,
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surface3: Color.lerp(surface3, other.surface3, t)!,
      text: Color.lerp(text, other.text, t)!,
      textDim: Color.lerp(textDim, other.textDim, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      coral: Color.lerp(coral, other.coral, t)!,
      sky: Color.lerp(sky, other.sky, t)!,
      violet: Color.lerp(violet, other.violet, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

/// Convenience accessor: `context.colors`.
extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
