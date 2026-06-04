import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, soft, ghost, outline }

enum AppButtonSize { sm, md, lg }

/// Pill button with the four design variants (Button in components.jsx).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.full = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final String? icon;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pad = switch (size) {
      AppButtonSize.lg => const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
      AppButtonSize.sm => const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      AppButtonSize.md => const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
    };
    final fs = switch (size) {
      AppButtonSize.lg => 16.5,
      AppButtonSize.sm => 13.5,
      AppButtonSize.md => 15.0,
    };

    late final Color bg;
    late final Color fg;
    Border? brd;
    List<BoxShadow>? shadow;
    switch (variant) {
      case AppButtonVariant.primary:
        bg = c.primary;
        fg = c.onPrimary;
        shadow = [
          BoxShadow(
            color: c.primary.withValues(alpha: 0.45),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ];
      case AppButtonVariant.soft:
        bg = c.primarySoft;
        fg = c.primary;
      case AppButtonVariant.ghost:
        bg = c.surface2;
        fg = c.text;
      case AppButtonVariant.outline:
        bg = Colors.transparent;
        fg = c.text;
        brd = Border.all(color: c.borderStrong, width: 1.5);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(99),
            border: brd,
            boxShadow: shadow,
          ),
          child: Container(
            padding: pad,
            width: full ? double.infinity : null,
            child: Row(
              mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(AppIcons.resolve(icon!), size: fs + 3, color: fg),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontSize: fs,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Round soft icon button (IconBtn in components.jsx).
class SoftIconButton extends StatelessWidget {
  const SoftIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.badge = false,
    this.size = 40,
    this.active = false,
  });

  final String icon;
  final VoidCallback? onTap;
  final bool badge;
  final double size;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? c.primarySoft : c.surface2,
            ),
            alignment: Alignment.center,
            child: Icon(
              AppIcons.resolve(icon),
              size: 20,
              color: active ? c.primary : c.text,
            ),
          ),
          if (badge)
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.coral,
                  border: Border.all(color: c.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Toggle switch (Switch in screens-create.jsx).
class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? c.primary : c.surface3,
          borderRadius: BorderRadius.circular(99),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1)),
            ],
          ),
        ),
      ),
    );
  }
}
