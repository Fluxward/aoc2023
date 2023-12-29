import 'package:collection/collection.dart';

import 'bitset.dart';
import 'common.dart';
import 'matrix.dart';

d21(bool s) {
  s ? b21() : a21();
}

b21() {
  List<String> ls = getLines();
  // pad plot with edges
  BitMatrix plot = BitMatrix(ls.length + 2, ls[0].length + 2);
  P start = P(0, 0);
  ls.forEachIndexed((r, e) => e.split('').forEachIndexed((c, ch) {
        if (ch == 'S') start = P(r + 1, c + 1);
        plot[P(r + 1, c + 1)] = ch != '#';
      }));
  BitArray t = plot.hSlice(1);
  BitArray b = plot.hSlice(plot.nr - 2);

  for (int i = 1; i < plot.nc - 1; i++) {
    plot[P(0, i)] = b[i];
    plot[P(plot.nr - 1, i)] = t[i];
  }
  BitArray r = plot.vSlice(plot.nc - 2);
  BitArray l = plot.vSlice(1);
  for (int i = 1; i < plot.nr - 1; i++) {
    plot[P(i, 0)] = r[i];
    plot[P(i, plot.nc - 1)] = l[i];
  }

  BitMatrix init = BitMatrix(plot.nr, plot.nc);
  init[start] = true;

  Map<P, BitMatrix> front = {P(0, 0): init};
  Map<P, bool> steadyStates = {};

  const int loops = 1000000;
  int count = 0;
  Stopwatch sw = Stopwatch()..start();
  List<int> ts = [0, 0, 0];
  int averageMarkBm = 0;
  for (int i = 0; i < loops; i++) {
    int s = sw.elapsedMicroseconds;
    for (P k in front.keys) {
      front[k] = markBM(front[k]!, plot);
    }
    ts[0] = ((ts[0] * i) + sw.elapsedMicroseconds - s) ~/ (i + 1);
    averageMarkBm = ts[0] ~/ front.length;

    s = sw.elapsedMicroseconds;
    count = countFrontAndExpand(front, steadyStates);
    ts[1] = ((ts[1] * i) + sw.elapsedMicroseconds - s) ~/ (i + 1);

    s = sw.elapsedMicroseconds;
    count += countSteadyStates();
    ts[2] = ((ts[2] * i) + sw.elapsedMicroseconds - s) ~/ (i + 1);

    _7282parity != _7282parity;
    if (i % 100 == 0) {
      print(
          "$i, $count, $hits, ${front.length}, ${transitions.length}, ${steadyStates.length}");
      print("ambm: $averageMarkBm t: $ts");
    }
  }
  print("$count, $hits");
}

// number of steady states that have locs equal to _x when _xparity is true
int _7282 = 0;
int _7331 = 0;
bool _7282parity = true;

BitMatrix? _7282m;
BitMatrix? _7331m;

// steady state outputs:
// 7331
// 7282
int countFrontAndExpand(Map<P, BitMatrix> front, Map<P, bool> steadyStates) {
  List<P> toRemove = [];
  int count = 0;
  for (var me in front.entries) {
    BitMatrix bm = me.value;
    int r =
        bm.numTrue - bm.u.numTrue - bm.d.numTrue - bm.l.numTrue - bm.r.numTrue;
    if (r == 7331 || r == 7282) {
      bool is7282 = (r == 7282 && _7282parity) || (r == 7331 && !_7282parity);
      is7282 ? _7282++ : _7331++;
      toRemove.add(me.key);
      steadyStates[me.key] = is7282;

      if (_7282m == null && r == 7282) {
        _7282m =
            me.value.subMatrix(P(1, 1), P(me.value.nr - 1, me.value.nc - 1));
      }

      if (_7331m == null && r == 7331) {
        _7331m =
            me.value.subMatrix(P(1, 1), P(me.value.nr - 1, me.value.nc - 1));
      }
      // don't include this in the count.
      continue;
    }
    count += r;
  }

  // do expansion.
  // for each matrix:
  //  - copy outside edges to existing non-steady neighbours
  //  - create neighbour if not existing
  List<MapEntry<P, BitMatrix>> fl = front.entries.toList();
  for (var m in fl) {
    BitMatrix b = m.value;
    P p = m.key;

    for (dir d in dir.values) {
      P n = p + d.p;
      // skip steady states
      if (steadyStates.containsKey(n)) {
        continue;
      }

      switch (d) {
        case dir.u:
          if (b.hSlice(1).slice(b.nc - 2, 1, 1).isEmpty) continue;
        case dir.d:
          if (b.hSlice(b.nr - 2).slice(b.nc - 2, 1, 1).isEmpty) continue;
        case dir.l:
          if (b.vSlice(1).slice(b.nr - 2, 1, 1).isEmpty) continue;
        case dir.r:
          if (b.vSlice(b.nr - 2).slice(b.nr - 2, 1, 1).isEmpty) continue;
      }

      BitMatrix ne = front.putIfAbsent(n, () => BitMatrix(b.nr, b.nc));

      switch (d) {
        case dir.u:
          // copy top edge to bottom edge
          copyRow(b, ne, 1, b.nr - 1);
        case dir.d:
          // copy bottom edge to top edge
          copyRow(b, ne, b.nr - 2, 0);
        case dir.l:
          // copy left edge to right edge
          copyCol(b, ne, 1, b.nc - 1);
        case dir.r:
          // copy right edge to left edge
          copyCol(b, ne, b.nc - 2, 0);
      }
    }
  }

  toRemove.forEach((element) => front.remove(element));

  return count;
}

