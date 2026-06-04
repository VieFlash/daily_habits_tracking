// icons.jsx — thin outline icon set (stroke-based, currentColor)
const ICON_PATHS = {
  home: 'M3 10.5 12 3l9 7.5M5 9.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9.5',
  calendar: 'M7 3v3M17 3v3M4 8h16M5 5h14a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1Z',
  chart: 'M4 20V4M4 20h16M8 16v-4M12 16V8M16 16v-6',
  trophy: 'M7 4h10v4a5 5 0 0 1-10 0V4ZM7 5H4v2a3 3 0 0 0 3 3M17 5h3v2a3 3 0 0 1-3 3M9 14.5V18M15 14.5V18M8 21h8M10 18h4',
  flag: 'M5 21V4M5 4c3-1.5 5 1.5 8 0s5 0 5 0v8c-2 1-4-1-7 0s-6 0-6 0',
  plus: 'M12 5v14M5 12h14',
  check: 'M5 13l4 4L19 7',
  fire: 'M12 3c1 3 4 4.5 4 8a4 4 0 0 1-8 0c0-1.2.4-2 1-2.8C9 10 10 9 12 3ZM12 21a4 4 0 0 0 4-4',
  bell: 'M6 9a6 6 0 0 1 12 0c0 5 2 6 2 6H4s2-1 2-6ZM10 19a2 2 0 0 0 4 0',
  settings: 'M12 9a3 3 0 1 0 0 6 3 3 0 0 0 0-6ZM19 12a7 7 0 0 0-.1-1l2-1.5-2-3.4-2.3 1a7 7 0 0 0-1.7-1l-.3-2.6h-4l-.3 2.6a7 7 0 0 0-1.7 1l-2.3-1-2 3.4 2 1.5a7 7 0 0 0 0 2l-2 1.5 2 3.4 2.3-1a7 7 0 0 0 1.7 1l.3 2.6h4l.3-2.6a7 7 0 0 0 1.7-1l2.3 1 2-3.4-2-1.5c.1-.3.1-.7.1-1Z',
  user: 'M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8ZM5 20a7 7 0 0 1 14 0',
  water: 'M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11ZM9 14a3 3 0 0 0 3 3',
  book: 'M4 5a2 2 0 0 1 2-2h6v16H6a2 2 0 0 0-2 2V5ZM20 5a2 2 0 0 0-2-2h-6v16h6a2 2 0 0 1 2 2V5Z',
  run: 'M13 4a1.5 1.5 0 1 0 0-.01ZM9 21l2.5-5L9 13l1-5 4 2 2 2M6 11l3-1M14 12l3 1M11 16l-1 5',
  meditate: 'M12 6a1.5 1.5 0 1 0 0-.01ZM12 9c-1 3-4 4-7 5l1 2c2-.5 4-1.5 6-3 2 1.5 4 2.5 6 3l1-2c-3-1-6-2-7-5ZM12 9v3',
  moon: 'M20 13A8 8 0 0 1 9 4a7 7 0 1 0 11 9Z',
  sun: 'M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8ZM12 2v2M12 20v2M4 12H2M22 12h-2M5.6 5.6 4.2 4.2M19.8 19.8l-1.4-1.4M18.4 5.6l1.4-1.4M4.2 19.8l1.4-1.4',
  heart: 'M12 20s-7-4.5-9.5-9A5 5 0 0 1 12 6a5 5 0 0 1 9.5 5c-2.5 4.5-9.5 9-9.5 9Z',
  star: 'M12 3l2.6 5.6 6 .7-4.5 4 1.3 6L12 16.8 6.6 19.3l1.3-6-4.5-4 6-.7L12 3Z',
  target: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18ZM12 16a4 4 0 1 0 0-8 4 4 0 0 0 0 8ZM12 13a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z',
  edit: 'M5 19h2.5L18 8.5a1.8 1.8 0 0 0-2.5-2.5L5 16.5V19ZM14 7l3 3',
  trash: 'M5 7h14M10 7V5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v2M6 7l1 12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1l1-12M10 11v5M14 11v5',
  chevR: 'M9 6l6 6-6 6',
  chevL: 'M15 6l-6 6 6 6',
  chevD: 'M6 9l6 6 6-6',
  chevU: 'M6 15l6-6 6 6',
  close: 'M6 6l12 12M18 6 6 18',
  arrowL: 'M19 12H5M11 6l-6 6 6 6',
  arrowR: 'M5 12h14M13 6l6 6-6 6',
  sparkle: 'M12 3l1.8 5.2L19 10l-5.2 1.8L12 17l-1.8-5.2L5 10l5.2-1.8L12 3ZM19 16l.7 2 2 .7-2 .7-.7 2-.7-2-2-.7 2-.7.7-2Z',
  dumbbell: 'M6.5 6.5l11 11M4 9l2-2M4 9l1 1M6 7l-2 2M20 15l-2 2M20 15l-1-1M18 17l2-2M7.5 5.5 5.5 7.5M16.5 18.5l2-2',
  clock: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18ZM12 7v5l3 2',
  pencil: 'M4 20l1-4L16 5l3 3L8 19l-4 1ZM14 7l3 3',
  bulb: 'M9 18h6M10 21h4M12 3a6 6 0 0 0-3 11c.6.5 1 1 1 2h4c0-1 .4-1.5 1-2a6 6 0 0 0-3-11Z',
  leaf: 'M5 19c0-8 6-13 14-13 0 8-5 14-13 14-1 0-1-1-1-1ZM5 19s2-4 7-7',
  music: 'M9 18a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM9 12V4l10-2v8M9 6l10-2M19 16a3 3 0 1 0 0-.01ZM19 16V8',
  apple: 'M12 7c-2-2-5-1.5-5 2 0 4 3 7 5 7s5-3 5-7c0-3.5-3-4-5-2ZM12 7V4a2 2 0 0 1 2-2',
  bed: 'M3 18v-6a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6M3 14h18M3 18v2M21 18v2M7 10V7a1 1 0 0 1 1-1h3v4',
  pen: 'M4 20l1-4L16 5l3 3L8 19l-4 1Z',
  mountain: 'M3 20h18L14 7l-3 5-2-3-6 11ZM14 7l2.5-4 5 13',
  smile: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18ZM9 10h.01M15 10h.01M8.5 14a4 4 0 0 0 7 0',
  meh: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18ZM9 10h.01M15 10h.01M9 15h6',
  frown: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18ZM9 10h.01M15 10h.01M8.5 15a4 4 0 0 1 7 0',
  share: 'M16 6l-4-4-4 4M12 2v13M5 12v7a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-7',
  lock: 'M6 11h12a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1v-7a1 1 0 0 1 1-1ZM8 11V8a4 4 0 0 1 8 0v3',
  globe: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18ZM3 12h18M12 3c2.5 2.5 2.5 15 0 18M12 3c-2.5 2.5-2.5 15 0 18',
  palette: 'M12 21a9 9 0 1 1 0-18c4.5 0 8 3 8 6.5 0 2.5-2 3.5-4 3.5h-2a2 2 0 0 0-1 3.7c.3.4 0 1.3-1 1.3ZM7.5 12a1 1 0 1 0 0-.01ZM10 8a1 1 0 1 0 0-.01ZM15 8a1 1 0 1 0 0-.01Z',
  download: 'M12 3v12M8 11l4 4 4-4M5 21h14',
  logout: 'M14 4h4a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1h-4M10 12H3M7 8l-4 4 4 4',
  zap: 'M13 3 4 14h7l-1 7 9-11h-7l1-7Z',
  gift: 'M5 11h14v9a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1v-9ZM4 8h16v3H4V8ZM12 8v13M12 8S9 8 8 6.5 9 4 12 8ZM12 8s3 0 4-1.5S15 4 12 8Z',
  shield: 'M12 3l7 3v5c0 4-3 7-7 9-4-2-7-5-7-9V6l7-3ZM9 12l2 2 4-4',
  camera: 'M4 8h3l1.5-2h7L17 8h3a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1ZM12 16a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z',
  more: 'M6 12h.01M12 12h.01M18 12h.01',
  grid: 'M4 4h7v7H4zM13 4h7v7h-7zM4 13h7v7H4zM13 13h7v7h-7z',
  list: 'M8 6h13M8 12h13M8 18h13M3.5 6h.01M3.5 12h.01M3.5 18h.01',
  filter: 'M4 5h16l-6 7v6l-4 2v-8L4 5Z',
  search: 'M11 18a7 7 0 1 0 0-14 7 7 0 0 0 0 14ZM21 21l-5-5',
  coffee: 'M4 8h13v5a5 5 0 0 1-10 0V8ZM17 9h2a2 2 0 0 1 0 6h-2M6 3c0 1-1 1-1 2M10 3c0 1-1 1-1 2M14 3c0 1-1 1-1 2M5 21h14',
};

function Icon({ name, size = 24, stroke = 2, color = 'currentColor', style, fill = 'none' }) {
  const d = ICON_PATHS[name];
  if (!d) return null;
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill={fill} stroke={color}
      strokeWidth={stroke} strokeLinecap="round" strokeLinejoin="round"
      style={{ flexShrink: 0, display: 'block', ...style }}>
      {d.split('M').filter(Boolean).map((seg, i) => <path key={i} d={'M' + seg} />)}
    </svg>
  );
}

Object.assign(window, { Icon, ICON_PATHS });
