// screens-stats.jsx — progress charts + gamification
const { useState: useStateStats } = React;

function BarChart({ data, labels, color = 'var(--primary)' }) {
  const max = Math.max(...data, 1);
  return (
    <div style={{ display: 'flex', alignItems: 'flex-end', gap: 8, height: 130, padding: '0 2px' }}>
      {data.map((v, i) => (
        <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, height: '100%', justifyContent: 'flex-end' }}>
          <span style={{ fontSize: 10.5, fontWeight: 800, color: 'var(--text-dim)' }}>{v}%</span>
          <div style={{ width: '100%', maxWidth: 24, height: `${(v / max) * 100}%`, minHeight: 6, borderRadius: 8,
            background: v >= 80 ? color : `color-mix(in oklch, ${color}, var(--surface) 45%)`, transition: 'height .5s' }} />
          <span style={{ fontSize: 10.5, fontWeight: 700, color: 'var(--text-faint)' }}>{labels[i]}</span>
        </div>
      ))}
    </div>
  );
}

function LineChart({ data, color = 'var(--primary)' }) {
  const w = 320, h = 96, max = Math.max(...data), min = Math.min(...data);
  const range = max - min || 1;
  const pts = data.map((v, i) => [i / (data.length - 1) * w, h - ((v - min) / range) * (h - 16) - 8]);
  const path = pts.map((p, i) => (i === 0 ? 'M' : 'L') + p[0].toFixed(1) + ' ' + p[1].toFixed(1)).join(' ');
  const area = path + ` L${w} ${h} L0 ${h} Z`;
  return (
    <svg viewBox={`0 0 ${w} ${h}`} style={{ width: '100%', height: 96, display: 'block' }}>
      <defs>
        <linearGradient id="lg" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor={color} stopOpacity="0.25" />
          <stop offset="100%" stopColor={color} stopOpacity="0" />
        </linearGradient>
      </defs>
      <path d={area} fill="url(#lg)" />
      <path d={path} fill="none" stroke={color} strokeWidth={3} strokeLinecap="round" strokeLinejoin="round" />
      {pts.map((p, i) => i === pts.length - 1 && <circle key={i} cx={p[0]} cy={p[1]} r={5} fill={color} stroke="var(--surface)" strokeWidth={2.5} />)}
    </svg>
  );
}

function LevelCard({ user, onOpen }) {
  return (
    <Card onClick={onOpen} style={{ background: 'linear-gradient(135deg, var(--violet), color-mix(in oklch, var(--violet), #000 18%))', border: 'none', color: '#fff', padding: 18 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
        <div style={{ width: 56, height: 56, borderRadius: 18, background: 'rgba(255,255,255,0.2)', display: 'grid', placeItems: 'center', position: 'relative' }}>
          <Icon name="zap" size={28} fill="#fff" color="#fff" />
        </div>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 17, fontWeight: 900 }}>Cấp độ {user.level}</div>
          <div style={{ fontSize: 12.5, fontWeight: 700, opacity: 0.9 }}>Người gieo mầm chăm chỉ</div>
        </div>
        <Icon name="chevR" size={22} color="#fff" />
      </div>
      <div style={{ marginTop: 14 }}>
        <div style={{ height: 9, borderRadius: 99, background: 'rgba(255,255,255,0.25)', overflow: 'hidden' }}>
          <div style={{ height: '100%', width: `${user.xp / user.xpMax * 100}%`, background: '#fff', borderRadius: 99 }} />
        </div>
        <div style={{ fontSize: 11.5, fontWeight: 700, opacity: 0.9, marginTop: 6 }}>{user.xp} / {user.xpMax} XP · còn {user.xpMax - user.xp} XP lên cấp {user.level + 1}</div>
      </div>
    </Card>
  );
}

