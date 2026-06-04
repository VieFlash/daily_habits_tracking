import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/misc.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:daily_habits_tracking/core/theme/habit_palette.dart';
import 'package:flutter/material.dart';

/// Notifications list sheet (NotificationsSheet in screens-extra.jsx).
/// Static demo content — surfaced from multiple screens, so it lives in core.
void showNotificationsSheet(BuildContext context) {
  const items = [
    (
      icon: 'water',
      color: 'sky',
      title: 'Đến giờ uống nước 💧',
      time: '5 phút trước',
      sub: 'Bạn còn 2 ly nữa là đạt mục tiêu',
    ),
    (
      icon: 'fire',
      color: 'coral',
      title: 'Chuỗi 31 ngày!',
      time: '2 giờ trước',
      sub: 'Đọc sách — chuỗi dài nhất của bạn 🎉',
    ),
    (
      icon: 'trophy',
      color: 'amber',
      title: 'Mở khóa huy hiệu mới',
      time: 'Hôm qua',
      sub: '"Người dậy sớm" đã được mở',
    ),
    (
      icon: 'meditate',
      color: 'violet',
      title: 'Nhắc nhở thiền',
      time: 'Hôm qua',
      sub: 'Buổi thiền 10 phút buổi sáng',
    ),
  ];
  showAppSheet(
    context,
    builder: (context) {
      final c = context.colors;
      final dark = c.isDark;
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thông báo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: c.text,
                  ),
                ),
                Text(
                  'Đánh dấu đã đọc',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: c.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < items.length; i++)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: i < items.length - 1
                      ? Border(bottom: BorderSide(color: c.border))
                      : null,
                ),
                child: Builder(
                  builder: (context) {
                    final it = items[i];
                    final hc = HabitPalette.of(it.color, dark);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: hc.soft,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            AppIcons.resolve(it.icon),
                            size: 22,
                            color: hc.base,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      it.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: c.text,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    it.time,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: c.textFaint,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                it.sub,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: c.textDim,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      );
    },
  );
}
