import 'package:collection/collection.dart';

import 'bitset.dart';
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
  Set<P> steadyStates;
}

int evenStates = 0;
int oddStates = 0;
bool evenState = true;

// steady state outputs:
// 7331
// 7282
int countFrontSteps(Map<P, BitMatrix> front) {
  // do count here
  List<P> toRemove = [];
  int count = 0;
  for (var me in front.entries) {
    BitMatrix bm = me.value;
    int r =
        bm.numTrue - bm.u.numTrue - bm.d.numTrue - bm.l.numTrue - bm.r.numTrue;
    if (r == 7331 || r == 7282) {
      bool isEven = (r == 7282 && evenState) || (r == 7331 && !evenState);
      isEven ? evenStates++ : oddStates++;
      toRemove.add(me.key);
    }
    count += r;
  }
  toRemove.forEach((element) => front.remove(element));
  evenState != evenState;
  return count;
}

Map<BitMatrix, BitMatrix> transitions = {};

BitMatrix markBM(BitMatrix cur, BitMatrix plot) =>
    transitions.putIfAbsent(cur, () => markBMInner(cur, plot));

BitMatrix markBMInner(BitMatrix cur, BitMatrix plot) {
  BitMatrix next = BitMatrix(plot.nr, plot.nc);
  for (int r = 0; r < cur.nr; r++) {
    for (int c = 0; c < cur.nc; c++) {
      if (!cur[P(r, c)]) continue;
      P cp = P(r, c);
      for (dir d in dir.values) {
        P dp = cp + d.p;
        if (!plot.inBounds(dp) || !plot[dp]) continue;
        next[dp] = true;
      }
    }
  }
  return next;
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

  int get numTrue => _data.fold<int>(0, (p, e) => p + e.popcount);

  bool get isEmpty => _data.fold<bool>(true, (p, e) => p && e == 0);

  bool get isNotEmpty => !isEmpty;
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

  int get numTrue => _data.numTrue;
}
