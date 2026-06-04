import '../models/journal_entry_model.dart';

/// Initial journal entries, ported from data.jsx.
const kJournalSeed = <JournalEntryModel>[
  JournalEntryModel(
    id: 'j1',
    date: 'Hôm nay · 21:30',
    mood: 'great',
    text:
        'Hoàn thành cả 5 thói quen hôm nay! Chạy bộ buổi chiều giúp đầu óc nhẹ hẳn.',
    habits: ['Thiền', 'Đọc sách', 'Không đường'],
  ),
  JournalEntryModel(
    id: 'j2',
    date: 'Hôm qua · 22:10',
    mood: 'good',
    text: 'Hơi mệt nhưng vẫn giữ được streak đọc sách. Mai thử dậy sớm hơn.',
    habits: ['Đọc sách', 'Uống nước'],
  ),
  JournalEntryModel(
    id: 'j3',
    date: '2 ngày trước · 20:45',
    mood: 'meh',
    text: 'Ngày bận rộn, bỏ lỡ buổi chạy. Không sao, mai làm lại.',
    habits: ['Thiền'],
  ),
];
