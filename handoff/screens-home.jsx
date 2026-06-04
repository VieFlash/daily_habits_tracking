// screens-home.jsx — Today / home with 3 layout variants
const { useState: useStateHome } = React;

function todayProgress(habits) {
  const done = habits.filter(h => h.done).length;
  return { done, total: habits.length, pct: habits.length ? done / habits.length : 0 };
}

function Greeting({ user, dark, onBell, onProfile, layout, onCycleLayout }) {
  const hr = new Date().getHours();
  const g = hr < 11 ? 'Chào buổi sáng' : hr < 18 ? 'Buổi chiều tốt lành' : 'Buổi tối an lành';
  const layoutIcon = layout === 'grid' ? 'list' : layout === 'list' ? 'grid' : 'grid';
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '6px 16px 2px' }}>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 13.5, color: 'var(--text-dim)', fontWeight: 700 }}>{g} 👋</div>
        <div style={{ fontSize: 23, fontWeight: 900, letterSpacing: '-.02em' }}>{user.name}</div>
      </div>
      {onCycleLayout && <IconBtn name={layout === 'list' ? 'grid' : layout === 'grid' ? 'list' : 'home'} onClick={onCycleLayout} />}
      <IconBtn name="bell" badge onClick={onBell} />
      <button onClick={onProfile} style={{ width: 42, height: 42, borderRadius: 99, border: '2px solid var(--primary-soft)', cursor: 'pointer', overflow: 'hidden', padding: 0,
        background: 'linear-gradient(135deg, var(--primary), var(--primary-soft-2))', color: 'var(--on-primary)', display: 'grid', placeItems: 'center', fontWeight: 800, fontSize: 16 }}>
        MA
      </button>
    </div>
  );
}

function WeekStrip() {
  const today = new Date();
  const days = [];
  for (let i = -3; i <= 3; i++) {
    const d = new Date(today); d.setDate(today.getDate() + i);
    days.push({ dow: WEEK_LABELS[(d.getDay() + 6) % 7], num: d.getDate(), today: i === 0 });
  }
  return (
    <div style={{ display: 'flex', gap: 6, padding: '10px 16px 4px', overflowX: 'auto' }}>
      {days.map((d, i) => (
        <div key={i} style={{ flex: 1, minWidth: 42, textAlign: 'center', padding: '9px 0', borderRadius: 16,
          background: d.today ? 'var(--primary)' : 'var(--surface)', color: d.today ? 'var(--on-primary)' : 'var(--text)',
          border: d.today ? 'none' : '1px solid var(--border)' }}>
          <div style={{ fontSize: 11, fontWeight: 700, opacity: d.today ? 0.9 : 0.6 }}>{d.dow}</div>
          <div style={{ fontSize: 17, fontWeight: 800, marginTop: 2 }}>{d.num}</div>
          {!d.today && <div style={{ width: 4, height: 4, borderRadius: 99, background: 'var(--primary)', margin: '4px auto 0', opacity: 0.5 }} />}
        </div>
      ))}
    </div>
  );
}

function SummaryCard({ habits, dark }) {
  const { done, total, pct } = todayProgress(habits);
  const msg = pct === 1 ? 'Hoàn hảo! Bạn đã xong tất cả 🎉' : pct >= 0.5 ? 'Tiến độ tốt, cố lên!' : 'Bắt đầu ngày mới nào!';
  return (
    <Card style={{ background: 'linear-gradient(135deg, var(--primary), color-mix(in oklch, var(--primary), #000 14%))', border: 'none', color: 'var(--on-primary)', display: 'flex', alignItems: 'center', gap: 16, padding: 18 }}>
      <Ring value={done} max={total} size={68} stroke={7} color="#fff" track="rgba(255,255,255,0.28)">
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 18, fontWeight: 900, lineHeight: 1 }}>{Math.round(pct * 100)}<span style={{ fontSize: 10 }}>%</span></div>
        </div>
      </Ring>
      <div style={{ flex: 1 }}>
        <div style={{ fontSize: 16.5, fontWeight: 900, marginBottom: 3 }}>{done}/{total} thói quen</div>
        <div style={{ fontSize: 13, fontWeight: 600, opacity: 0.92 }}>{msg}</div>
      </div>
      <div style={{ textAlign: 'center', background: 'rgba(255,255,255,0.18)', borderRadius: 16, padding: '8px 12px' }}>
        <Icon name="fire" size={20} fill="#fff" color="#fff" style={{ margin: '0 auto' }} />
        <div style={{ fontSize: 16, fontWeight: 900, marginTop: 2 }}>31</div>
        <div style={{ fontSize: 9.5, fontWeight: 700, opacity: 0.9 }}>chuỗi dài</div>
      </div>
    </Card>
  );
}

// ---- Habit row (list layout) ----
function HabitRow({ h, dark, onToggle, onOpen }) {
  const c = colorOf(h.color, dark);
  return (
    <Card pad={12} onClick={onOpen} style={{ display: 'flex', alignItems: 'center', gap: 13, marginBottom: 10, opacity: h.done ? 0.7 : 1 }}>
      <HabitTile icon={h.icon} color={h.color} dark={dark} size={46} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 15.5, fontWeight: 800, textDecoration: h.done ? 'line-through' : 'none', textDecorationColor: 'var(--text-faint)' }}>{h.name}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 3 }}>
          <span style={{ fontSize: 12, color: 'var(--text-dim)', fontWeight: 600, display: 'inline-flex', alignItems: 'center', gap: 3 }}>
            <Icon name="clock" size={13} />{h.time}</span>
          <span style={{ fontSize: 12, fontWeight: 700, color: c.base, display: 'inline-flex', alignItems: 'center', gap: 3 }}>
            <Icon name="fire" size={13} />{h.streak}</span>
        </div>
      </div>
      {h.target > 1 && !h.done && (
        <div style={{ fontSize: 11.5, fontWeight: 700, color: 'var(--text-dim)', marginRight: 2 }}>{h.progress}/{h.target}</div>
      )}
      <div onClick={e => { e.stopPropagation(); onToggle(h.id); }}>
        <CheckCircle done={h.done} color={h.color} dark={dark} />
      </div>
    </Card>
  );
}

