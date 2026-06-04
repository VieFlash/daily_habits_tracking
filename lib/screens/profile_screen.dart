import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/habit_palette.dart';
import '../data/seed_data.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/buttons.dart';
import '../widgets/misc.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static String _format(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final user = SeedData.user;
    final dark = ref.watch(settingsProvider.select((s) => s.dark));
    final stats = [
      (_format(user.totalDone), 'Hoàn thành'),
      ('${user.longestStreak}', 'Chuỗi dài nhất'),
      ('${user.joinedDays}', 'Ngày đồng hành'),
    ];

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              title: 'Hồ sơ',
              onBack: () => context.pop(),
              trailing: SoftIconButton(icon: 'settings'),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  Column(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [c.primary, c.primarySoft2],
                          ),
                          border: Border.all(color: c.surface, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: dark ? 0.3 : 0.06,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          user.initials,
                          style: TextStyle(
                            color: c.onPrimary,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          color: c.text,
                        ),
                      ),
                      Text(
                        '${user.handle} · Cấp ${user.level}',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: c.textDim,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  AppCard(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                    child: Row(
                      children: [
                        for (var i = 0; i < stats.length; i++) ...[
                          if (i > 0)
                            Container(width: 1, height: 40, color: c.border),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  stats[i].$1,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: c.text,
                                  ),
                                ),
                                Text(
                                  stats[i].$2,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: c.textDim,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SectionLabel('Chung'),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _Row(
                          icon: 'trophy',
                          label: 'Thành tựu & huy hiệu',
                          color: c.amber,
                          onTap: () => context.push('/gamification'),
                        ),
                        _divider(c),
                        _Row(
                          icon: 'bell',
                          label: 'Nhắc nhở & thông báo',
                          color: c.coral,
                        ),
                        _divider(c),
                        _Row(
                          icon: 'moon',
                          label: 'Giao diện tối',
                          trailing: AppSwitch(
                            value: dark,
                            onChanged: (_) =>
                                ref.read(settingsProvider.notifier).toggleDark(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SectionLabel('Khác'),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _Row(icon: 'download', label: 'Sao lưu & đồng bộ', color: c.sky),
                        _divider(c),
                        _Row(
                          icon: 'palette',
                          label: 'Tùy chỉnh giao diện',
                          color: c.violet,
                          onTap: () => _showAppearanceSheet(context, ref),
                        ),
                        _divider(c),
                        _Row(icon: 'share', label: 'Chia sẻ với bạn bè', color: c.primary),
                        _divider(c),
                        _Row(icon: 'shield', label: 'Quyền riêng tư'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: _Row(
                      icon: 'logout',
                      label: 'Đăng xuất',
                      color: c.coral,
                      trailing: const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(AppColors c) =>
      Padding(padding: const EdgeInsets.only(left: 16), child: Container(height: 1, color: c.border));
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    this.color,
    this.trailing,
    this.onTap,
  });

  final String icon;
  final String label;
  final Color? color;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c.surface2,
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.center,
              child: Icon(AppIcons.resolve(icon), size: 19, color: color ?? c.text),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: c.text,
                ),
              ),
            ),
            trailing ??
                Icon(AppIcons.resolve('chevR'), size: 18, color: c.textFaint),
          ],
        ),
      ),
    );
  }
}

/// Appearance tweaks (the TweaksPanel from app.jsx): accent color + corner style.
void _showAppearanceSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.colors.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => const _AppearanceSheet(),
  );
}

class _AppearanceSheet extends ConsumerWidget {
  const _AppearanceSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 5,
                decoration: BoxDecoration(
                  color: c.borderStrong,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tùy chỉnh giao diện',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: c.text,
              ),
            ),
            const SectionLabel('Màu chủ đạo'),
            Row(
              children: [
                for (var i = 0; i < HabitPalette.accents.length; i++)
                  GestureDetector(
                    onTap: () => notifier.setAccentIndex(i),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: settings.accentIndex == i
                              ? c.text
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HabitPalette.accents[i],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SectionLabel('Bo góc'),
            Segmented(
              value: settings.corner,
              onChanged: notifier.setCorner,
              options: const [
                SegmentOption('rounded', 'Tròn'),
                SegmentOption('soft', 'Vừa'),
                SegmentOption('sharp', 'Sắc'),
              ],
            ),
            const SectionLabel('Bố cục thói quen'),
            Segmented(
              value: settings.layout,
              onChanged: notifier.setLayout,
              options: const [
                SegmentOption('card', 'Thẻ'),
                SegmentOption('list', 'Danh sách'),
                SegmentOption('grid', 'Lưới'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
