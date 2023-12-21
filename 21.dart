import 'package:collection/collection.dart';

import 'common.dart';
import 'matrix.dart';

d21(bool s) {
  s ? b21() : a21();
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

  for (int i = 0; i < 64; i++) {
    cur = mark(cur, plot);
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

b21() {
  List<String> ls = getLines();
  BitMatrix plot = BitMatrix(ls.length, ls[0].length);
  P start = P(0, 0);
  ls.forEachIndexed((r, e) => e.split('').forEachIndexed((c, ch) {
        if (ch == 'S') start = P(r, c);
        plot[P(r, c)] = ch != '#';
      }));

  BitMatrix init = BitMatrix(plot.nr, plot.nc);
  init[start] = true;

  State cur = State(init);
  allStates[cur.hashCode] = cur;
}

Map<P, State> curIds = {};
Map<P, State> seenIds = {};
Map<P, State> seenExpanded = {};
State expandStateInner(BitMatrix plot, State s, P id) {
  if (seenExpanded.containsKey(id)) {
    return seenExpanded[id]!;
  }
  // mark this ID as seen
  seenIds[id] = s;
  BitMatrix next = BitMatrix(s.m.nr, s.m.nc);
  State ret = State(next);
  // add any already expanded neighbours
  for (dir d in dir.values) {
    if (seenExpanded[d + id] != null) {
      ret.next[d] = seenExpanded[d + id]!.hashCode;
    }
  }

  // output based convolution
  for (int r = 0; r < s.m.nr; r++) {
    for (int c = 0; c < s.m.nc; c++) {
      // skip rock
      if (!plot[P(r, c)]) continue;
      P cp = P(r, c);
      for (dir d in dir.values) {
        P dp = cp + d.p;
        if (!plot.inBounds(dp) || !s.m[dp]) continue;
        next[dp] = true;
        break;
      }
    }
  }

  for (MapEntry m in s.next.entries) {
    State n = m.value;
    BitArray a = n.m.side(m.key);
    switch (m.key) {
      case dir.u:
        for (int i = 0; i < a.length; i++) next[P(0, i)] |= a[i];
      case dir.l:
        for (int i = 0; i < a.length; i++) next[P(i, 0)] |= a[i];
      case dir.r:
        for (int i = 0; i < a.length; i++) next[P(i, plot.nc - 1)] |= a[i];
      case dir.d:
        for (int i = 0; i < a.length; i++) next[P(plot.nr - 1, i)] |= a[i];
    }
  }

  // see if we need to expand the adjacent states
  for (dir d in dir.values) {
    P nid = id + d.p;
    if (seenIds.containsKey(nid)) continue;
    bool adj = s.m.side(d)._data.fold<bool>(false, (p, e) => p |= e != 0);
    if (s.next[d] == null) {
      if (adj) {
        // make a new state to explore
        BitMatrix nm = BitMatrix(s.m.nr, s.m.nc);
        State ns = State(nm);
        for (dir nd in dir.values) {
          P ncid = nd + nid;
          if (curIds[ncid] != null) {
            ns.next[nd] = curIds[ncid]!.hashCode;
          }
        }
        ret.next[d] = expandStateMemoised(plot, ns, nid).hashCode;
      }
    } else {
      ret.next[d] =
          expandStateMemoised(plot, allStates[s.next[d]!]!, nid).hashCode;
    }
  }

  return seenExpanded[id] = ret;
}

Map<int, State> allStates = {};
Map<State, State> transitions = {};
State expandStateMemoised(BitMatrix m, State s, P id) {
  return transitions.putIfAbsent(s, () => expandStateInner(m, s, id));
}

class State {
  Map<dir, int> next = {};

  BitMatrix m;

  State(this.m);

  int get hashCode => Object.hashAll([next.entries, m]);
}

class BitArray {
  final int length;
  // dart ints are little endian.
  List<int> _data;

  BitArray(this.length) : _data = List.filled((length / 64).ceil(), 0);

  bool operator [](int i) => _data[i ~/ 64] & (1 << (i % 64)) != 0;

  void operator []=(int i, bool v) {
    int bit = i % 64;
    int e = i ~/ 64;

    _data[e] = (_data[e] & ~(1 << bit)) | ((v ? 1 : 0) << bit);
  }

  int get hashCode => Object.hashAll([length, _data]);

  bool operator ==(other) =>
      other is BitArray &&
      other.length == length &&
      _data.foldIndexed<bool>(true, (i, p, e) => p && other[i] == e);

  BitArray slice(int len, int start, int inc) {
    BitArray l = BitArray(len);
    for (int i = 0; i < len; i++) {
      l[i] = this[start + (i * inc)];
    }
    return l;
  }
}

class BitMatrix {
  final int nr;
  final int nc;

  final BitArray _data;
  final BitArray _dataT;

  BitMatrix(this.nr, this.nc)
      : _data = BitArray(nr * nc),
        _dataT = BitArray(nr * nc);

  bool operator [](P p) => _data[p.r * nc + p.c];

  void operator []=(P p, bool v) {
    _data[p.r * nc + p.c] = (v);
    _dataT[p.c * nr + p.r] = (v);
  }

  int get hashCode => Object.hashAll([nr, nc, _data]);

  bool operator ==(other) =>
      other is BitMatrix &&
      other.nr == nr &&
      other.nc == nc &&
      other._data == _data;

  BitArray side(dir d) => d == dir.d
      ? this.d
      : d == dir.u
          ? this.u
          : d == dir.l
              ? this.l
              : this.r;

  BitArray get l => vSlice(0);
  BitArray get r => vSlice(nc - 1);
  BitArray get u => hSlice(0);
  BitArray get d => hSlice(nr - 1);

  BitArray vSlice(int c) => _dataT.slice(nr, nr * c, 1);
  BitArray hSlice(int r) => _data.slice(nc, nc * r, 1);

  bool inBounds(P p) => p.r >= 0 && p.r < nr && p.c >= 0 && p.c < nc;
}
