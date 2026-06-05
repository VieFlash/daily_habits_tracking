import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/buttons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/flash.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/misc.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:daily_habits_tracking/core/theme/habit_palette.dart';
import 'package:daily_habits_tracking/features/journal/domain/entities/journal_entry.dart';
import 'package:daily_habits_tracking/features/journal/domain/entities/mood.dart';
import 'package:daily_habits_tracking/features/journal/presentation/providers/journal_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              for (final m in Mood.all) ...[
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
