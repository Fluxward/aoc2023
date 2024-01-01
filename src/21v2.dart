import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'dart:math';

import 'package:collection/collection.dart';

import 'bitstuff.dart';
import 'common.dart';
import 'debug.dart';

int nr = 0;
int nc = 0;

SequenceNode sqn = SequenceNode();
late AlignedBitMatrix plot;

void do21b() async {
  List<String> ls = getLines();
  nr = ls.length;
  nc = ls[0].length;
  plot = AlignedBitMatrix(ls.length, ls[0].length);

  ({int r, int c})? start;
  ls.forEachIndexed((r, e) => e.split('').forEachIndexed((c, ch) {
        if (ch == 'S') start = (r: r, c: c);
        plot[r][c] = ch != '#';
      }));

  // stage 1. characterise grids/steady states and prep tree
  initSqnTree(start);

  PaddedGrid init = PaddedGrid(nr, nc, 0, Sequence());
  init.seq.add(1);
  init[start!] = true;

  Map<P, PaddedGrid> map = {P(0, 0): init};
  Map<P, int> ids;
  Set<Cross> cs = {};

  SendPort sp = await getTimerSendPort(Duration(milliseconds: 500));

  for (int i = 0; i < 1000; i++) {
    sp.send(i + 1);
  }
  cleanup();
}

class Cross {
  int? u;
  int? d;
  int? l;
  int? r;
  int? id;

  int get hashCode => Object.hashAll([u, d, l, r, id]);
  bool operator ==(other) =>
      other is Cross &&
      u == other.u &&
      d == other.d &&
      l == other.l &&
      r == other.r;
}

void initSqnTree(var start) async {
  PaddedGrid init = PaddedGrid(nr, nc, 0, Sequence());
  init.seq.add(1);
  init[start!] = true;

  // stage 1. characterise grids/steady states
  Map<P, PaddedGrid> map = {P(0, 0): init};
  Map<P, (Sequence, int)> patterns = {};
  Set<Sequence> stableSequences = HashSet();

  for (int i = 0; i < 500; i++) {
    Set<P> toCopy = {};
    for (var mE in map.entries) {
      var s = mE.value.evolve(plot);

      if (s.$2.isNotEmpty) {
        for (dir d in s.$2) {
          toCopy.add(mE.key + d.p);
        }
      }

      map[mE.key] = s.$1;
      // update this pattern
      patterns[mE.key] = (s.$1.seq, mE.value.birthStep);
      if (s.$1.seq.stable && stableSequences.add(s.$1.seq)) {
        print("found sequence at ${i + 1}: ${s.$1.seq.d}");
        sqn.add(s.$1.seq, 0);
      }
    }

    for (P p in toCopy) {
      PaddedGrid pg =
          map.putIfAbsent(p, () => PaddedGrid(nr, nc, i + 1, Sequence()));
      for (dir d in dir.values) {
        P n = p + d.p;

        PaddedGrid? ng = map[n];
        if (ng == null) continue;

        switch (d) {
          case dir.u:
          case dir.d:
            ng.m[d == dir.u ? 1 : nr]
                .fastCopyWithOffset(pg.m[d == dir.u ? 0 : nr + 1], nc, 1, 1);
          case dir.l:
          case dir.r:
            int cf = d == dir.l ? 1 : nc;
            int ct = d == dir.l ? 0 : nc + 1;
            for (int i = 1; i <= nr; i++) {
              pg.m[i][ct] = ng.m[i][cf];
            }
        }
      }
    }
  }
}

class SequenceNode {
  Map<int, SequenceNode> next = {};

  int? id;

  Sequence? leaf;

  int numLeaves = 0;

  void add(Sequence s, int depth) {
    numLeaves++;
    if (s.d.length <= depth) {
      leaf = s;
      return;
    }
    SequenceNode n = next.putIfAbsent(s.d[depth], () => SequenceNode());
    n.add(s, depth + 1);
  }

  int mark([int nid = 0]) {
    if (numLeaves == 1) {
      id = nid;
      _getSequence();
      return nid + 1;
    }

    int nextId = nid;
    for (SequenceNode s in next.values) {
      nextId = s.mark(nextId);
    }
    return nextId;
  }

  Sequence? findSequence(List<int> data, int depth) {
    return (depth >= data.length)
        ? null
        : leaf ?? next[data[depth]]?.findSequence(data, depth + 1);
  }

