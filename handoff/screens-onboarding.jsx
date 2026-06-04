// screens-onboarding.jsx — intro/onboarding flow
const { useState: useStateOb } = React;

function Onboarding({ onDone }) {
  const [step, setStep] = useStateOb(0);
  const slides = [
    { icon: 'leaf', color: 'green', title: 'Gieo một thói quen,\ngặt cả cuộc đời', body: 'Sprout giúp bạn xây dựng thói quen tốt mỗi ngày — nhẹ nhàng, vui và bền vững.' },
    { icon: 'fire', color: 'coral', title: 'Giữ chuỗi ngày,\nđốt cháy động lực', body: 'Theo dõi streak, xem heatmap tiến bộ và đừng để ngọn lửa tắt.' },
    { icon: 'trophy', color: 'amber', title: 'Lên level,\nmở khóa huy hiệu', body: 'Mỗi lần check-in là một điểm kinh nghiệm. Cùng bạn bè tham gia thử thách nhé!' },
  ];
  const s = slides[step];
  const c = colorOf(s.color, false);
  const last = step === slides.length - 1;
  return (
    <div style={{ position: 'absolute', inset: 0, background: 'var(--bg)', display: 'flex', flexDirection: 'column', zIndex: 50 }}>
      <div style={{ display: 'flex', justifyContent: 'flex-end', padding: '8px 18px' }}>
        <button onClick={onDone} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--text-dim)', fontWeight: 700, fontSize: 14, fontFamily: 'inherit' }}>Bỏ qua</button>
      </div>
      <div key={step} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 32px', textAlign: 'center' }}>
        <div style={{ width: 168, height: 168, borderRadius: 48, background: c.soft, color: c.base, display: 'grid', placeItems: 'center', marginBottom: 40, position: 'relative' }}>
          <Icon name={s.icon} size={84} stroke={1.8} />
          <div style={{ position: 'absolute', top: -10, right: -6, color: 'var(--amber)' }}><Icon name="sparkle" size={34} /></div>
        </div>
        <h1 style={{ fontSize: 27, fontWeight: 900, lineHeight: 1.18, margin: '0 0 14px', whiteSpace: 'pre-line', letterSpacing: '-.02em' }}>{s.title}</h1>
        <p style={{ fontSize: 15.5, color: 'var(--text-dim)', lineHeight: 1.5, margin: 0, fontWeight: 600, maxWidth: 300 }}>{s.body}</p>
      </div>
      <div style={{ padding: '0 28px 34px' }}>
        <div style={{ display: 'flex', gap: 7, justifyContent: 'center', marginBottom: 26 }}>
          {slides.map((_, i) => (
            <div key={i} style={{ height: 8, width: i === step ? 26 : 8, borderRadius: 99, background: i === step ? 'var(--primary)' : 'var(--border-strong)', transition: 'all .3s' }} />
          ))}
        </div>
        <Button full size="lg" icon={last ? 'sparkle' : undefined} onClick={() => last ? onDone() : setStep(step + 1)}>
          {last ? 'Bắt đầu ngay' : 'Tiếp tục'}
        </Button>
      </div>
    </div>
  );
}

Object.assign(window, { Onboarding });