void copyCol(BitMatrix f, BitMatrix t, int fc, int tc) {
  for (int i = 1; i < f.nr - 1; i++) {
    t[P(i, tc)] = f[P(i, fc)];
  }
}

void copyRow(BitMatrix f, BitMatrix t, int fr, int tr) {
  for (int i = 1; i < f.nc - 1; i++) {
    t[P(tr, i)] = f[P(fr, i)];
  }
}

int countSteadyStates() => _7282parity
    ? (_7282 * 7282) + (_7331 * 7331)
    : (_7282 * 7331) + (_7331 * 7282);

Map<BitMatrix, BitMatrix> transitions = {};
int hits = 0;
BitMatrix markBM(BitMatrix cur, BitMatrix plot) {
  hits++;
  return transitions.putIfAbsent(cur, () => markBMInner(cur, plot));
}

BitMatrix markBMInner(BitMatrix cur, BitMatrix plot) {
  hits--;
  BitMatrix next = BitMatrix(plot.nr, plot.nc);
  for (int r = 0; r < cur.nr; r++) {
    for (int c = 0; c < cur.nc; c++) {
      if (!cur[P(r, c)]) continue;
      P cp = P(r, c);
      for (dir d in dir.values) {
        P dp = cp + d.p;
        if (plot.inBounds(dp) && plot[dp])
          next[dp] = plot.inBounds(dp) && plot[dp];
      }
    }
  }
  return next;
}

a21() {
  P start = P(0, 0);
  M<bool> plot = M(getLines()
      .mapIndexed((r, e) => e.split('').mapIndexed((c, ch) {
            if (ch == 'S') start = P(r, c);
            return ch != '#';
          }).toList())
      .toList());

  M<bool> cur =
      M(List.generate(plot.nr, (i) => List.generate(plot.nc, (i) => false)));
  cur.data[start.r][start.c] = true;

  int c = 0;
  for (int i = 0; i < 10000; i++) {
    cur = mark(cur, plot);

// 7331
// 7282
    int count = cur.data
        .fold<int>(0, (p, e) => p + e.fold<int>(0, (p, e) => p + (e ? 1 : 0)));
    if (count == 7331 || count == 7282) {
      c++;
      print("$i: ${i % 2 == 0 ? 'even' : 'odd'}: $count");
      if (c == 2) return;
    }
  }

  print("${cur.nr} ${cur.nc}");
  print(cur.data
      .fold<int>(0, (p, e) => p + e.fold<int>(0, (p, e) => p + (e ? 1 : 0))));
}

M<bool> mark(M<bool> cur, M<bool> plot) {
  M<bool> next =
      M(List.generate(plot.nr, (i) => List.generate(plot.nc, (i) => false)));
  for (int r = 0; r < cur.nr; r++) {
    for (int c = 0; c < cur.nc; c++) {
      if (!cur.at(P(r, c))) continue;
      P cp = P(r, c);
      for (dir d in dir.values) {
        P dp = cp + d.p;
        if (!plot.inBounds(dp) || !plot.at(dp)) continue;
        next[dp.r][dp.c] = true;
      }
    }
  }
  return next;
}
