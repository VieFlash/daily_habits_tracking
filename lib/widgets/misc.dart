import 'package:flutter/material.dart';

import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';

/// Pill filter chip (Chip in components.jsx).
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.active,
    this.onTap,
    this.color,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? (color ?? c.primary) : c.surface2,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: active ? c.onPrimary : c.textDim,
          ),
        ),
      ),
    );
  }
}

class SegmentOption {
  const SegmentOption(this.value, this.label);
  final String value;
  final String label;
}

/// Segmented control (Segmented in components.jsx).
class Segmented extends StatelessWidget {
  const Segmented({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<SegmentOption> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surface2,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: [
          for (final o in options)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(o.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  decoration: BoxDecoration(
                    color: value == o.value ? c.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: value == o.value
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: c.isDark ? 0.3 : 0.06,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    o.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: value == o.value ? c.text : c.textDim,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Section heading with optional trailing widget (SectionLabel in components.jsx).
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 18, 2, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: c.text,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// In-app top bar (AppBar in components.jsx). [large] renders the oversized
/// title used by the tab screens.
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
    this.large = false,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: large
          ? const EdgeInsets.fromLTRB(20, 8, 20, 6)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (onBack != null) ...[
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.surface2,
                    ),
                    alignment: Alignment.center,
                    child: Icon(AppIcons.resolve('arrowL'), size: 20, color: c.text),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: large
                    ? const SizedBox(height: 44)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: c.text,
                            ),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: c.textDim,
                              ),
                            ),
                        ],
                      ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (large) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: c.text,
                height: 1.1,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: c.textDim,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