// ---- Habit card (card layout) ----
function HabitCardBig({ h, dark, onToggle, onOpen }) {
  const c = colorOf(h.color, dark);
  const pct = h.target > 1 ? h.progress / h.target : (h.done ? 1 : 0);
  return (
    <Card onClick={onOpen} style={{ marginBottom: 12, padding: 16 }}>
      <div style={{ display: 'flex', alignItems: 'flex-start', gap: 13 }}>
        <HabitTile icon={h.icon} color={h.color} dark={dark} size={50} r={18} />
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: 16, fontWeight: 800 }}>{h.name}</div>
          <div style={{ fontSize: 12.5, color: 'var(--text-dim)', fontWeight: 600, marginTop: 2 }}>{h.goalText}</div>
        </div>
        <div onClick={e => { e.stopPropagation(); onToggle(h.id); }}>
          <CheckCircle done={h.done} color={h.color} dark={dark} size={36} />
        </div>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginTop: 14 }}>
        <div style={{ flex: 1, height: 8, borderRadius: 99, background: 'var(--surface-3)', overflow: 'hidden' }}>
          <div style={{ height: '100%', width: `${Math.min(100, pct * 100)}%`, background: c.base, borderRadius: 99, transition: 'width .5s' }} />
        </div>
        <span style={{ fontSize: 12.5, fontWeight: 800, color: c.base, display: 'inline-flex', alignItems: 'center', gap: 3 }}>
          <Icon name="fire" size={14} />{h.streak} ngày</span>
      </div>
    </Card>
  );
}

// ---- Habit grid tile (grid layout) ----
function HabitGridTile({ h, dark, onToggle, onOpen }) {
  const c = colorOf(h.color, dark);
  return (
    <Card onClick={onOpen} style={{ padding: 14, position: 'relative', background: h.done ? c.soft : 'var(--surface)', border: h.done ? `1px solid ${c.base}33` : '1px solid var(--border)' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <HabitTile icon={h.icon} color={h.color} dark={dark} size={44} r={15} />
        <div onClick={e => { e.stopPropagation(); onToggle(h.id); }}>
          <CheckCircle done={h.done} color={h.color} dark={dark} size={30} />
        </div>
      </div>
      <div style={{ fontSize: 14.5, fontWeight: 800, marginTop: 12 }}>{h.name}</div>
      <div style={{ fontSize: 11.5, color: 'var(--text-dim)', fontWeight: 600, marginTop: 2 }}>{h.target > 1 ? `${h.progress}/${h.target} ${h.unit}` : h.freq}</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginTop: 10, fontSize: 12, fontWeight: 800, color: c.base }}>
        <Icon name="fire" size={13} />{h.streak}
      </div>
    </Card>
  );
}

function HomeScreen({ habits, dark, layout, onToggle, onOpen, onBell, onProfile, user, onCycleLayout }) {
  const [filter, setFilter] = useStateHome('all');
  const cats = ['all', ...Array.from(new Set(habits.map(h => h.cat)))];
  const catLabel = { all: 'Tất cả' };
  let list = habits;
  if (filter === 'todo') list = habits.filter(h => !h.done);
  else if (filter === 'done') list = habits.filter(h => h.done);
  else if (filter !== 'all') list = habits.filter(h => h.cat === filter);

  return (
    <div style={{ flex: 1, overflow: 'auto' }}>
      <Greeting user={user} dark={dark} onBell={onBell} onProfile={onProfile} layout={layout} onCycleLayout={onCycleLayout} />
      <WeekStrip />
      <div style={{ padding: '8px 16px 0' }}>
        <SummaryCard habits={habits} dark={dark} />
      </div>

      <div style={{ display: 'flex', gap: 8, padding: '14px 16px 6px', overflowX: 'auto' }}>
        <Chip label="Tất cả" active={filter === 'all'} onClick={() => setFilter('all')} />
        <Chip label="Chưa xong" active={filter === 'todo'} onClick={() => setFilter('todo')} />
        <Chip label="Đã xong" active={filter === 'done'} onClick={() => setFilter('done')} />
        {Array.from(new Set(habits.map(h => h.cat))).map(cat => (
          <Chip key={cat} label={cat} active={filter === cat} onClick={() => setFilter(cat)} />
        ))}
      </div>

      <div style={{ padding: '6px 16px 16px' }}>
        {list.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '40px 20px', color: 'var(--text-dim)' }}>
            <Icon name="check" size={40} style={{ margin: '0 auto 10px', color: 'var(--primary)' }} />
            <div style={{ fontWeight: 800, fontSize: 15 }}>Không có gì ở đây cả</div>
          </div>
        ) : layout === 'grid' ? (
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
            {list.map(h => <HabitGridTile key={h.id} h={h} dark={dark} onToggle={onToggle} onOpen={() => onOpen(h)} />)}
          </div>
        ) : layout === 'card' ? (
          list.map(h => <HabitCardBig key={h.id} h={h} dark={dark} onToggle={onToggle} onOpen={() => onOpen(h)} />)
        ) : (
          list.map(h => <HabitRow key={h.id} h={h} dark={dark} onToggle={onToggle} onOpen={() => onOpen(h)} />)
        )}
      </div>
    </div>
  );
}

Object.assign(window, { HomeScreen, todayProgress });
