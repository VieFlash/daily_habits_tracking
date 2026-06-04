// screens-extra.jsx — challenges, journal, notifications, profile, settings
const { useState: useStateX } = React;

// ===== CHALLENGES =====
function ChallengesScreen({ dark }) {
  const [tab, setTab] = useStateX('mine');
  const list = tab === 'mine' ? CHALLENGES.filter(c => c.joined) : CHALLENGES.filter(c => !c.joined);
  return (
    <div style={{ flex: 1, overflow: 'auto' }}>
      <AppBar large title="Thử thách" subtitle="Cùng cộng đồng giữ vững phong độ" />
      <Body style={{ paddingTop: 8 }}>
        <div style={{ marginBottom: 16 }}>
          <Segmented value={tab} onChange={setTab} options={[{ value: 'mine', label: 'Đang tham gia' }, { value: 'explore', label: 'Khám phá' }]} />
        </div>
        {list.map(ch => {
          const c = colorOf(ch.color, dark);
          const pct = ch.current / ch.total;
          return (
            <Card key={ch.id} style={{ marginBottom: 14, padding: 16 }}>
              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 13 }}>
                <HabitTile icon={ch.icon} color={ch.color} dark={dark} size={50} r={18} />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 15.5, fontWeight: 800 }}>{ch.name}</div>
                  <div style={{ fontSize: 12, color: 'var(--text-dim)', fontWeight: 600, marginTop: 3, display: 'flex', gap: 10 }}>
                    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}><Icon name="user" size={13} />{ch.people.toLocaleString('vi-VN')}</span>
                    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}><Icon name="clock" size={13} />{ch.days}</span>
                  </div>
                </div>
              </div>
              {ch.joined ? (
                <div style={{ marginTop: 14 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12, fontWeight: 800, marginBottom: 6 }}>
                    <span style={{ color: c.base }}>Ngày {ch.current}/{ch.total}</span>
                    <span style={{ color: 'var(--text-dim)' }}>{Math.round(pct * 100)}%</span>
                  </div>
                  <div style={{ height: 9, borderRadius: 99, background: 'var(--surface-3)', overflow: 'hidden' }}>
                    <div style={{ height: '100%', width: `${pct * 100}%`, background: c.base, borderRadius: 99 }} />
                  </div>
                </div>
              ) : (
                <div style={{ marginTop: 14 }}><Button full variant="soft" size="sm" icon="plus">Tham gia thử thách</Button></div>
              )}
            </Card>
          );
        })}
      </Body>
    </div>
  );
}

