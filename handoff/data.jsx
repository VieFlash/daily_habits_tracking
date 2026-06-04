// data.jsx — mock data for the habit tracker
// Habit category accent colors (work in light + dark)
const HABIT_COLORS = {
  green:  { base: 'oklch(0.62 0.14 150)', soft: 'oklch(0.93 0.05 150)', softD: 'oklch(0.36 0.07 150)' },
  sky:    { base: 'oklch(0.66 0.13 235)', soft: 'oklch(0.93 0.04 235)', softD: 'oklch(0.36 0.07 235)' },
  violet: { base: 'oklch(0.6 0.16 300)',  soft: 'oklch(0.93 0.04 300)', softD: 'oklch(0.36 0.08 300)' },
  coral:  { base: 'oklch(0.66 0.17 30)',  soft: 'oklch(0.93 0.05 35)',  softD: 'oklch(0.38 0.09 30)' },
  amber:  { base: 'oklch(0.74 0.14 75)',  soft: 'oklch(0.94 0.05 80)',  softD: 'oklch(0.4 0.08 75)' },
  pink:   { base: 'oklch(0.68 0.15 350)', soft: 'oklch(0.94 0.04 350)', softD: 'oklch(0.38 0.08 350)' },
};
function colorOf(key, dark) {
  const c = HABIT_COLORS[key] || HABIT_COLORS.green;
  return { base: c.base, soft: dark ? c.softD : c.soft };
}

// Seeded pseudo-random for a stable heatmap
function seeded(n) { let x = Math.sin(n) * 10000; return x - Math.floor(x); }

function makeHeatmap(days, density) {
  const out = [];
  for (let i = 0; i < days; i++) {
    const r = seeded(i * 2.3 + density * 7);
    let v = 0;
    if (r > 0.78) v = 4; else if (r > 0.62) v = 3; else if (r > 0.45) v = 2; else if (r > 0.3) v = 1;
    out.push(v);
  }
  return out;
}

const HABITS = [
  { id: 'h1', name: 'Uống nước', icon: 'water', color: 'sky', cat: 'Sức khỏe', goalText: '8 ly · mỗi ngày',
    freq: 'Hằng ngày', time: '08:00', unit: 'ly', target: 8, progress: 6, streak: 23, best: 41, done: false, reminder: true,
    weekDone: [1,1,1,1,0,1,0], rate: 86 },
  { id: 'h2', name: 'Thiền', icon: 'meditate', color: 'violet', cat: 'Tinh thần', goalText: '10 phút · sáng',
    freq: 'Hằng ngày', time: '06:30', unit: 'phút', target: 10, progress: 10, streak: 12, best: 30, done: true, reminder: true,
    weekDone: [1,1,1,1,1,0,0], rate: 71 },
  { id: 'h3', name: 'Chạy bộ', icon: 'run', color: 'coral', cat: 'Thể thao', goalText: '3 km · T2/T4/T6',
    freq: '3 lần / tuần', time: '17:30', unit: 'km', target: 3, progress: 0, streak: 5, best: 9, done: false, reminder: true,
    weekDone: [1,0,1,0,1,0,0], rate: 64 },
  { id: 'h4', name: 'Đọc sách', icon: 'book', color: 'amber', cat: 'Học tập', goalText: '20 trang · tối',
    freq: 'Hằng ngày', time: '21:00', unit: 'trang', target: 20, progress: 12, streak: 31, best: 31, done: false, reminder: false,
    weekDone: [1,1,1,1,1,1,0], rate: 92 },
  { id: 'h5', name: 'Không đường', icon: 'apple', color: 'green', cat: 'Ăn uống', goalText: 'Cả ngày',
    freq: 'Hằng ngày', time: '—', unit: '', target: 1, progress: 1, streak: 8, best: 14, done: true, reminder: false,
    weekDone: [1,1,0,1,1,1,0], rate: 78 },
  { id: 'h6', name: 'Ngủ trước 23h', icon: 'bed', color: 'pink', cat: 'Sức khỏe', goalText: 'Trước 23:00',
    freq: 'Hằng ngày', time: '22:45', unit: '', target: 1, progress: 0, streak: 3, best: 19, done: false, reminder: true,
    weekDone: [0,1,1,0,1,0,0], rate: 58 },
];

const ICON_CHOICES = ['water','meditate','run','book','apple','bed','dumbbell','coffee','music','pen','leaf','heart','bulb','mountain','meditate','clock'];
const COLOR_CHOICES = ['green','sky','violet','coral','amber','pink'];

