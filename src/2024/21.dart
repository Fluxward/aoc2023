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
    switch(this) {
      case u: return "^";
      case l: return '<';
      case r: return '>';
      case d: return 'v';
      case a: return 'A';
      case na: return 'X';
    }
  }
}

List<List<btn>> dp = [
  [btn.na, btn.u, btn.a],
  [btn.l, btn.d, btn.r]
];

Map<btn, P> dpm = Map.fromEntries(dp
    .mapIndexed((r, l) => l.mapIndexed((c, i) => MapEntry(i, P(r, c))))
    .flattened);

Set<P> vdp = Set.from(dpm.values.whereNot((v) => v == P(0, 0)));

Map<dir, btn> dbm = {dir.u: btn.u, dir.d: btn.d, dir.l: btn.l, dir.r: btn.r};

List<String> ip = getLines();
List<List<int>> input = ip
    .map((l) => l.split("").map((s) => int.parse(s, radix: 16)).toList())
    .toList();

final P dpA = P(0, 2);
final P kpA = P(3, 2);

int hr0(P a, P b) => a.mhd(b);
Map<(List<P>, List<P>, int), int> __rab = HashMap(
    equals: (p0, p1) =>
        ListEquality<P>().equals(p0.$1, p1.$1) &&
        ListEquality<P>().equals(p0.$2, p1.$2) &&
        p0.$3 == p1.$3,
    hashCode: (p0) => Object.hashAll([Object.hashAll([p0.$1, p0.$2]), p0.$3]));
int rab(List<P> a, List<P> b, l) =>
    __rab.putIfAbsent((a, b, l), () => _rab(a, b, l));

class St21 implements Comparable<St21> {
  final List<P> r;

  final int d;
  final St21? pr;

  St21(this.r, this.d, this.pr);

  @override
  int compareTo(St21 other) {
    return d.compareTo(other.d);
  }
}

P dbtn(dir d) => dpm[dbm[d]]!;

int _rab(List<P> a, List<P> b, int l) {
  if (l == 1) return hr0(a.first, b.first);
  PriorityQueue<St21> q = PriorityQueue()..add(St21(a, 0, null));
  Set<List<P>> seen = HashSet(
      equals: (la, lb) => ListEquality<P>().equals(la, lb),
      hashCode: Object.hashAll);

  while (!ListEquality<P>().equals(q.first.r, b)) {
    St21 c = q.removeFirst();
    if (seen.contains(c.r)) continue;
    seen.add(c.r);

    if (c.r.last == b.last) {
      q.add(St21(
          b,
          c.d +
               rab(c.r.sublist(0, l - 1), b.sublist(0, l - 1), l - 1),
          c));
      continue;
    }

    for (dir d in dir.values) {
      P n = d + c.r.last;
      P dp = dbtn(d);
      if ((l == 3 && !vkp.contains(n)) || (l < 3 && !vdp.contains(n))) continue;
      int cost = c.d;
      List<P> np = [...List.filled(l - 2, dpA), dp, n];
      cost += rab(c.r.sublist(0, l - 1), np.sublist(0, l - 1), l - 1);
      // press A
      cost++;

      //print(cost);
      q.add(St21(np, cost, c));
    }
  }
  print("$a -> $b: ${q.first.d} moves");
  return q.first.d;
}

int complexity(String s) =>
    //int.parse(s.substring(0, s.length - 1)) *
    s.split("").map((c) => int.parse(c, radix: 16)).foldIndexed(
        0,
        (i, p, e) =>
            p + 1 +
            (rab([dpA, dpA, i == 0 ? kpA : kpm[i - 1]!], [dpA, dpA, kpm[e]!],
                3)));
void d21(bool sub) {
  List<String> input = getLines();
  //print(input.map(complexity).reduce((a, b) => a + b));
  input.map(complexity).forEach(print);
}