import 'dart:math' as math;

/// Number of weeks shown in the contribution heatmap.
const kHeatmapWeeks = 18;

/// Deterministic pseudo-random in [0, 1) matching the JS `seeded()` helper, so
/// the heatmap and mini-calendar render identically to the original mock.
double seeded(double n) {
  final x = math.sin(n) * 10000;
  return x - x.floorToDouble();
}

/// 18 weeks × 7 days of heatmap intensity values (0–4) — `makeHeatmap` in
/// data.jsx.
List<int> buildHeatmap() {
  final out = <int>[];
  const density = 1;
  for (var i = 0; i < kHeatmapWeeks * 7; i++) {
    final r = seeded(i * 2.3 + density * 7);
    var v = 0;
    if (r > 0.78) {
      v = 4;
    } else if (r > 0.62) {
      v = 3;
    } else if (r > 0.45) {
      v = 2;
    } else if (r > 0.3) {
      v = 1;
    }
    out.add(v);
  }
  return out;
}
