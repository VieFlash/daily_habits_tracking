import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/habit_palette.dart';
import '../data/models/habit.dart';
import '../data/seed_data.dart';
import '../providers/habits_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/buttons.dart';
import '../widgets/flash.dart';
import '../widgets/habit_tile.dart';
import '../widgets/misc.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  const CreateHabitScreen({super.key, this.editingId});

  /// When set, the screen edits an existing habit instead of creating one.
  final String? editingId;

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  late final TextEditingController _name;
  late final TextEditingController _unit;
  String _icon = 'water';
  String _color = 'green';
  String _freq = 'daily';
  List<int> _days = [0, 1, 2, 3, 4, 5, 6];
  int _target = 1;
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  bool _reminder = true;

  Habit? _editing;

  @override
  void initState() {
    super.initState();
    final editing = widget.editingId == null
        ? null
        : ref.read(habitsProvider.notifier).byId(widget.editingId!);
    _editing = editing;
    _name = TextEditingController(text: editing?.name ?? '');
    _unit = TextEditingController(text: editing?.unit ?? '');
    if (editing != null) {
      _icon = editing.icon;
      _color = editing.color;
      _target = editing.target;
      _reminder = editing.reminder;
      _time = _parseTime(editing.time);
    }
  }

  TimeOfDay _parseTime(String raw) {
    final parts = raw.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h != null && m != null) return TimeOfDay(hour: h, minute: m);
    }
    return const TimeOfDay(hour: 8, minute: 0);
  }

  String get _timeText =>
      '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _name.dispose();
    _unit.dispose();
    super.dispose();
  }

  void _toggleDay(int d) {
    setState(() {
      if (_days.contains(d)) {
        _days = _days.where((x) => x != d).toList();
      } else {
        _days = [..._days, d];
      }
    });
  }

  void _save() {
    final name = _name.text.trim().isEmpty ? 'Thói quen mới' : _name.text.trim();
    final freqText =
        _freq == 'daily' ? 'Hằng ngày' : '${_days.length} lần / tuần';
    final notifier = ref.read(habitsProvider.notifier);
    if (_editing != null) {
      notifier.update(
        _editing!.copyWith(
          name: name,
          icon: _icon,
          color: _color,
          target: _target,
          unit: _unit.text.trim(),
          time: _reminder ? _timeText : '—',
          reminder: _reminder,
          freq: freqText,
        ),
      );
      context.pop();
      showFlash(context, 'Đã lưu thay đổi ✏️', icon: 'check');
    } else {
      notifier.add(
        Habit(
          id: 'h${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          icon: _icon,
          color: _color,
          cat: 'Mới',
          goalText: freqText,
          freq: freqText,
          time: _reminder ? _timeText : '—',
          unit: _unit.text.trim(),
          target: _target,
          progress: 0,
          streak: 0,
          best: 0,
          done: false,
          reminder: _reminder,
          weekDone: const [0, 0, 0, 0, 0, 0, 0],
          rate: 0,
        ),
      );
      context.pop();
      showFlash(context, 'Đã tạo thói quen mới 🌱', icon: 'check');
    }
  }

  void _delete() {
    if (_editing != null) {
      ref.read(habitsProvider.notifier).remove(_editing!.id);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dark = c.isDark;
    final hc = HabitPalette.of(_color, dark);
    final editing = _editing != null;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              title: editing ? 'Sửa thói quen' : 'Thói quen mới',
              onBack: () => context.pop(),
              trailing: editing
                  ? SoftIconButton(icon: 'trash', onTap: _delete)
                  : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  // Live preview
                  AppCard(
                    color: hc.soft,
                    border: const Border.fromBorderSide(BorderSide.none),
                    child: Row(
                      children: [
                        HabitTile(
                          icon: _icon,
                          color: _color,
                          dark: dark,
                          size: 54,
                          radius: 18,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _name,
                                builder: (context, value, _) => Text(
                                  value.text.isEmpty
                                      ? 'Tên thói quen'
                                      : value.text,
                                  style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w800,
                                    color: c.text,
                                  ),
                                ),
                              ),
                              Text(
                                '${_freq == 'daily' ? 'Hằng ngày' : '${_days.length} ngày / tuần'}'
                                '${_target > 1 ? ' · $_target ${_unit.text.isEmpty ? 'lần' : _unit.text}' : ''}',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: hc.base,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  _label(context, 'TÊN THÓI QUEN'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _name,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: c.text,
                    ),
                    decoration: _inputDecoration(
                      context,
                      'vd: Uống nước, Đọc sách...',
                    ),
                  ),
                  const SizedBox(height: 18),

                  _label(context, 'CHỌN ICON'),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 6,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final ic in SeedData.iconChoices)
                        GestureDetector(
                          onTap: () => setState(() => _icon = ic),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _icon == ic ? hc.soft : c.surface,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: _icon == ic ? hc.base : c.border,
                                width: _icon == ic ? 2 : 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              AppIcons.resolve(ic),
                              size: 22,
                              color: _icon == ic ? hc.base : c.textDim,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  _label(context, 'MÀU SẮC'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final ck in HabitPalette.choices)
                        _ColorDot(
                          colorKey: ck,
                          active: _color == ck,
                          dark: dark,
                          onTap: () => setState(() => _color = ck),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _label(context, 'TẦN SUẤT'),
                  const SizedBox(height: 8),
                  Segmented(
                    value: _freq,
                    onChanged: (v) => setState(() => _freq = v),
                    options: const [
                      SegmentOption('daily', 'Hằng ngày'),
                      SegmentOption('weekly', 'Vài ngày / tuần'),
                    ],
                  ),
                  if (_freq == 'weekly') ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        for (var i = 0; i < SeedData.weekLabels.length; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleDay(i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                decoration: BoxDecoration(
                                  color: _days.contains(i)
                                      ? c.primary
                                      : c.surface2,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  SeedData.weekLabels[i],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: _days.contains(i)
                                        ? c.onPrimary
                                        : c.textDim,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 18),

                  _label(context, 'MỤC TIÊU MỖI NGÀY'),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        _stepBtn(
                          context,
                          '−',
                          c.surface2,
                          c.text,
                          () => setState(
                            () => _target = (_target - 1).clamp(1, 9999),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_target',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: c.text,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: _unit,
                                  textAlign: TextAlign.center,
                                  onChanged: (_) => setState(() {}),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: c.text,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'đơn vị',
                                    hintStyle: TextStyle(color: c.textFaint),
                                    filled: true,
                                    fillColor: c.surface2,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: c.border),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: c.border),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _stepBtn(
                          context,
                          '+',
                          hc.base,
                          Colors.white,
                          () => setState(() => _target++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  _label(context, 'NHẮC NHỞ'),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: c.primarySoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  AppIcons.resolve('bell'),
                                  size: 20,
                                  color: c.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bật nhắc nhở',
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        color: c.text,
                                      ),
                                    ),
                                    Text(
                                      'Thông báo hằng ngày',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: c.textDim,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppSwitch(
                                value: _reminder,
                                onChanged: (v) =>
                                    setState(() => _reminder = v),
                              ),
                            ],
                          ),
                        ),
                        if (_reminder)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: c.border)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: c.surface2,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    AppIcons.resolve('clock'),
                                    size: 20,
                                    color: c.textDim,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Thời gian',
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                      color: c.text,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: _time,
                                    );
                                    if (picked != null) {
                                      setState(() => _time = picked);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: c.surface2,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: c.border, width: 1.5),
                                    ),
                                    child: Text(
                                      _timeText,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: c.text,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(top: BorderSide(color: c.border)),
              ),
              child: AppButton(
                label: editing ? 'Lưu thay đổi' : 'Tạo thói quen',
                icon: 'check',
                full: true,
                size: AppButtonSize.lg,
                onPressed: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(left: 2),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: context.colors.textDim,
      ),
    ),
  );

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    final c = context.colors;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: c.textFaint, fontWeight: FontWeight.w600),
      filled: true,
      fillColor: c.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }

  Widget _stepBtn(
    BuildContext context,
    String label,
    Color bg,
    Color fg,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: fg,
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.colorKey,
    required this.active,
    required this.dark,
    required this.onTap,
  });

  final String colorKey;
  final bool active;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hc = HabitPalette.of(colorKey, dark);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: active ? c.text : Colors.transparent,
            width: 3,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(shape: BoxShape.circle, color: hc.base),
        ),
      ),
    );
  }
}
