import 'dart:collection';
import 'dart:core';

import 'package:collection/collection.dart';

import '../common.dart';

/*
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
    | 0 | A |
    +---+---+
*/

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

/*
    +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+
*/
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

List<List<btn>> dp = [
  [btn.na, btn.u, btn.a],
  [btn.l, btn.d, btn.r]
];

Map<btn, P> dpm = {
  btn.na: P(0, 0),
  btn.u: P(0, 1),
  btn.a: P(0, 2),
  btn.l: P(1, 0),
  btn.d: P(1, 1),
  btn.r: P(1, 2),
};

Set<P> vdp = Set.from(dpm.values.whereNot((v) => v == P(0, 0)));

Map<dir, btn> dbm = {dir.u: btn.u, dir.d: btn.d, dir.l: btn.l, dir.r: btn.r};

List<String> ip = getLines();
List<List<int>> input = ip
    .map((l) => l.split("").map((s) => int.parse(s, radix: 16)).toList())
    .toList();

final P dpA = P(0, 2);
final P kpA = P(3, 2);

int hr0(P a, P b) => a.mhd(b);
Map<(List<P>, List<P>, int), (int, List<btn>)> __rab = HashMap(
    equals: (p0, p1) =>
        ListEquality<P>().equals(p0.$1, p1.$1) &&
        ListEquality<P>().equals(p0.$2, p1.$2) &&
        p0.$3 == p1.$3,
    hashCode: (p0) => Object.hashAll([
          Object.hashAll([p0.$1, p0.$2]),
          p0.$3
        ]));
(int, List<btn>) rab(List<P> a, List<P> b, l) =>
    __rab.putIfAbsent((a, b, l), () => _rab(a, b, l));

class St21 implements Comparable<St21> {
  final List<P> r;

  final List<btn> p;

  final int d;
  final St21? pr;

  St21(this.r, this.d, this.pr, this.p);

  @override
  int compareTo(St21 other) {
    return d.compareTo(other.d);
  }
}

P dbtn(dir d) => dpm[dbm[d]]!;

Map<(P, P), List<btn>> argh = {
  (P(0, 1), P(0, 1)): [],
  (P(0, 1), P(0, 2)): [btn.r],
  (P(0, 1), P(1, 0)): [btn.l, btn.d],
  (P(0, 1), P(1, 1)): [btn.d],
  (P(0, 1), P(1, 2)): [btn.d, btn.r],
  (P(1, 1), P(0, 1)): [btn.u],
  (P(1, 1), P(0, 2)): [btn.r, btn.u],
  (P(1, 1), P(1, 0)): [btn.l],
  (P(1, 1), P(1, 1)): [],
  (P(1, 1), P(1, 2)): [btn.r],
  (P(0, 2), P(0, 1)): [btn.l],
  (P(0, 2), P(0, 2)): [],
  (P(0, 2), P(1, 0)): [btn.d, btn.l, btn.l],
  (P(0, 2), P(1, 1)): [btn.d, btn.l],
  (P(0, 2), P(1, 2)): [btn.d],
  (P(1, 0), P(0, 1)): [btn.r, btn.u],
  (P(1, 0), P(0, 2)): [btn.r, btn.r, btn.u],
  (P(1, 0), P(1, 0)): [],
  (P(1, 0), P(1, 1)): [btn.r],
  (P(1, 0), P(1, 2)): [btn.r, btn.r],
  (P(1, 2), P(0, 1)): [btn.l, btn.u],
  (P(1, 2), P(0, 2)): [btn.u],
  (P(1, 2), P(1, 0)): [btn.l, btn.l],
  (P(1, 2), P(1, 1)): [btn.l],
  (P(1, 2), P(1, 2)): [],
};

(int, List<btn>) _rab(List<P> a, List<P> b, int l) {
  if (l == 1) {
    int ret = hr0(a.first, b.first);
    //print("$a -> $b: $ret moves");
    return (ret, argh[(a.first, b.first)]!);
  }
  PriorityQueue<St21> q = PriorityQueue()..add(St21(a, 0, null, []));
  Set<List<P>> seen = HashSet(
      equals: (la, lb) => ListEquality<P>().equals(la, lb),
      hashCode: Object.hashAll);

  while (!ListEquality<P>().equals(q.first.r, b)) {
    St21 c = q.removeFirst();
    if (seen.contains(c.r)) continue;
    seen.add(c.r);

    if (c.r.last == b.last) {
      (int, List<btn>) pt =
          rab(c.r.sublist(0, l - 1), b.sublist(0, l - 1), l - 1);
      q.add(St21(b, c.d + pt.$1, c, [...c.p, ...pt.$2]));
      continue;
    }

    for (dir d in dir.values) {
      P n = d + c.r.last;
      P dp = dbtn(d);
      if ((l == tl && !vkp.contains(n)) || (l < tl && !vdp.contains(n)))
        continue;
      int cost = c.d;
      List<P> np = [...List.filled(l - 2, dpA), dp, n];
      (int, List<btn>) r =
          rab(c.r.sublist(0, l - 1), np.sublist(0, l - 1), l - 1);
      cost += r.$1;
      // press A
      cost++;

      //print(cost);
      q.add(St21(np, cost, c, [...c.p, ...r.$2, btn.a]));
    }
  }
  //print("$a -> $b: ${q.first.d} moves");
  return (q.first.d, q.first.p);
}

int tl = 3;
(int, List<btn>) complexity(List<int> li) =>
    li.foldIndexed<(int, List<btn>)>((0, []), (i, p, e) {
      //print("Moving from ${i == 0 ? 'A' : li[i - 1]} to $li");
      (int, List<btn>) r = (rab(
          [...List.filled(tl - 1, dpA), i == 0 ? kpA : kpm[li[i - 1]]!],
          [...List.filled(tl - 1, dpA), kpm[e]!],
          tl));
      return ((p.$1 + 1 + r.$1), [...p.$2, ...r.$2, btn.a]);
    });
void d21(bool sub) {
  List<List<btn>> bp = [];
  List<String> input = getLines();
  List<List<int>> ii = input
      .map((i) => i.split("").map((c) => int.parse(c, radix: 16)).toList())
      .toList();
  print(ii.map(complexity).foldIndexed<int>(0, (i, p, e) {
    return p + e.$1 * int.parse(input[i].substring(0, input[i].length - 1));
  }));
}
