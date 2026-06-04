import 'package:flutter/material.dart';

/// Corner radius scale, switchable between `rounded` / `soft` / `sharp`
/// (CORNERS in app.jsx). Exposed as a [ThemeExtension].
@immutable
class AppRadii extends ThemeExtension<AppRadii> {
  const AppRadii({
    required this.card,
    required this.lg,
    required this.md,
    required this.sm,
  });

  final double card;
  final double lg;
  final double md;
  final double sm;

  static const rounded = AppRadii(card: 26, lg: 22, md: 16, sm: 12);
  static const soft = AppRadii(card: 18, lg: 15, md: 12, sm: 9);
  static const sharp = AppRadii(card: 10, lg: 9, md: 8, sm: 6);

  static const choices = ['rounded', 'soft', 'sharp'];

  static AppRadii fromKey(String key) => switch (key) {
    'soft' => soft,
    'sharp' => sharp,
    _ => rounded,
  };

  @override
  AppRadii copyWith({double? card, double? lg, double? md, double? sm}) =>
      AppRadii(
        card: card ?? this.card,
        lg: lg ?? this.lg,
        md: md ?? this.md,
        sm: sm ?? this.sm,
      );

  @override
  AppRadii lerp(ThemeExtension<AppRadii>? other, double t) {
    if (other is! AppRadii) return this;
    return AppRadii(
      card: lerpDouble(card, other.card, t),
      lg: lerpDouble(lg, other.lg, t),
      md: lerpDouble(md, other.md, t),
      sm: lerpDouble(sm, other.sm, t),
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

extension AppRadiiX on BuildContext {
  AppRadii get radii => Theme.of(this).extension<AppRadii>()!;
}
