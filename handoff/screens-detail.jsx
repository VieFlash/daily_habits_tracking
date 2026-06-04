// screens-detail.jsx — habit detail: streak, heatmap, calendar, history
const { useState: useStateDetail } = React;

function Heatmap({ color, dark, weeks = HEATMAP_WEEKS }) {
  const c = colorOf(color, dark);
  const data = HEATMAP;
  const levels = [
    'var(--surface-3)',
    `color-mix(in oklch, ${c.base}, var(--surface) 70%)`,
    `color-mix(in oklch, ${c.base}, var(--surface) 45%)`,
    `color-mix(in oklch, ${c.base}, var(--surface) 20%)`,
    c.base,
  ];
  return (
    <div>
      <div style={{ display: 'flex', gap: 4, overflowX: 'auto', paddingBottom: 4 }}>
        {Array.from({ length: weeks }).map((_, w) => (
          <div key={w} style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
            {Array.from({ length: 7 }).map((_, d) => {
              const v = data[w * 7 + d] || 0;
              return <div key={d} style={{ width: 13, height: 13, borderRadius: 4, background: levels[v] }} />;
            })}
          </div>
        ))}
      </div>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: 5, marginTop: 10, fontSize: 11, color: 'var(--text-dim)', fontWeight: 600 }}>
        Ít{levels.map((l, i) => <span key={i} style={{ width: 12, height: 12, borderRadius: 4, background: l }} />)}Nhiều
      </div>
    </div>
  );
}

function MiniCalendar({ color, dark }) {
  const c = colorOf(color, dark);
  const today = new Date();
  const year = today.getFullYear(), month = today.getMonth();
  const first = new Date(year, month, 1);
  const startDow = (first.getDay() + 6) % 7;
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const monthName = first.toLocaleDateString('vi-VN', { month: 'long', year: 'numeric' });
  const cells = [];
  for (let i = 0; i < startDow; i++) cells.push(null);
  for (let d = 1; d <= daysInMonth; d++) cells.push(d);
  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
        <span style={{ fontSize: 15, fontWeight: 800, textTransform: 'capitalize' }}>{monthName}</span>
        <div style={{ display: 'flex', gap: 6 }}>
          <IconBtn name="chevL" size={32} /><IconBtn name="chevR" size={32} />
        </div>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7,1fr)', gap: 4, textAlign: 'center' }}>
        {WEEK_LABELS.map(l => <div key={l} style={{ fontSize: 11, fontWeight: 700, color: 'var(--text-faint)', paddingBottom: 4 }}>{l}</div>)}
        {cells.map((d, i) => {
          if (!d) return <div key={i} />;
          const isToday = d === today.getDate();
          const done = d <= today.getDate() && seeded(d * 1.7 + 3) > 0.32;
          const miss = d <= today.getDate() && !done && !isToday;
          return (
            <div key={i} style={{ aspectRatio: '1', display: 'grid', placeItems: 'center', position: 'relative', fontSize: 13, fontWeight: 700,
              borderRadius: 12, background: done ? c.soft : 'transparent', color: done ? c.base : isToday ? 'var(--primary)' : miss ? 'var(--text-faint)' : 'var(--text)',
              border: isToday ? '2px solid var(--primary)' : 'none' }}>
              {d}
              {done && <span style={{ position: 'absolute', bottom: 3, width: 4, height: 4, borderRadius: 99, background: c.base }} />}
            </div>
          );
        })}
      </div>
    </div>
  );
}

function StatPill({ icon, value, label, color }) {
  return (
    <div style={{ flex: 1, textAlign: 'center', padding: '14px 4px' }}>
      <Icon name={icon} size={22} color={color || 'var(--primary)'} style={{ margin: '0 auto 6px' }} />
      <div style={{ fontSize: 20, fontWeight: 900, letterSpacing: '-.02em' }}>{value}</div>
      <div style={{ fontSize: 11.5, color: 'var(--text-dim)', fontWeight: 700 }}>{label}</div>
    </div>
  );
}

function HabitDetail({ h, dark, onClose, onEdit, onToggle }) {
  const [tab, setTab] = useStateDetail('overview');
  const c = colorOf(h.color, dark);
  return (
    <Screen>
      <AppBar onBack={onClose} title={h.name} right={<IconBtn name="edit" onClick={onEdit} />} />
      <Body>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 16 }}>
          <HabitTile icon={h.icon} color={h.color} dark={dark} size={58} r={20} />
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: c.base }}>{h.cat}</div>
            <div style={{ fontSize: 13.5, color: 'var(--text-dim)', fontWeight: 600 }}>{h.goalText}</div>
          </div>
          <CheckCircle done={h.done} color={h.color} dark={dark} size={40} onClick={() => onToggle(h.id)} />
        </div>

        <Card style={{ display: 'flex', padding: 4, marginBottom: 16 }}>
          <StatPill icon="fire" value={h.streak} label="chuỗi hiện tại" color="var(--coral)" />
          <div style={{ width: 1, background: 'var(--border)' }} />
          <StatPill icon="trophy" value={h.best} label="chuỗi dài nhất" color="var(--amber)" />
          <div style={{ width: 1, background: 'var(--border)' }} />
          <StatPill icon="target" value={h.rate + '%'} label="tỉ lệ hoàn thành" color={c.base} />
        </Card>

        <div style={{ marginBottom: 16 }}>
          <Segmented value={tab} onChange={setTab} options={[{ value: 'overview', label: 'Lịch sử' }, { value: 'calendar', label: 'Lịch' }]} />
        </div>

        {tab === 'overview' ? (
          <Card style={{ marginBottom: 16 }}>
            <div style={{ fontSize: 14.5, fontWeight: 800, marginBottom: 14 }}>Heatmap 18 tuần qua</div>
            <Heatmap color={h.color} dark={dark} />
          </Card>
        ) : (
          <Card style={{ marginBottom: 16 }}><MiniCalendar color={h.color} dark={dark} /></Card>
        )}

        <SectionLabel>Tuần này</SectionLabel>
        <Card style={{ display: 'flex', justifyContent: 'space-between', padding: '16px 14px' }}>
          {WEEK_LABELS.map((lb, i) => (
            <div key={i} style={{ textAlign: 'center' }}>
              <div style={{ fontSize: 11, fontWeight: 700, color: 'var(--text-faint)', marginBottom: 8 }}>{lb}</div>
              <div style={{ width: 30, height: 30, borderRadius: 99, display: 'grid', placeItems: 'center',
                background: h.weekDone[i] ? c.base : 'var(--surface-3)', color: '#fff' }}>
                {h.weekDone[i] ? <Icon name="check" size={16} stroke={3} /> : <span style={{ width: 5, height: 5, borderRadius: 99, background: 'var(--text-faint)' }} />}
              </div>
            </div>
          ))}
        </Card>

        <SectionLabel>Ghi chú</SectionLabel>
        <Card style={{ display: 'flex', alignItems: 'center', gap: 10, color: 'var(--text-dim)' }}>
          <Icon name="pen" size={18} />
          <span style={{ fontSize: 13.5, fontWeight: 600 }}>Thêm cảm nghĩ về thói quen này...</span>
        </Card>
      </Body>
    </Screen>
  );
}

Object.assign(window, { HabitDetail, Heatmap, MiniCalendar });
