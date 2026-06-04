// screens-create.jsx — create / edit a habit
const { useState: useStateCreate } = React;

function ColorDot({ ck, active, onClick, dark }) {
  const c = colorOf(ck, dark);
  return (
    <button onClick={onClick} style={{ width: 40, height: 40, borderRadius: 99, border: active ? '3px solid var(--text)' : '3px solid transparent',
      cursor: 'pointer', padding: 0, background: 'transparent', display: 'grid', placeItems: 'center' }}>
      <span style={{ width: 28, height: 28, borderRadius: 99, background: c.base, display: 'block' }} />
    </button>
  );
}

function CreateHabit({ dark, onClose, onSave, editing }) {
  const [name, setName] = useStateCreate(editing ? editing.name : '');
  const [icon, setIcon] = useStateCreate(editing ? editing.icon : 'water');
  const [color, setColor] = useStateCreate(editing ? editing.color : 'green');
  const [freq, setFreq] = useStateCreate('daily');
  const [days, setDays] = useStateCreate([0,1,2,3,4,5,6]);
  const [target, setTarget] = useStateCreate(editing ? editing.target : 1);
  const [unit, setUnit] = useStateCreate(editing ? (editing.unit || '') : '');
  const [time, setTime] = useStateCreate(editing ? (editing.time === '—' ? '08:00' : editing.time) : '08:00');
  const [reminder, setReminder] = useStateCreate(editing ? editing.reminder : true);

  const toggleDay = d => setDays(days.includes(d) ? days.filter(x => x !== d) : [...days, d]);
  const c = colorOf(color, dark);

  return (
    <Screen>
      <AppBar onBack={onClose} title={editing ? 'Sửa thói quen' : 'Thói quen mới'}
        right={editing ? <IconBtn name="trash" onClick={onClose} /> : null} />
      <Body>
        {/* Live preview */}
        <Card style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 18, background: c.soft, border: 'none' }}>
          <HabitTile icon={icon} color={color} dark={dark} size={54} r={18} />
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 16.5, fontWeight: 800, color: 'var(--text)' }}>{name || 'Tên thói quen'}</div>
            <div style={{ fontSize: 12.5, fontWeight: 700, color: c.base }}>
              {freq === 'daily' ? 'Hằng ngày' : `${days.length} ngày / tuần`}{target > 1 ? ` · ${target} ${unit || 'lần'}` : ''}
            </div>
          </div>
        </Card>

        <label style={{ fontSize: 13, fontWeight: 800, color: 'var(--text-dim)', marginLeft: 2 }}>TÊN THÓI QUEN</label>
        <input value={name} onChange={e => setName(e.target.value)} placeholder="vd: Uống nước, Đọc sách..." style={{
          width: '100%', marginTop: 8, marginBottom: 18, padding: '14px 16px', borderRadius: 16, border: '1.5px solid var(--border-strong)',
          background: 'var(--surface)', color: 'var(--text)', fontSize: 15.5, fontWeight: 700, fontFamily: 'inherit', outline: 'none' }} />

        <label style={{ fontSize: 13, fontWeight: 800, color: 'var(--text-dim)', marginLeft: 2 }}>CHỌN ICON</label>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(6, 1fr)', gap: 8, margin: '10px 0 18px' }}>
          {ICON_CHOICES.slice(0, 12).map((ic, i) => (
            <button key={i} onClick={() => setIcon(ic)} style={{ aspectRatio: '1', borderRadius: 15, cursor: 'pointer',
              border: icon === ic ? `2px solid ${c.base}` : '1.5px solid var(--border)', background: icon === ic ? c.soft : 'var(--surface)',
              color: icon === ic ? c.base : 'var(--text-dim)', display: 'grid', placeItems: 'center' }}>
              <Icon name={ic} size={22} />
            </button>
          ))}
        </div>

        <label style={{ fontSize: 13, fontWeight: 800, color: 'var(--text-dim)', marginLeft: 2 }}>MÀU SẮC</label>
        <div style={{ display: 'flex', gap: 6, margin: '8px 0 20px' }}>
          {COLOR_CHOICES.map(ck => <ColorDot key={ck} ck={ck} active={color === ck} onClick={() => setColor(ck)} dark={dark} />)}
        </div>

        <label style={{ fontSize: 13, fontWeight: 800, color: 'var(--text-dim)', marginLeft: 2 }}>TẦN SUẤT</label>
        <div style={{ margin: '8px 0 14px' }}>
          <Segmented value={freq} onChange={setFreq} options={[{ value: 'daily', label: 'Hằng ngày' }, { value: 'weekly', label: 'Vài ngày / tuần' }]} />
        </div>
        {freq === 'weekly' && (
          <div style={{ display: 'flex', gap: 6, marginBottom: 18 }}>
            {WEEK_LABELS.map((lb, i) => (
              <button key={i} onClick={() => toggleDay(i)} style={{ flex: 1, padding: '11px 0', borderRadius: 14, cursor: 'pointer', fontFamily: 'inherit',
                border: 'none', fontSize: 13, fontWeight: 800, background: days.includes(i) ? 'var(--primary)' : 'var(--surface-2)',
                color: days.includes(i) ? 'var(--on-primary)' : 'var(--text-dim)' }}>{lb}</button>
            ))}
          </div>
        )}

        <label style={{ fontSize: 13, fontWeight: 800, color: 'var(--text-dim)', marginLeft: 2 }}>MỤC TIÊU MỖI NGÀY</label>
        <Card style={{ display: 'flex', alignItems: 'center', gap: 12, margin: '8px 0 18px', padding: 12 }}>
          <button onClick={() => setTarget(Math.max(1, target - 1))} style={{ width: 40, height: 40, borderRadius: 12, border: 'none', cursor: 'pointer', background: 'var(--surface-2)', color: 'var(--text)', fontSize: 22, fontWeight: 800 }}>−</button>
          <div style={{ flex: 1, textAlign: 'center' }}>
            <span style={{ fontSize: 22, fontWeight: 900 }}>{target}</span>
            <input value={unit} onChange={e => setUnit(e.target.value)} placeholder="đơn vị" style={{ width: 70, marginLeft: 8, padding: '6px 8px', borderRadius: 10, border: '1.5px solid var(--border)', background: 'var(--surface-2)', color: 'var(--text)', fontSize: 13, fontWeight: 700, fontFamily: 'inherit', textAlign: 'center', outline: 'none' }} />
          </div>
          <button onClick={() => setTarget(target + 1)} style={{ width: 40, height: 40, borderRadius: 12, border: 'none', cursor: 'pointer', background: c.base, color: '#fff', fontSize: 22, fontWeight: 800 }}>+</button>
        </Card>

        <label style={{ fontSize: 13, fontWeight: 800, color: 'var(--text-dim)', marginLeft: 2 }}>NHẮC NHỞ</label>
        <Card style={{ margin: '8px 0 10px', padding: 0 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: 14 }}>
            <div style={{ width: 38, height: 38, borderRadius: 12, background: 'var(--primary-soft)', color: 'var(--primary)', display: 'grid', placeItems: 'center' }}><Icon name="bell" size={20} /></div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14.5, fontWeight: 800 }}>Bật nhắc nhở</div>
              <div style={{ fontSize: 12, color: 'var(--text-dim)', fontWeight: 600 }}>Thông báo hằng ngày</div>
            </div>
            <Switch on={reminder} onClick={() => setReminder(!reminder)} />
          </div>
          {reminder && (
            <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: 14, borderTop: '1px solid var(--border)' }}>
              <div style={{ width: 38, height: 38, borderRadius: 12, background: 'var(--surface-2)', color: 'var(--text-dim)', display: 'grid', placeItems: 'center' }}><Icon name="clock" size={20} /></div>
              <div style={{ flex: 1, fontSize: 14.5, fontWeight: 800 }}>Thời gian</div>
              <input type="time" value={time} onChange={e => setTime(e.target.value)} style={{ padding: '8px 12px', borderRadius: 12, border: '1.5px solid var(--border)', background: 'var(--surface-2)', color: 'var(--text)', fontSize: 15, fontWeight: 800, fontFamily: 'inherit', outline: 'none' }} />
            </div>
          )}
        </Card>
      </Body>
      <div style={{ padding: '12px 16px', borderTop: '1px solid var(--border)', background: 'var(--surface)' }}>
        <Button full size="lg" icon="check" onClick={() => onSave({ name: name || 'Thói quen mới', icon, color, target, unit, time, reminder, freq: freq === 'daily' ? 'Hằng ngày' : `${days.length} lần / tuần` })}>
          {editing ? 'Lưu thay đổi' : 'Tạo thói quen'}
        </Button>
      </div>
    </Screen>
  );
}

function Switch({ on, onClick }) {
  return (
    <button onClick={onClick} style={{ width: 50, height: 30, borderRadius: 99, border: 'none', cursor: 'pointer', padding: 3,
      background: on ? 'var(--primary)' : 'var(--surface-3)', transition: 'background .25s', display: 'flex', justifyContent: on ? 'flex-end' : 'flex-start' }}>
      <span style={{ width: 24, height: 24, borderRadius: 99, background: '#fff', boxShadow: '0 1px 3px rgba(0,0,0,0.3)', transition: 'all .25s' }} />
    </button>
  );
}

Object.assign(window, { CreateHabit, Switch });
