import '../../domain/entities/badge.dart';
import '../../domain/entities/user_profile.dart';

/// Reference user + badges, ported from data.jsx.
const kUserSeed = UserProfile(
  name: 'Minh Anh',
  handle: '@minhanh',
  level: 12,
  xp: 740,
  xpMax: 1000,
  totalDone: 1284,
  longestStreak: 41,
  badges: 4,
  joinedDays: 184,
);

const kBadgeSeed = <Badge>[
  Badge(
    id: 'b1',
    name: 'Tia lửa đầu tiên',
    icon: 'zap',
    got: true,
    desc: 'Hoàn thành thói quen đầu tiên',
    color: 'amber',
  ),
  Badge(
    id: 'b2',
    name: 'Chuỗi 7 ngày',
    icon: 'fire',
    got: true,
    desc: 'Giữ streak 7 ngày liên tục',
    color: 'coral',
  ),
  Badge(
    id: 'b3',
    name: 'Chuỗi 30 ngày',
    icon: 'flag',
    got: true,
    desc: 'Giữ streak 30 ngày',
    color: 'green',
  ),
  Badge(
    id: 'b4',
    name: 'Người dậy sớm',
    icon: 'sun',
    got: true,
    desc: 'Check-in trước 7h sáng × 10',
    color: 'amber',
  ),
  Badge(
    id: 'b5',
    name: 'Tuần hoàn hảo',
    icon: 'star',
    got: false,
    desc: 'Hoàn thành 100% trong 1 tuần',
    color: 'violet',
  ),
  Badge(
    id: 'b6',
    name: 'Bậc thầy thiền',
    icon: 'leaf',
    got: false,
    desc: 'Thiền tổng 500 phút',
    color: 'green',
  ),
  Badge(
    id: 'b7',
    name: 'Mọt sách',
    icon: 'book',
    got: false,
    desc: 'Đọc 1000 trang',
    color: 'amber',
  ),
  Badge(
    id: 'b8',
    name: 'Huyền thoại',
    icon: 'trophy',
    got: false,
    desc: 'Đạt level 20',
    color: 'coral',
  ),
];
