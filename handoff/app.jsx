// app.jsx — main controller: navigation, theme, tweaks
const { useState: useS, useEffect: useE } = React;

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "homeLayout": "card",
  "accent": "oklch(0.62 0.14 150)",
  "corner": "rounded",
  "dark": false
}/*EDITMODE-END*/;

const ACCENTS = [
  'oklch(0.62 0.14 150)', // green
  'oklch(0.66 0.13 235)', // sky
  'oklch(0.6 0.16 300)',  // violet
  'oklch(0.66 0.17 30)',  // coral
  'oklch(0.74 0.14 75)',  // amber
  'oklch(0.68 0.15 350)', // pink
];
const CORNERS = {
  rounded: { card: 26, lg: 22, md: 16, sm: 12 },
  soft:    { card: 18, lg: 15, md: 12, sm: 9 },
  sharp:   { card: 10, lg: 9, md: 8, sm: 6 },
};

function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  const theme = t.dark ? 'dark' : 'light';
  const dark = t.dark;

  const [scale, setScale] = useS(1);
  useE(() => {
    const fit = () => {
      const m = 28;
      const s = Math.min((window.innerWidth - m) / 412, (window.innerHeight - m) / 892, 1.15);
      setScale(s);
    };
    fit();
    window.addEventListener('resize', fit);
    return () => window.removeEventListener('resize', fit);
  }, []);

  const [view, setView] = useS('onboarding');
  const [tab, setTab] = useS('home');
  const [stack, setStack] = useS([]); // overlay screens
  const [sheet, setSheet] = useS(null); // 'journal' | 'notif'
  const [habits, setHabits] = useS(HABITS);
  const [toast, setToast] = useS(null);
  const [layout, setLayout] = useS(t.homeLayout);

  useE(() => { setLayout(t.homeLayout); }, [t.homeLayout]);

  const flash = (msg, icon) => { setToast({ msg, icon }); clearTimeout(window.__tt); window.__tt = setTimeout(() => setToast(null), 1800); };

  const push = (s) => setStack(st => [...st, s]);
  const pop = () => setStack(st => st.slice(0, -1));

  const toggle = (id) => {
    setHabits(hs => hs.map(h => {
      if (h.id !== id) return h;
      const done = !h.done;
      return { ...h, done, progress: done ? h.target : Math.max(0, h.progress === h.target ? h.target - 1 : h.progress), streak: done ? h.streak + 1 : Math.max(0, h.streak - 1) };
    }));
    const h = habits.find(x => x.id === id);
    if (h && !h.done) flash(`+10 XP · ${h.name} ✓`, 'sparkle');
  };

  const cycleLayout = () => {
    const order = ['card', 'list', 'grid'];
    const next = order[(order.indexOf(layout) + 1) % order.length];
    setLayout(next); setTweak('homeLayout', next);
    flash('Bố cục: ' + (next === 'card' ? 'Thẻ lớn' : next === 'list' ? 'Danh sách' : 'Lưới'), 'grid');
  };

  // accent override style
  const corner = CORNERS[t.corner] || CORNERS.rounded;
  const themeStyle = {
    '--primary': t.accent,
    '--primary-press': `color-mix(in oklch, ${t.accent}, #000 14%)`,
    '--primary-soft': `color-mix(in oklch, ${t.accent}, var(--surface) 86%)`,
    '--primary-soft-2': `color-mix(in oklch, ${t.accent}, var(--surface) 74%)`,
    '--radius-card': corner.card + 'px',
    '--radius-lg': corner.lg + 'px',
    '--radius-md': corner.md + 'px',
    '--radius-sm': corner.sm + 'px',
    height: '100%', position: 'relative', display: 'flex', flexDirection: 'column',
    background: 'var(--bg)', overflow: 'hidden',
  };

  const top = stack[stack.length - 1];

  const renderBase = () => {
    if (tab === 'home') return <HomeScreen habits={habits} dark={dark} layout={layout} user={USER}
      onToggle={toggle} onOpen={h => push({ type: 'detail', h })} onBell={() => setSheet('notif')}
      onProfile={() => push({ type: 'profile' })} onCycleLayout={cycleLayout} />;
    if (tab === 'stats') return <StatsScreen habits={habits} dark={dark} user={USER} onGamification={() => push({ type: 'gami' })} />;
    if (tab === 'challenges') return <ChallengesScreen dark={dark} />;
    if (tab === 'journal') return <JournalScreen dark={dark} onAdd={() => setSheet('journal')} />;
  };

  return (
    <div style={{ width: 412 * scale, height: 892 * scale, position: 'relative' }}>
      <div style={{ position: 'absolute', top: 0, left: 0, transform: `scale(${scale})`, transformOrigin: 'top left' }}>
      <AndroidDevice dark={dark}>
        <div className="app" data-theme={theme} style={themeStyle}>
          {view === 'onboarding' ? (
            <Onboarding onDone={() => setView('app')} />
          ) : (
            <>
              <div style={{ flex: 1, position: 'relative', overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
                {renderBase()}
              </div>
              <BottomNav tab={tab} onTab={setTab} onAdd={() => push({ type: 'create' })} />

              {/* overlay screens */}
              {top && top.type === 'create' && <CreateHabit dark={dark} onClose={pop}
                onSave={(data) => { setHabits(hs => [...hs, { id: 'h' + Date.now(), cat: 'Mới', goalText: data.freq, target: data.target || 1, progress: 0, streak: 0, best: 0, rate: 0, done: false, weekDone: [0,0,0,0,0,0,0], ...data }]); pop(); flash('Đã tạo thói quen mới 🌱', 'check'); }} />}
              {top && top.type === 'detail' && <HabitDetail h={habits.find(x => x.id === top.h.id) || top.h} dark={dark} onClose={pop}
                onEdit={() => push({ type: 'create', editing: top.h })} onToggle={toggle} />}
              {top && top.type === 'gami' && <GamificationScreen dark={dark} user={USER} onClose={pop} />}
              {top && top.type === 'profile' && <ProfileScreen dark={dark} user={USER} onClose={pop}
                theme={theme} onTheme={() => setTweak('dark', !t.dark)} onGamification={() => push({ type: 'gami' })} />}

              {/* sheets */}
              <AddJournalSheet open={sheet === 'journal'} onClose={() => setSheet(null)} dark={dark}
                onSave={() => { setSheet(null); flash('Đã lưu nhật ký ✍️', 'check'); }} />
              <NotificationsSheet open={sheet === 'notif'} onClose={() => setSheet(null)} dark={dark} />

              <Toast msg={toast && toast.msg} icon={toast && toast.icon} />
            </>
          )}

          <TweaksPanel>
            <TweakSection label="Giao diện" />
            <TweakToggle label="Chế độ tối" value={t.dark} onChange={v => setTweak('dark', v)} />
            <TweakColor label="Màu chủ đạo" value={t.accent} options={ACCENTS} onChange={v => setTweak('accent', v)} />
            <TweakRadio label="Bo góc" value={t.corner} options={['rounded', 'soft', 'sharp']} onChange={v => setTweak('corner', v)} />
            <TweakSection label="Trang chủ" />
            <TweakRadio label="Bố cục thói quen" value={t.homeLayout} options={['card', 'list', 'grid']}
              onChange={v => { setTweak('homeLayout', v); setLayout(v); }} />
          </TweaksPanel>
        </div>
      </AndroidDevice>
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
