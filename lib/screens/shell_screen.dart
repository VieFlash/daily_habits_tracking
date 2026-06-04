import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';

/// Scaffold hosting the four primary tabs and the central add FAB.
/// Floating pill nav bar with a docked center FAB (BottomNav in components.jsx,
/// restyled as a floating bar).
class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: 'home', label: 'Hôm nay'),
    (icon: 'chart', label: 'Tiến độ'),
    (icon: 'trophy', label: 'Thử thách'),
    (icon: 'pencil', label: 'Nhật ký'),
  ];

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  bool _fabDown = false;

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.bg,
      body: Stack(
        children: [
          // Tab content (extends behind the floating bar).
          Positioned.fill(child: widget.navigationShell),

          // Bottom fade so content scrolls out gracefully behind the bar.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 92,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      c.bg,
                      c.bg.withValues(alpha: 0),
                      c.bg.withValues(alpha: 0),
                    ],
                    stops: const [0.62, 0.62, 1],
                  ),
                ),
              ),
            ),
          ),

          // Floating nav bar.
          Positioned(
            left: 14,
            right: 14,
            bottom: 22,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: c.border),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0E372E).withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _tabItem(0),
                  _tabItem(1),
                  const SizedBox(width: 64),
                  _tabItem(2),
                  _tabItem(3),
                ],
              ),
            ),
          ),

          // Center docked FAB.
          Positioned(
            left: 0,
            right: 0,
            bottom: 46,
            child: Center(
              child: GestureDetector(
                onTap: () => context.push('/create'),
                onTapDown: (_) => setState(() => _fabDown = true),
                onTapUp: (_) => setState(() => _fabDown = false),
                onTapCancel: () => setState(() => _fabDown = false),
                child: AnimatedRotation(
                  turns: _fabDown ? 0.25 : 0,
                  duration: const Duration(milliseconds: 140),
                  child: AnimatedScale(
                    scale: _fabDown ? 0.92 : 1,
                    duration: const Duration(milliseconds: 140),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: c.primary,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: c.bg, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: c.primary.withValues(alpha: 0.55),
                            blurRadius: 26,
                            offset: const Offset(0, 12),
                            spreadRadius: -6,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.add_rounded,
                        size: 28,
                        color: c.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabItem(int i) {
    final c = context.colors;
    final active = widget.navigationShell.currentIndex == i;
    final tab = ShellScreen._tabs[i];
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _goBranch(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.resolve(tab.icon),
              size: 24,
              color: active ? c.primaryPress : c.textFaint,
            ),
            const SizedBox(height: 3),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: active ? c.primaryPress : c.textFaint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
