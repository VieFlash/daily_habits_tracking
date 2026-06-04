import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_radii.dart';

/// Builds a [ThemeData] from the user's appearance settings. The bespoke
/// [AppColors] / [AppRadii] tokens are attached as theme extensions so the whole
/// widget tree can read them.
ThemeData buildAppTheme({
  required bool dark,
  required Color accent,
  required String cornerKey,
}) {
  final colors = AppColors.resolve(dark: dark, accent: accent);
  final radii = AppRadii.fromKey(cornerKey);

  final base = dark ? ThemeData.dark() : ThemeData.light();
  final textTheme = GoogleFonts.nunitoTextTheme(
    base.textTheme,
  ).apply(bodyColor: colors.text, displayColor: colors.text);

  return base.copyWith(
    scaffoldBackgroundColor: colors.bg,
    canvasColor: colors.bg,
    primaryColor: colors.primary,
    textTheme: textTheme,
    colorScheme: base.colorScheme.copyWith(
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      surface: colors.surface,
      onSurface: colors.text,
    ),
    splashFactory: InkRipple.splashFactory,
    extensions: [colors, radii],
  );
}
