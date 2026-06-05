import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/app_card.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/buttons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/misc.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:daily_habits_tracking/core/util/number_format.dart';
import 'package:daily_habits_tracking/features/profile/presentation/providers/profile_providers.dart';
import 'package:daily_habits_tracking/features/settings/presentation/providers/settings_providers.dart';
import 'package:daily_habits_tracking/features/settings/presentation/widgets/appearance_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final user = ref.watch(userProfileProvider);
    final dark = ref.watch(settingsProvider.select((s) => s.dark));
    final suggestionsHidden =
        ref.watch(settingsProvider.select((s) => s.suggestionsHidden));
    final stats = [
      (formatThousands(user.totalDone), 'Hoàn thành'),
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
                        _divider(c),
                        _Row(
                          icon: 'sparkle',
                          label: 'Gợi ý thói quen',
                          color: c.primary,
                          trailing: AppSwitch(
                            value: !suggestionsHidden,
                            onChanged: (v) => ref
                                .read(settingsProvider.notifier)
                                .setSuggestionsHidden(!v),
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
                          onTap: () => showAppearanceSheet(context),
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
