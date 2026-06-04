// components.jsx — shared UI primitives
const { useState, useEffect, useRef } = React;

// Top app bar inside the phone
function AppBar({ title, subtitle, onBack, right, large, accent }) {
  return (
    <div style={{ padding: large ? '8px 20px 6px' : '10px 16px', display: 'flex', flexDirection: 'column', gap: 2 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, minHeight: 44 }}>
        {onBack && (
          <button onClick={onBack} aria-label="Back" style={{
            width: 40, height: 40, borderRadius: 99, border: 'none', cursor: 'pointer',
            background: 'var(--surface-2)', color: 'var(--text)', display: 'grid', placeItems: 'center', marginLeft: -4 }}>
            <Icon name="arrowL" size={20} />
          </button>
        )}
        <div style={{ flex: 1, minWidth: 0 }}>
          {!large && <div style={{ fontSize: 19, fontWeight: 800, letterSpacing: '-.01em' }}>{title}</div>}
          {!large && subtitle && <div style={{ fontSize: 12.5, color: 'var(--text-dim)', fontWeight: 600 }}>{subtitle}</div>}
        </div>
        {right}
      </div>
      {large && <div style={{ fontSize: 30, fontWeight: 900, letterSpacing: '-.02em', color: accent || 'var(--text)', lineHeight: 1.1 }}>{title}</div>}
      {large && subtitle && <div style={{ fontSize: 14, color: 'var(--text-dim)', fontWeight: 600 }}>{subtitle}</div>}
    </div>
  );
}

function IconBtn({ name, onClick, badge, size = 40, active }) {
  return (
    <button onClick={onClick} style={{
      width: size, height: size, borderRadius: 99, border: 'none', cursor: 'pointer', position: 'relative',
      background: active ? 'var(--primary-soft)' : 'var(--surface-2)', color: active ? 'var(--primary)' : 'var(--text)',
      display: 'grid', placeItems: 'center' }}>
      <Icon name={name} size={20} />
      {badge && <span style={{ position: 'absolute', top: 7, right: 7, width: 8, height: 8, borderRadius: 99,
        background: 'var(--coral)', border: '2px solid var(--surface)' }} />}
    </button>
  );
}

// Round colored icon tile for a habit
function HabitTile({ icon, color, dark, size = 48, r = 16 }) {
  const c = colorOf(color, dark);
  return (
    <div style={{ width: size, height: size, borderRadius: r, background: c.soft, color: c.base,
      display: 'grid', placeItems: 'center', flexShrink: 0 }}>
      <Icon name={icon} size={size * 0.5} stroke={2.1} />
    </div>
  );
}

// Circular progress ring with optional center content
function Ring({ value, max = 1, size = 54, stroke = 5, color = 'var(--primary)', track = 'var(--surface-3)', children }) {
  const r = (size - stroke) / 2;
  const circ = 2 * Math.PI * r;
  const pct = Math.max(0, Math.min(1, value / max));
  return (
    <div style={{ position: 'relative', width: size, height: size, flexShrink: 0 }}>
      <svg width={size} height={size} style={{ transform: 'rotate(-90deg)' }}>
        <circle cx={size/2} cy={size/2} r={r} fill="none" stroke={track} strokeWidth={stroke} />
        <circle cx={size/2} cy={size/2} r={r} fill="none" stroke={color} strokeWidth={stroke} strokeLinecap="round"
          strokeDasharray={circ} strokeDashoffset={circ * (1 - pct)} style={{ transition: 'stroke-dashoffset .6s cubic-bezier(.4,0,.2,1)' }} />
      </svg>
      <div style={{ position: 'absolute', inset: 0, display: 'grid', placeItems: 'center' }}>{children}</div>
    </div>
  );
}

