import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/habit_palette.dart';
import '../data/models/journal_entry.dart';
import '../data/seed_data.dart';
import '../providers/journal_provider.dart';
import 'buttons.dart';
import 'flash.dart';

/// Shared rounded bottom-sheet wrapper with a grab handle (Sheet in components.jsx).
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  final c = context.colors;
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: c.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 38,
                  height: 5,
                  decoration: BoxDecoration(
                    color: c.borderStrong,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              Flexible(child: builder(context)),
            ],
          ),
        ),
      );
    },
  );
}

/// Notifications list sheet (NotificationsSheet in screens-extra.jsx).
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
            for (var i = 0; i < items.length; i++) ...[
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
          ],
        ),
      );
    },
  );
}

/// Add-journal sheet (AddJournalSheet in screens-extra.jsx).
void showAddJournalSheet(BuildContext context, WidgetRef ref) {
  showAppSheet(
    context,
    builder: (context) => _AddJournalSheet(ref: ref),
  );
}

class _AddJournalSheet extends StatefulWidget {
  const _AddJournalSheet({required this.ref});
  final WidgetRef ref;

  @override
  State<_AddJournalSheet> createState() => _AddJournalSheetState();
}

class _AddJournalSheetState extends State<_AddJournalSheet> {
  String _mood = 'great';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    widget.ref.read(journalProvider.notifier).add(
          JournalEntry(
            id: 'j${DateTime.now().millisecondsSinceEpoch}',
            date: 'Hôm nay',
            mood: _mood,
            text: _controller.text.trim().isEmpty
                ? '(Không có ghi chú)'
                : _controller.text.trim(),
            habits: const [],
          ),
        );
    Navigator.of(context).pop();
    showFlash(context, 'Đã lưu nhật ký ✍️', icon: 'check');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dark = c.isDark;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhật ký hôm nay',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: c.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hôm nay bạn cảm thấy thế nào?',
            style: TextStyle(
              fontSize: 13,
              color: c.textDim,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              for (final m in SeedData.moods) ...[
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final hc = HabitPalette.of(m.color, dark);
                      final on = _mood == m.key;
                      return GestureDetector(
                        onTap: () => setState(() => _mood = m.key),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: on ? hc.soft : c.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: on ? hc.base : c.border,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                AppIcons.resolve(m.icon),
                                size: 28,
                                color: on ? hc.base : c.textFaint,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                m.label,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: on ? hc.base : c.textDim,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            maxLines: 4,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: c.text,
            ),
            decoration: InputDecoration(
              hintText: 'Viết về ngày hôm nay của bạn...',
              hintStyle: TextStyle(color: c.textFaint),
              filled: true,
              fillColor: c.surface2,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: c.borderStrong, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: c.borderStrong, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: c.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Lưu nhật ký',
            icon: 'check',
            full: true,
            size: AppButtonSize.lg,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
