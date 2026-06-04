import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Shows the small pill toast used across the app (Toast + flash() in app.jsx).
void showFlash(BuildContext context, String message, {String? icon}) {
  final c = context.colors;
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(milliseconds: 1800),
      margin: const EdgeInsets.only(bottom: 90, left: 40, right: 40),
      padding: EdgeInsets.zero,
      content: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          decoration: BoxDecoration(
            color: c.text,
            borderRadius: BorderRadius.circular(99),
            boxShadow: const [
              BoxShadow(color: Colors.black38, blurRadius: 30, offset: Offset(0, 8)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(AppIcons.resolve(icon), size: 17, color: c.bg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(
                    color: c.bg,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