// Animated check circle (the check-in control)
function CheckCircle({ done, color, dark, size = 34, onClick }) {
  const c = colorOf(color, dark);
  return (
    <button onClick={onClick} aria-label="toggle" style={{
      width: size, height: size, borderRadius: 99, cursor: 'pointer', flexShrink: 0,
      border: done ? 'none' : `2.5px solid var(--border-strong)`,
      background: done ? c.base : 'transparent', color: '#fff',
      display: 'grid', placeItems: 'center', transition: 'all .25s cubic-bezier(.34,1.56,.64,1)',
      transform: done ? 'scale(1)' : 'scale(1)' }}>
      <Icon name="check" size={size * 0.55} stroke={3} style={{ opacity: done ? 1 : 0, transform: done ? 'scale(1)' : 'scale(0.4)', transition: 'all .25s' }} />
    </button>
  );
}

function Button({ children, onClick, variant = 'primary', full, size = 'md', icon, style }) {
  const pad = size === 'lg' ? '15px 22px' : size === 'sm' ? '8px 14px' : '12px 18px';
  const fs = size === 'lg' ? 16.5 : size === 'sm' ? 13.5 : 15;
  const variants = {
    primary: { background: 'var(--primary)', color: 'var(--on-primary)', border: 'none', boxShadow: '0 4px 14px -4px var(--primary)' },
    soft: { background: 'var(--primary-soft)', color: 'var(--primary)', border: 'none' },
    ghost: { background: 'var(--surface-2)', color: 'var(--text)', border: 'none' },
    outline: { background: 'transparent', color: 'var(--text)', border: '1.5px solid var(--border-strong)' },
  };
  return (
    <button onClick={onClick} style={{
      ...variants[variant], padding: pad, fontSize: fs, fontWeight: 800, fontFamily: 'inherit',
      borderRadius: 99, cursor: 'pointer', width: full ? '100%' : 'auto',
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8, ...style }}>
      {icon && <Icon name={icon} size={fs + 3} stroke={2.4} />}{children}
    </button>
  );
}

function Card({ children, style, onClick, pad = 16 }) {
  return (
    <div onClick={onClick} style={{ background: 'var(--surface)', borderRadius: 'var(--radius-card)', padding: pad,
      boxShadow: 'var(--shadow-card)', border: '1px solid var(--border)', cursor: onClick ? 'pointer' : 'default', ...style }}>
      {children}
    </div>
  );
}

function Chip({ label, active, onClick, color }) {
  return (
    <button onClick={onClick} style={{
      padding: '8px 14px', borderRadius: 99, border: 'none', cursor: 'pointer', whiteSpace: 'nowrap',
      fontFamily: 'inherit', fontSize: 13.5, fontWeight: 700, flexShrink: 0,
      background: active ? (color || 'var(--primary)') : 'var(--surface-2)',
      color: active ? 'var(--on-primary)' : 'var(--text-dim)' }}>
      {label}
    </button>
  );
}

// Bottom sheet / modal
function Sheet({ open, onClose, children, height = 'auto', full }) {
  if (!open) return null;
  return (
    <div onClick={onClose} style={{ position: 'absolute', inset: 0, zIndex: 60, display: 'flex', alignItems: 'flex-end' }}>
      <div style={{ position: 'absolute', inset: 0, background: 'rgba(10,20,14,0.4)', animation: 'fadeUp .2s' }} />
      <div onClick={e => e.stopPropagation()} style={{ position: 'relative', width: '100%', background: 'var(--surface)',
        borderRadius: full ? 0 : '28px 28px 0 0', maxHeight: full ? '100%' : '86%', height: full ? '100%' : height,
        boxShadow: 'var(--shadow-pop)', animation: 'sheetUp .32s cubic-bezier(.32,.72,0,1)', overflow: 'auto', paddingBottom: 8 }}>
        {!full && <div style={{ display: 'grid', placeItems: 'center', padding: '12px 0 4px' }}>
          <div style={{ width: 38, height: 5, borderRadius: 99, background: 'var(--border-strong)' }} /></div>}
        {children}
      </div>
    </div>
  );
}

// Full-screen pushed screen wrapper with slide-in
function Screen({ children, animate = true }) {
  return (
    <div style={{ position: 'absolute', inset: 0, background: 'var(--bg)', display: 'flex', flexDirection: 'column', zIndex: 40 }}>
      {children}
    </div>
  );
}