  Sequence? _getSequence() {
    if (numLeaves > 1) return null;

    if (leaf != null) return leaf;

    leaf = next.values.first._getSequence();

    return leaf;
  }
}

class Sequence {
  List<int> d = [];
  Set<int> ud = {};

  bool stable = false;

  void add(int data) {
    if (stable) return;
    d.add(data);

    if (ud.contains(data)) {
      SuffixTree st = SuffixTree(d);
      int lcp = st.root.lcp();

      if (lcp > 1) {
        stable = true;
        return;
      }
    }

    ud.add(data);
  }

  int get hashCode => Object.hashAll(d);

  bool operator ==(other) =>
      other is Sequence &&
      other.d.length == d.length &&
      d.firstWhereIndexedOrNull(
              (index, element) => other.d.elementAt(index) != element) ==
          null;
}

class PaddedGrid {
  final int nr;
  final int nc;
  final AlignedBitMatrix m;
  final Sequence seq;
  final int birthStep;

  PaddedGrid(this.nr, this.nc, this.birthStep, this.seq)
      : m = AlignedBitMatrix(nr + 2, nc + 2);

  (PaddedGrid, Set<dir>) evolve(AlignedBitMatrix plot) {
    PaddedGrid next = PaddedGrid(nr, nc, birthStep + 1, seq);
    Set<dir> hasNext = {};

    int nIntsC = nc.ceilDiv(64);
    for (int r = 0; r < nr; r++) {
      int bits = 0;
      for (int ch = 0; ch < nIntsC; ch++) {
        // do left and right
        int left = m[r + 1].data[ch];
        int right = m[r + 1].getIntAt(bits + 2);

        // do up and down
        int up = m[r].getIntAt(bits + 1);
        int down = m[r + 2].getIntAt(bits + 1);

        int res = plot[r].data[ch] & (left | right | up | down);
        next.m.rows[r + 1].copySubIntFrom(res, min(nc - bits, 64), bits + 1);
        bits += min(nc - bits, 64);

        if (ch == 0 && next.m[r + 1][1]) {
          hasNext.add(dir.l);
        }
        if (ch == nIntsC - 1 && next.m[r + 1][bits]) {
          hasNext.add(dir.r);
        }
      }

      if (r == 0 && next.m[1].numTrue > 0) {
        hasNext.add(dir.u);
      }

      if (r == nr - 1 && next.m[nr].numTrue > 0) {
        hasNext.add(dir.d);
      }
    }

    next.seq.add(next.bitCount);

    return (next, hasNext);
  }

  int get bitCount =>
      m.countTrue(startCol: 1, startRow: 1, endRow: nr + 1, endCol: nc + 1);

  bool operator [](({int r, int c}) p) => m[p.r + 1][p.c + 1];

  void operator []=(({int r, int c}) p, bool b) => m[p.r + 1][p.c + 1] = b;
}

class SuffixTree {
  SuffixNode root = SuffixNode();

  SuffixTree(List<int> data) {
    for (int i = data.length - 1; i >= 0; i--) {
      root.add(data, i);
    }
  }

  String toString() {
    StringBuffer sb = StringBuffer();
    root.toStringBuffer(sb);
    return sb.toString();
  }

  bool hasRepeat() {
    return root.c.values.fold(false, (p, e) => p || e.hasCommonPrefix() > 0);
  }
}

class SuffixNode {
  Map<int?, SuffixNode> c = {};
  int? children;

  void add(List<int> data, int start) {
    if (start == data.length + 1) {
      return;
    }

    SuffixNode s =
        c.putIfAbsent(data.elementAtOrNull(start), () => SuffixNode());
    s.add(data, start + 1);
  }

  void toStringBuffer(StringBuffer sb, [int depth = 0]) {
    for (var me in c.entries) {
      sb.write("${' ' * depth}${me.key}: ${countChildren()}\n");
      me.value.toStringBuffer(sb, depth + 1);
    }
  }

  int countChildren() {
    if (children == null) {
      children =
          c.entries.fold<int>(0, (p, e) => 1 + p + e.value.countChildren());
    }
    return children!;
  }

  int hasCommonPrefix() {
    if (c.isEmpty) return -1;

    if (c.length > 1) return c.length;

    return c.values.fold(-1, (p, e) => e.hasCommonPrefix());
  }

  int lcp([int depth = 0]) {
    if (c.isEmpty) return -1;

    int explore = c.values.fold<int>(-1, (p, e) => max(p, e.lcp(depth + 1)));

    return c.values.length > 1 ? max(explore, depth) : explore;
  }
}
