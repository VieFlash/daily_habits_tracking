import '../../domain/entities/challenge.dart';

/// The community-challenge catalog. This is app-provided *content* (like the
/// badge definitions), not user data — without a backend it cannot be "live".
/// Every challenge starts un-joined; the user's join/progress state is persisted
/// separately and overlaid by the repository.
const kChallengeCatalog = <Challenge>[
  Challenge(
    id: 'c1',
    name: '21 ngày uống đủ nước',
    icon: 'water',
    color: 'sky',
    joined: false,
    total: 21,
    current: 0,
    people: 1284,
    days: '21 ngày',
  ),
  Challenge(
    id: 'c2',
    name: 'Tháng không đường',
    icon: 'apple',
    color: 'green',
    joined: false,
    total: 30,
    current: 0,
    people: 642,
    days: '30 ngày',
  ),
  Challenge(
    id: 'c3',
    name: 'Thử thách đọc 30 ngày',
    icon: 'book',
    color: 'amber',
    joined: false,
    total: 30,
    current: 0,
    people: 3120,
    days: '30 ngày',
  ),
  Challenge(
    id: 'c4',
    name: '7 ngày dậy sớm',
    icon: 'sun',
    color: 'coral',
    joined: false,
    total: 7,
    current: 0,
    people: 890,
    days: '7 ngày',
  ),
  Challenge(
    id: 'c5',
    name: 'Chạy 50km / tháng',
    icon: 'run',
    color: 'violet',
    joined: false,
    total: 50,
    current: 0,
    people: 410,
    days: '30 ngày',
  ),
];