const BADGES = [
  { id: 'b1', name: 'Tia lửa đầu tiên', icon: 'zap', got: true, desc: 'Hoàn thành thói quen đầu tiên', color: 'amber' },
  { id: 'b2', name: 'Chuỗi 7 ngày', icon: 'fire', got: true, desc: 'Giữ streak 7 ngày liên tục', color: 'coral' },
  { id: 'b3', name: 'Chuỗi 30 ngày', icon: 'flag', got: true, desc: 'Giữ streak 30 ngày', color: 'green' },
  { id: 'b4', name: 'Người dậy sớm', icon: 'sun', got: true, desc: 'Check-in trước 7h sáng × 10', color: 'amber' },
  { id: 'b5', name: 'Tuần hoàn hảo', icon: 'star', got: false, desc: 'Hoàn thành 100% trong 1 tuần', color: 'violet' },
  { id: 'b6', name: 'Bậc thầy thiền', icon: 'leaf', got: false, desc: 'Thiền tổng 500 phút', color: 'green' },
  { id: 'b7', name: 'Mọt sách', icon: 'book', got: false, desc: 'Đọc 1000 trang', color: 'amber' },
  { id: 'b8', name: 'Huyền thoại', icon: 'trophy', got: false, desc: 'Đạt level 20', color: 'coral' },
];

const CHALLENGES = [
  { id: 'c1', name: '21 ngày uống đủ nước', icon: 'water', color: 'sky', joined: true, total: 21, current: 14, people: 1284, days: '7 ngày còn lại' },
  { id: 'c2', name: 'Tháng không đường', icon: 'apple', color: 'green', joined: true, total: 30, current: 8, people: 642, days: '22 ngày còn lại' },
  { id: 'c3', name: 'Thử thách đọc 30 ngày', icon: 'book', color: 'amber', joined: false, total: 30, current: 0, people: 3120, days: 'Bắt đầu T2' },
  { id: 'c4', name: '7 ngày dậy sớm', icon: 'sun', color: 'coral', joined: false, total: 7, current: 0, people: 890, days: 'Mở đăng ký' },
  { id: 'c5', name: 'Chạy 50km / tháng', icon: 'run', color: 'violet', joined: false, total: 50, current: 0, people: 410, days: 'Bắt đầu 1/7' },
];

const MOODS = [
  { key: 'great', label: 'Tuyệt vời', icon: 'smile', color: 'green' },
  { key: 'good', label: 'Ổn', icon: 'smile', color: 'sky' },
  { key: 'meh', label: 'Bình thường', icon: 'meh', color: 'amber' },
  { key: 'bad', label: 'Không vui', icon: 'frown', color: 'coral' },
];

const JOURNAL = [
  { id: 'j1', date: 'Hôm nay · 21:30', mood: 'great', text: 'Hoàn thành cả 5 thói quen hôm nay! Chạy bộ buổi chiều giúp đầu óc nhẹ hẳn.', habits: ['Thiền','Đọc sách','Không đường'] },
  { id: 'j2', date: 'Hôm qua · 22:10', mood: 'good', text: 'Hơi mệt nhưng vẫn giữ được streak đọc sách. Mai thử dậy sớm hơn.', habits: ['Đọc sách','Uống nước'] },
  { id: 'j3', date: '2 ngày trước · 20:45', mood: 'meh', text: 'Ngày bận rộn, bỏ lỡ buổi chạy. Không sao, mai làm lại.', habits: ['Thiền'] },
];

// 18 weeks of heatmap data (GitHub style) — 7 rows x 18 cols
const HEATMAP_WEEKS = 18;
const HEATMAP = makeHeatmap(HEATMAP_WEEKS * 7, 1);

const WEEK_LABELS = ['T2','T3','T4','T5','T6','T7','CN'];
const WEEKLY_COMPLETION = [80, 60, 100, 90, 70, 40, 85]; // % per weekday
const MONTH_TREND = [62, 70, 58, 81, 74, 88, 79, 92, 85, 90, 78, 95]; // last 12 periods

const USER = {
  name: 'Minh Anh', handle: '@minhanh', level: 12, xp: 740, xpMax: 1000,
  totalDone: 1284, longestStreak: 41, badges: 4, joinedDays: 184,
};

Object.assign(window, {
  HABIT_COLORS, colorOf, HABITS, ICON_CHOICES, COLOR_CHOICES, BADGES, CHALLENGES,
  MOODS, JOURNAL, HEATMAP, HEATMAP_WEEKS, WEEK_LABELS, WEEKLY_COMPLETION, MONTH_TREND, USER, makeHeatmap, seeded,
});