function StatsScreen({ habits, dark, user, onGamification }) {
  const [range, setRange] = useStateStats('week');
  const totalRate = Math.round(habits.reduce((a, h) => a + h.rate, 0) / habits.length);
  const best = [...habits].sort((a, b) => b.streak - a.streak).slice(0, 3);
  return (
    <div style={{ flex: 1, overflow: 'auto' }}>
      <AppBar large title="Tiến độ" subtitle="Bạn đang làm rất tốt 🌱" />
      <Body style={{ paddingTop: 8 }}>
        <div style={{ display: 'flex', gap: 12, marginBottom: 14 }}>
          <Card style={{ flex: 1, textAlign: 'center', padding: '16px 8px' }}>
            <Ring value={totalRate} max={100} size={64} stroke={7}>
              <span style={{ fontSize: 16, fontWeight: 900 }}>{totalRate}%</span>
            </Ring>
            <div style={{ fontSize: 12, fontWeight: 700, color: 'var(--text-dim)', marginTop: 8 }}>Tỉ lệ chung</div>
          </Card>
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 12 }}>
            <Card style={{ flex: 1, padding: 14, display: 'flex', alignItems: 'center', gap: 10 }}>
              <Icon name="check" size={22} color="var(--primary)" />
              <div><div style={{ fontSize: 19, fontWeight: 900 }}>{user.totalDone.toLocaleString('vi-VN')}</div><div style={{ fontSize: 11, color: 'var(--text-dim)', fontWeight: 700 }}>lần hoàn thành</div></div>
            </Card>
            <Card style={{ flex: 1, padding: 14, display: 'flex', alignItems: 'center', gap: 10 }}>
              <Icon name="fire" size={22} color="var(--coral)" />
              <div><div style={{ fontSize: 19, fontWeight: 900 }}>{user.longestStreak}</div><div style={{ fontSize: 11, color: 'var(--text-dim)', fontWeight: 700 }}>chuỗi dài nhất</div></div>
            </Card>
          </div>
        </div>

        <Card style={{ marginBottom: 14 }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 14 }}>
            <span style={{ fontSize: 14.5, fontWeight: 800 }}>Hoàn thành theo ngày</span>
            <span style={{ fontSize: 12, fontWeight: 700, color: 'var(--primary)' }}>Tuần này</span>
          </div>
          <BarChart data={WEEKLY_COMPLETION} labels={WEEK_LABELS} />
        </Card>

        <Card style={{ marginBottom: 14 }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 6 }}>
            <span style={{ fontSize: 14.5, fontWeight: 800 }}>Xu hướng 12 tuần</span>
            <span style={{ fontSize: 13, fontWeight: 800, color: 'var(--primary)', display: 'inline-flex', alignItems: 'center', gap: 3 }}><Icon name="chevU" size={15} />+18%</span>
          </div>
          <LineChart data={MONTH_TREND} />
        </Card>

        <LevelCard user={user} onOpen={onGamification} />

        <SectionLabel right={<span style={{ fontSize: 12.5, fontWeight: 700, color: 'var(--primary)' }}>Xem tất cả</span>}>Chuỗi dài nhất</SectionLabel>
        {best.map((h, i) => {
          const c = colorOf(h.color, dark);
          return (
            <Card key={h.id} pad={12} style={{ display: 'flex', alignItems: 'center', gap: 13, marginBottom: 10 }}>
              <div style={{ fontSize: 15, fontWeight: 900, color: 'var(--text-faint)', width: 18 }}>{i + 1}</div>
              <HabitTile icon={h.icon} color={h.color} dark={dark} size={42} />
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 15, fontWeight: 800 }}>{h.name}</div>
                <div style={{ fontSize: 12, color: 'var(--text-dim)', fontWeight: 600 }}>{h.rate}% hoàn thành</div>
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 4, fontSize: 15, fontWeight: 900, color: c.base }}>
                <Icon name="fire" size={17} />{h.streak}
              </div>
            </Card>
          );
        })}
      </Body>
    </div>
  );
}

function GamificationScreen({ dark, user, onClose }) {
  const got = BADGES.filter(b => b.got).length;
  return (
    <Screen>
      <AppBar onBack={onClose} title="Thành tựu" />
      <Body>
        <Card style={{ textAlign: 'center', background: 'linear-gradient(135deg, var(--amber), var(--coral))', border: 'none', color: '#fff', padding: 22, marginBottom: 16 }}>
          <div style={{ width: 76, height: 76, borderRadius: 26, background: 'rgba(255,255,255,0.22)', display: 'grid', placeItems: 'center', margin: '0 auto 12px', animation: 'pulseBadge 2.4s ease-in-out infinite' }}>
            <Icon name="trophy" size={42} color="#fff" />
          </div>
          <div style={{ fontSize: 22, fontWeight: 900 }}>Cấp độ {user.level}</div>
          <div style={{ fontSize: 13.5, fontWeight: 700, opacity: 0.92, marginBottom: 14 }}>{got}/{BADGES.length} huy hiệu · {user.xp} XP</div>
          <div style={{ height: 10, borderRadius: 99, background: 'rgba(255,255,255,0.28)', overflow: 'hidden', maxWidth: 240, margin: '0 auto' }}>
            <div style={{ height: '100%', width: `${user.xp / user.xpMax * 100}%`, background: '#fff', borderRadius: 99 }} />
          </div>
        </Card>

        <SectionLabel>Huy hiệu</SectionLabel>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
          {BADGES.map(b => {
            const c = colorOf(b.color, dark);
            return (
              <Card key={b.id} style={{ textAlign: 'center', padding: '18px 12px', opacity: b.got ? 1 : 0.55, position: 'relative' }}>
                {!b.got && <div style={{ position: 'absolute', top: 10, right: 10, color: 'var(--text-faint)' }}><Icon name="lock" size={15} /></div>}
                <div style={{ width: 58, height: 58, borderRadius: 20, background: b.got ? c.soft : 'var(--surface-3)', color: b.got ? c.base : 'var(--text-faint)', display: 'grid', placeItems: 'center', margin: '0 auto 10px' }}>
                  <Icon name={b.icon} size={30} stroke={1.9} />
                </div>
                <div style={{ fontSize: 13.5, fontWeight: 800 }}>{b.name}</div>
                <div style={{ fontSize: 11, color: 'var(--text-dim)', fontWeight: 600, marginTop: 3, lineHeight: 1.35 }}>{b.desc}</div>
              </Card>
            );
          })}
        </div>
      </Body>
    </Screen>
  );
}

Object.assign(window, { StatsScreen, GamificationScreen, BarChart, LineChart, LevelCard });
