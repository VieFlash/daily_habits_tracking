import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/habit_palette.dart';
import '../providers/settings_provider.dart';
import '../widgets/buttons.dart';

class _Slide {
  const _Slide(this.icon, this.color, this.title, this.body);
  final String icon;
  final String color;
  final String title;
  final String body;
}

const _slides = [
  _Slide(
    'leaf',
    'green',
    'Gieo một thói quen,\ngặt cả cuộc đời',
    'Sprout giúp bạn xây dựng thói quen tốt mỗi ngày — nhẹ nhàng, vui và bền vững.',
  ),
  _Slide(
    'fire',
    'coral',
    'Giữ chuỗi ngày,\nđốt cháy động lực',
    'Theo dõi streak, xem heatmap tiến bộ và đừng để ngọn lửa tắt.',
  ),
  _Slide(
    'trophy',
    'amber',
    'Lên level,\nmở khóa huy hiệu',
    'Mỗi lần check-in là một điểm kinh nghiệm. Cùng bạn bè tham gia thử thách nhé!',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;

  void _finish() {
    ref.read(settingsProvider.notifier).completeOnboarding();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = _slides[_step];
    final hc = HabitPalette.of(s.color, c.isDark);
    final last = _step == _slides.length - 1;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Bỏ qua',
                    style: TextStyle(
                      color: c.textDim,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 168,
                          height: 168,
                          decoration: BoxDecoration(
                            color: hc.soft,
                            borderRadius: BorderRadius.circular(48),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            AppIcons.resolve(s.icon),
                            size: 84,
                            color: hc.base,
                          ),
                        ),
                        Positioned(
                          top: -10,
                          right: -6,
                          child: Icon(
                            AppIcons.resolve('sparkle'),
                            size: 34,
                            color: c.amber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      s.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        height: 1.18,
                        color: c.text,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      s.body,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.5,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: c.textDim,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 34),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _slides.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3.5),
                          height: 8,
                          width: i == _step ? 26 : 8,
                          decoration: BoxDecoration(
                            color: i == _step ? c.primary : c.borderStrong,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  AppButton(
                    label: last ? 'Bắt đầu ngay' : 'Tiếp tục',
                    icon: last ? 'sparkle' : null,
                    full: true,
                    size: AppButtonSize.lg,
                    onPressed: () {
                      if (last) {
                        _finish();
                      } else {
                        setState(() => _step++);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
