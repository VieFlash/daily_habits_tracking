import 'package:flutter/material.dart';

/// Maps the design's named icon set (icons.jsx) to the closest Material icons.
/// Using the Material set keeps the conversion lightweight while preserving the
/// meaning of every icon referenced by the original screens.
class AppIcons {
  AppIcons._();

  static const _map = <String, IconData>{
    'home': Icons.home_outlined,
    'calendar': Icons.calendar_today_outlined,
    'chart': Icons.bar_chart_rounded,
    'trophy': Icons.emoji_events_outlined,
    'flag': Icons.flag_outlined,
    'plus': Icons.add_rounded,
    'check': Icons.check_rounded,
    'fire': Icons.local_fire_department_rounded,
    'bell': Icons.notifications_outlined,
    'settings': Icons.settings_outlined,
    'user': Icons.person_outline_rounded,
    'water': Icons.water_drop_outlined,
    'book': Icons.menu_book_outlined,
    'run': Icons.directions_run_rounded,
    'meditate': Icons.self_improvement_rounded,
    'moon': Icons.dark_mode_outlined,
    'sun': Icons.wb_sunny_outlined,
    'heart': Icons.favorite_border_rounded,
    'star': Icons.star_border_rounded,
    'target': Icons.track_changes_rounded,
    'edit': Icons.edit_outlined,
    'trash': Icons.delete_outline_rounded,
    'chevR': Icons.chevron_right_rounded,
    'chevL': Icons.chevron_left_rounded,
    'chevD': Icons.keyboard_arrow_down_rounded,
    'chevU': Icons.keyboard_arrow_up_rounded,
    'close': Icons.close_rounded,
    'arrowL': Icons.arrow_back_rounded,
    'arrowR': Icons.arrow_forward_rounded,
    'sparkle': Icons.auto_awesome_rounded,
    'dumbbell': Icons.fitness_center_rounded,
    'clock': Icons.access_time_rounded,
    'pencil': Icons.edit_note_rounded,
    'bulb': Icons.lightbulb_outline_rounded,
    'leaf': Icons.eco_outlined,
    'music': Icons.music_note_outlined,
    'apple': Icons.local_dining_outlined,
    'bed': Icons.bed_outlined,
    'pen': Icons.create_outlined,
    'mountain': Icons.terrain_rounded,
    'smile': Icons.sentiment_satisfied_alt_rounded,
    'meh': Icons.sentiment_neutral_rounded,
    'frown': Icons.sentiment_dissatisfied_rounded,
    'share': Icons.ios_share_rounded,
    'lock': Icons.lock_outline_rounded,
    'globe': Icons.public_rounded,
    'palette': Icons.palette_outlined,
    'download': Icons.file_download_outlined,
    'logout': Icons.logout_rounded,
    'zap': Icons.bolt_rounded,
    'gift': Icons.card_giftcard_rounded,
    'shield': Icons.verified_user_outlined,
    'camera': Icons.photo_camera_outlined,
    'more': Icons.more_horiz_rounded,
    'grid': Icons.grid_view_rounded,
    'list': Icons.view_list_rounded,
    'filter': Icons.filter_alt_outlined,
    'search': Icons.search_rounded,
    'coffee': Icons.coffee_outlined,
  };

  static IconData resolve(String name) => _map[name] ?? Icons.help_outline;
}

/// Renders a named icon. Mirrors the `<Icon>` component from the design.
class AppIcon extends StatelessWidget {
  const AppIcon(this.name, {super.key, this.size = 24, this.color});

  final String name;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(AppIcons.resolve(name), size: size, color: color);
  }
}
