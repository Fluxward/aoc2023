import 'dart:core';
import 'dart:math';

import 'package:collection/collection.dart';

import '../common.dart';

List<List<int>> kp = [
  [7, 8, 9],
  [4, 5, 6],
  [1, 2, 3],
  [11, 0, 10]
];

Map<int, P> kpm = Map.fromEntries(kp
    .mapIndexed((r, l) => l.mapIndexed((c, i) => MapEntry(i, P(r, c))))
    .flattened);

Set<P> vkp = Set.from(kpm.values.whereNot((v) => v == P(3, 0)));

enum btn {
  u(dir.u),
  l(dir.l),
  r(dir.r),
  d(dir.d),
  a(null),
  na(null);

  final dir? v;

  const btn(this.v);

  @override
  String toString() {
    switch (this) {
      case u:
        return "^";
      case l:
        return '<';
      case r:
        return '>';
      case d:
        return 'v';
      case a:
        return 'A';
      case na:
        return 'X';
    }
  }
}

Map<btn, P> dpm = {
  btn.na: P(0, 0),
  btn.u: P(0, 1),
  btn.a: P(0, 2),
  btn.l: P(1, 0),
  btn.d: P(1, 1),
  btn.r: P(1, 2),
};

final P dpA = P(0, 2);
final P kpA = P(3, 2);

class St21 implements Comparable<St21> {
  final P r;
  final int d;
  final P pd;

  St21(this.r, this.d, this.pd);

  @override
  int compareTo(St21 other) {
    return d.compareTo(other.d);
  }
}

Map<(P, P), List<btn>> argh = {
  (P(0, 1), P(0, 1)): [],
  (P(0, 1), P(0, 2)): [btn.r],
  (P(0, 1), P(1, 0)): [btn.d, btn.l],
  (P(0, 1), P(1, 1)): [btn.d],
  (P(0, 1), P(1, 2)): [btn.d, btn.r],
  (P(0, 2), P(0, 1)): [btn.l],
  (P(0, 2), P(0, 2)): [],
  (P(0, 2), P(1, 0)): [btn.d, btn.l, btn.l],
  (P(0, 2), P(1, 1)): [btn.l, btn.d],
  (P(0, 2), P(1, 2)): [btn.d],
  (P(1, 0), P(0, 1)): [btn.r, btn.u],
  (P(1, 0), P(0, 2)): [btn.r, btn.r, btn.u],
  (P(1, 0), P(1, 0)): [],
  (P(1, 0), P(1, 1)): [btn.r],
  (P(1, 0), P(1, 2)): [btn.r, btn.r],
  (P(1, 1), P(0, 1)): [btn.u],
  (P(1, 1), P(0, 2)): [btn.u, btn.r],
  (P(1, 1), P(1, 0)): [btn.l],
  (P(1, 1), P(1, 1)): [],
  (P(1, 1), P(1, 2)): [btn.r],
  (P(1, 2), P(0, 1)): [btn.l, btn.u],
  (P(1, 2), P(0, 2)): [btn.u],
  (P(1, 2), P(1, 0)): [btn.l, btn.l],
  (P(1, 2), P(1, 1)): [btn.l],
  (P(1, 2), P(1, 2)): [],
};

Map<(P, P, int), int> __cab = {};
int cab(P a, P b, int l) => __cab.putIfAbsent((a, b, l), () => _cab(a, b, l));
int _cab(P a, P b, int l) {
  if (l == 0) return argh[(a, b)]!.length;
  List<P> pts = [dpA, ...argh[(a, b)]!.map((b) => dpm[b]!), dpA];

  return pts.indexed
          .skip(1)
          .map((i) => cab(pts[i.$1 - 1], i.$2, l - 1) + 1)
          .reduce((a, b) => a + b) -
      1;
}

int rab(P a, P b, int l) {
  PriorityQueue<St21> q = PriorityQueue()..add(St21(a, 0, dpA));

  while (!(q.first.r == b && q.first.pd == dpA)) {
    St21 s = q.removeFirst();
    if (s.r == b) {
      q.add(St21(b, s.d + cab(s.pd, dpA, l - 1) + 1, dpA));
      continue;
    }

    for (btn b in [btn.r, btn.u, btn.d, btn.l]) {
      P n = b.v! + s.r;
      if (!vkp.contains(n)) continue;
      q.add(St21(n, s.d + cab(s.pd, dpm[b]!, l - 1) + 1, dpm[b]!));
    }
  }

  return q.first.d;
}

int complexity(List<int> li, int tl) => li.indexed
    .skip(1)
    .map((i) => rab(kpm[li[i.$1 - 1]]!, kpm[i.$2]!, tl))
    .reduce((a, b) => a + b);

void d21(bool sub) {
  print(getLines()
      .map((i) =>
          int.parse(i.substring(0, i.length - 1)) *
          complexity([10, ...i.split("").map((c) => int.parse(c, radix: 16))],
              sub ? 25 : 2))
      .reduce((a, b) => a + b));
}
