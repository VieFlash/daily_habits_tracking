import 'package:flutter/foundation.dart';

/// An achievement badge (BADGES in data.jsx).
@immutable
class Badge {
  const Badge({
    required this.id,
    required this.name,
    required this.icon,
    required this.got,
    required this.desc,
    required this.color,
  });

  final String id;
  final String name;
  final String icon;
  final bool got;
  final String desc;
  final String color;
}
