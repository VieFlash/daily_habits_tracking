import 'package:flutter/foundation.dart';

/// Appearance + layout preferences. Pure domain entity (no framework types):
/// the accent is stored as an index and resolved to a [Color] in the
/// presentation layer.
@immutable
class AppSettings {
  const AppSettings({
    required this.dark,
    required this.accentIndex,
    required this.corner,
    required this.layout,
    required this.onboarded,
  });

  final bool dark;
  final int accentIndex;
  final String corner; // rounded | soft | sharp
  final String layout; // card | list | grid
  final bool onboarded;

  static const initial = AppSettings(
    dark: false,
    accentIndex: 0,
    corner: 'rounded',
    layout: 'card',
    onboarded: false,
  );

  AppSettings copyWith({
    bool? dark,
    int? accentIndex,
    String? corner,
    String? layout,
    bool? onboarded,
  }) => AppSettings(
    dark: dark ?? this.dark,
    accentIndex: accentIndex ?? this.accentIndex,
    corner: corner ?? this.corner,
    layout: layout ?? this.layout,
    onboarded: onboarded ?? this.onboarded,
  );
}