// Scrollable content area
function Body({ children, style }) {
  return <div style={{ flex: 1, overflow: 'auto', padding: '4px 16px 24px', ...style }}>{children}</div>;
}

// Bottom navigation bar (Material 3 style)
function BottomNav({ tab, onTab, onAdd }) {
  const items = [
    { key: 'home', icon: 'home', label: 'Hôm nay' },
    { key: 'stats', icon: 'chart', label: 'Tiến độ' },
    { key: 'add', icon: 'plus', label: '', fab: true },
    { key: 'challenges', icon: 'trophy', label: 'Thử thách' },
    { key: 'journal', icon: 'pencil', label: 'Nhật ký' },
  ];
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-around', padding: '6px 8px 4px',
      background: 'var(--surface)', borderTop: '1px solid var(--border)' }}>
      {items.map(it => it.fab ? (
        <button key="add" onClick={onAdd} style={{ width: 54, height: 54, borderRadius: 20, border: 'none', cursor: 'pointer',
          background: 'var(--primary)', color: 'var(--on-primary)', display: 'grid', placeItems: 'center',
          boxShadow: '0 6px 18px -4px var(--primary)', transform: 'translateY(-6px)' }}>
          <Icon name="plus" size={26} stroke={2.6} />
        </button>
      ) : (
        <button key={it.key} onClick={() => onTab(it.key)} style={{ background: 'none', border: 'none', cursor: 'pointer',
          display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3, padding: '4px 10px', flex: 1 }}>
          <div style={{ padding: '3px 14px', borderRadius: 99, background: tab === it.key ? 'var(--primary-soft)' : 'transparent', transition: 'background .2s' }}>
            <Icon name={it.icon} size={22} stroke={tab === it.key ? 2.5 : 2} color={tab === it.key ? 'var(--primary)' : 'var(--text-faint)'} />
          </div>
          <span style={{ fontSize: 10.5, fontWeight: 700, color: tab === it.key ? 'var(--primary)' : 'var(--text-faint)' }}>{it.label}</span>
        </button>
      ))}
    </div>
  );
}

// Segmented control
function Segmented({ options, value, onChange }) {
  return (
    <div style={{ display: 'flex', background: 'var(--surface-2)', borderRadius: 99, padding: 4, gap: 2 }}>
      {options.map(o => (
        <button key={o.value} onClick={() => onChange(o.value)} style={{ flex: 1, border: 'none', cursor: 'pointer',
          fontFamily: 'inherit', fontSize: 13, fontWeight: 700, padding: '8px 6px', borderRadius: 99,
          background: value === o.value ? 'var(--surface)' : 'transparent', color: value === o.value ? 'var(--text)' : 'var(--text-dim)',
          boxShadow: value === o.value ? 'var(--shadow-card)' : 'none', transition: 'all .2s' }}>{o.label}</button>
      ))}
    </div>
  );
}

function Toast({ msg, icon }) {
  if (!msg) return null;
  return (
    <div style={{ position: 'absolute', bottom: 92, left: '50%', transform: 'translateX(-50%)', zIndex: 80,
      background: 'var(--text)', color: 'var(--bg)', padding: '11px 18px', borderRadius: 99, fontSize: 13.5, fontWeight: 700,
      display: 'flex', alignItems: 'center', gap: 8, boxShadow: 'var(--shadow-pop)', animation: 'popIn .3s', whiteSpace: 'nowrap' }}>
      {icon && <Icon name={icon} size={17} stroke={2.6} />}{msg}
    </div>
  );
}

function SectionLabel({ children, right }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', margin: '18px 2px 10px' }}>
      <span style={{ fontSize: 14.5, fontWeight: 800, color: 'var(--text)' }}>{children}</span>
      {right}
    </div>
  );
}

Object.assign(window, { AppBar, IconBtn, HabitTile, Ring, CheckCircle, Button, Card, Chip, Sheet, Screen, Body, BottomNav, Segmented, Toast, SectionLabel });