// ===== JOURNAL =====
function moodColor(key, dark) {
  const m = MOODS.find(x => x.key === key) || MOODS[0];
  return colorOf(m.color, dark);
}
function JournalScreen({ dark, onAdd }) {
  return (
    <div style={{ flex: 1, overflow: 'auto' }}>
      <AppBar large title="Nhật ký" subtitle="Ghi lại cảm xúc mỗi ngày"
        right={<IconBtn name="plus" active onClick={onAdd} />} />
      <Body style={{ paddingTop: 8 }}>
        <Card onClick={onAdd} style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16, background: 'var(--primary-soft)', border: 'none' }}>
          <div style={{ width: 42, height: 42, borderRadius: 14, background: 'var(--surface)', color: 'var(--primary)', display: 'grid', placeItems: 'center' }}><Icon name="pencil" size={20} /></div>
          <div style={{ flex: 1 }}><div style={{ fontSize: 14.5, fontWeight: 800, color: 'var(--text)' }}>Hôm nay bạn thế nào?</div><div style={{ fontSize: 12, color: 'var(--text-dim)', fontWeight: 600 }}>Viết vài dòng nhé</div></div>
          <Icon name="chevR" size={20} color="var(--primary)" />
        </Card>

        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 16 }}>
          {MOODS.map(m => { const c = colorOf(m.color, dark); return (
            <div key={m.key} style={{ textAlign: 'center', flex: 1 }}>
              <div style={{ width: 48, height: 48, borderRadius: 99, background: c.soft, color: c.base, display: 'grid', placeItems: 'center', margin: '0 auto 5px' }}><Icon name={m.icon} size={26} /></div>
              <div style={{ fontSize: 10.5, fontWeight: 700, color: 'var(--text-dim)' }}>{m.label}</div>
            </div>
          ); })}
        </div>

        <SectionLabel>Gần đây</SectionLabel>
        {JOURNAL.map(j => {
          const c = moodColor(j.mood, dark);
          const m = MOODS.find(x => x.key === j.mood);
          return (
            <Card key={j.id} style={{ marginBottom: 12 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
                <div style={{ width: 36, height: 36, borderRadius: 12, background: c.soft, color: c.base, display: 'grid', placeItems: 'center' }}><Icon name={m.icon} size={20} /></div>
                <div style={{ flex: 1 }}><div style={{ fontSize: 13, fontWeight: 800 }}>{m.label}</div><div style={{ fontSize: 11.5, color: 'var(--text-faint)', fontWeight: 600 }}>{j.date}</div></div>
              </div>
              <p style={{ fontSize: 14, lineHeight: 1.5, margin: '0 0 10px', color: 'var(--text)', fontWeight: 500 }}>{j.text}</p>
              <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                {j.habits.map(hb => <span key={hb} style={{ fontSize: 11, fontWeight: 700, padding: '4px 10px', borderRadius: 99, background: 'var(--surface-2)', color: 'var(--text-dim)' }}>#{hb}</span>)}
              </div>
            </Card>
          );
        })}
      </Body>
    </div>
  );
}

function AddJournalSheet({ open, onClose, dark, onSave }) {
  const [mood, setMood] = useStateX('great');
  const [text, setText] = useStateX('');
  return (
    <Sheet open={open} onClose={onClose}>
      <div style={{ padding: '8px 20px 16px' }}>
        <div style={{ fontSize: 18, fontWeight: 900, marginBottom: 4 }}>Nhật ký hôm nay</div>
        <div style={{ fontSize: 13, color: 'var(--text-dim)', fontWeight: 600, marginBottom: 18 }}>Hôm nay bạn cảm thấy thế nào?</div>
        <div style={{ display: 'flex', gap: 10, marginBottom: 20 }}>
          {MOODS.map(m => { const c = colorOf(m.color, dark); const on = mood === m.key; return (
            <button key={m.key} onClick={() => setMood(m.key)} style={{ flex: 1, padding: '12px 4px', borderRadius: 18, cursor: 'pointer', fontFamily: 'inherit',
              border: on ? `2px solid ${c.base}` : '2px solid var(--border)', background: on ? c.soft : 'var(--surface)' }}>
              <Icon name={m.icon} size={28} color={on ? c.base : 'var(--text-faint)'} style={{ margin: '0 auto 4px' }} />
              <div style={{ fontSize: 10.5, fontWeight: 800, color: on ? c.base : 'var(--text-dim)' }}>{m.label}</div>
            </button>
          ); })}
        </div>
        <textarea value={text} onChange={e => setText(e.target.value)} placeholder="Viết về ngày hôm nay của bạn..." rows={4} style={{
          width: '100%', padding: 14, borderRadius: 16, border: '1.5px solid var(--border-strong)', background: 'var(--surface-2)', color: 'var(--text)',
          fontSize: 14.5, fontWeight: 500, fontFamily: 'inherit', resize: 'none', outline: 'none', marginBottom: 16 }} />
        <Button full size="lg" icon="check" onClick={() => onSave(mood, text)}>Lưu nhật ký</Button>
      </div>
    </Sheet>
  );
}

// ===== NOTIFICATIONS =====
function NotificationsSheet({ open, onClose, dark }) {
  const items = [
    { icon: 'water', color: 'sky', title: 'Đến giờ uống nước 💧', time: '5 phút trước', sub: 'Bạn còn 2 ly nữa là đạt mục tiêu' },
    { icon: 'fire', color: 'coral', title: 'Chuỗi 31 ngày!', time: '2 giờ trước', sub: 'Đọc sách — chuỗi dài nhất của bạn 🎉' },
    { icon: 'trophy', color: 'amber', title: 'Mở khóa huy hiệu mới', time: 'Hôm qua', sub: '"Người dậy sớm" đã được mở' },
    { icon: 'meditate', color: 'violet', title: 'Nhắc nhở thiền', time: 'Hôm qua', sub: 'Buổi thiền 10 phút buổi sáng' },
  ];
  return (
    <Sheet open={open} onClose={onClose} height="72%">
      <div style={{ padding: '8px 20px 16px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 16 }}>
          <div style={{ fontSize: 18, fontWeight: 900 }}>Thông báo</div>
          <span style={{ fontSize: 12.5, fontWeight: 700, color: 'var(--primary)' }}>Đánh dấu đã đọc</span>
        </div>
        {items.map((it, i) => { const c = colorOf(it.color, dark); return (
          <div key={i} style={{ display: 'flex', gap: 12, padding: '12px 0', borderBottom: i < items.length - 1 ? '1px solid var(--border)' : 'none' }}>
            <div style={{ width: 42, height: 42, borderRadius: 14, background: c.soft, color: c.base, display: 'grid', placeItems: 'center', flexShrink: 0 }}><Icon name={it.icon} size={22} /></div>
            <div style={{ flex: 1 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', gap: 8 }}><span style={{ fontSize: 14, fontWeight: 800 }}>{it.title}</span><span style={{ fontSize: 11, color: 'var(--text-faint)', fontWeight: 600, whiteSpace: 'nowrap' }}>{it.time}</span></div>
              <div style={{ fontSize: 12.5, color: 'var(--text-dim)', fontWeight: 600, marginTop: 2 }}>{it.sub}</div>
            </div>
          </div>
        ); })}
      </div>
    </Sheet>
  );
}

// ===== PROFILE + SETTINGS =====
function ProfileScreen({ dark, user, onClose, theme, onTheme, onGamification }) {
  const stats = [
    { v: user.totalDone.toLocaleString('vi-VN'), l: 'Hoàn thành' },
    { v: user.longestStreak, l: 'Chuỗi dài nhất' },
    { v: user.joinedDays, l: 'Ngày đồng hành' },
  ];
  const Row = ({ icon, label, color, right, onClick, last }) => (
    <div onClick={onClick} style={{ display: 'flex', alignItems: 'center', gap: 13, padding: '13px 16px', cursor: onClick ? 'pointer' : 'default', borderBottom: last ? 'none' : '1px solid var(--border)' }}>
      <div style={{ width: 36, height: 36, borderRadius: 11, background: 'var(--surface-2)', color: color || 'var(--text)', display: 'grid', placeItems: 'center' }}><Icon name={icon} size={19} /></div>
      <span style={{ flex: 1, fontSize: 14.5, fontWeight: 700 }}>{label}</span>
      {right || <Icon name="chevR" size={18} color="var(--text-faint)" />}
    </div>
  );
  return (
    <Screen>
      <AppBar onBack={onClose} title="Hồ sơ" right={<IconBtn name="settings" />} />
      <Body>
        <div style={{ textAlign: 'center', marginBottom: 18 }}>
          <div style={{ width: 84, height: 84, borderRadius: 99, margin: '0 auto 12px', background: 'linear-gradient(135deg, var(--primary), var(--primary-soft-2))', color: 'var(--on-primary)', display: 'grid', placeItems: 'center', fontSize: 30, fontWeight: 900, border: '3px solid var(--surface)', boxShadow: 'var(--shadow-card)' }}>MA</div>
          <div style={{ fontSize: 21, fontWeight: 900 }}>{user.name}</div>
          <div style={{ fontSize: 13.5, color: 'var(--text-dim)', fontWeight: 700 }}>{user.handle} · Cấp {user.level}</div>
        </div>

        <Card style={{ display: 'flex', padding: '16px 4px', marginBottom: 16 }}>
          {stats.map((s, i) => (
            <React.Fragment key={i}>
              {i > 0 && <div style={{ width: 1, background: 'var(--border)' }} />}
              <div style={{ flex: 1, textAlign: 'center' }}><div style={{ fontSize: 20, fontWeight: 900 }}>{s.v}</div><div style={{ fontSize: 11.5, color: 'var(--text-dim)', fontWeight: 700 }}>{s.l}</div></div>
            </React.Fragment>
          ))}
        </Card>

        <SectionLabel>Chung</SectionLabel>
        <Card pad={0} style={{ marginBottom: 16, overflow: 'hidden' }}>
          <Row icon="trophy" label="Thành tựu & huy hiệu" color="var(--amber)" onClick={onGamification} />
          <Row icon="bell" label="Nhắc nhở & thông báo" color="var(--coral)" />
          <Row icon="moon" label="Giao diện tối" right={<Switch on={theme === 'dark'} onClick={onTheme} />} last />
        </Card>

        <SectionLabel>Khác</SectionLabel>
        <Card pad={0} style={{ marginBottom: 16, overflow: 'hidden' }}>
          <Row icon="download" label="Sao lưu & đồng bộ" color="var(--sky)" />
          <Row icon="palette" label="Tùy chỉnh giao diện" color="var(--violet)" />
          <Row icon="share" label="Chia sẻ với bạn bè" color="var(--primary)" />
          <Row icon="shield" label="Quyền riêng tư" last />
        </Card>

        <Card pad={0} style={{ overflow: 'hidden' }}>
          <Row icon="logout" label="Đăng xuất" color="var(--coral)" right={<span />} last />
        </Card>
      </Body>
    </Screen>
  );
}

Object.assign(window, { ChallengesScreen, JournalScreen, AddJournalSheet, NotificationsSheet, ProfileScreen });
