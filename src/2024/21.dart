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

Map<(P, P), int> __hr0 = {};
Map<(P, P), int> __r0r1 = {};
Map<(P, P), int> __r1r2 = {};
Map<(P, P), int> __r2kp = {};

int hr0(P a, P b) => __hr0.putIfAbsent((a, b), () => _hr0(a, b));
int r0r1(P a, P b) => __r0r1.putIfAbsent((a, b), () => _r0r1(a, b));
int r1r2(P a, P b) => __r1r2.putIfAbsent((a, b), () => _r1r2(a, b));
int r2kp(P a, P b) => __r2kp.putIfAbsent((a, b), () => _r2kp(a, b));

class St21 implements Comparable<St21> {
  final List<P> r;
  final List<dir?> pd;

  final int d;
  final St21? pr;

  St21(this.r, this.pd, this.d, this.pr);

  @override
  int compareTo(St21 other) {
    return d.compareTo(other.d);
  }
}

int _hr0(P a, P b) {
  return 0;
}

int _r0r1(P a, P b) {
  return 0;
}

int _r1r2(P a, P b) {
  return 0;
}

int _r2kp(P a, P b) {
  PriorityQueue<St21> q = PriorityQueue()
    ..add(St21([dpA, dpA, kpA], [null, null, null], 0, null));

  Set<P> seen = {};
  while (q.first.r[2] != b) {
    St21 c = q.removeFirst();
    if (seen.contains(c.r[3])) continue;
  }
}

void bfs(P a, P b, int r, Set<P> v, int Function(St21 a, St21 b) calcD) {
  PriorityQueue<St21> q = PriorityQueue()
    ..add(St21([dpA, dpA, kpA], [null, null, null], 0, null));

  Set<P> seen = {};

  while (q.first.r[r] != b) {
    St21 c = q.removeFirst();
    P p = c.r[r];
    if (seen.contains(p)) continue;
    for (dir d in dir.values) {
      P n = d + p;
      if (!v.contains(n)) continue;
    }
  }
}

int complexity(String s) =>
    int.parse(s.substring(0, s.length - 1)) *
    s.split("").map((c) => int.parse(c, radix: 16)).foldIndexed(0,
        (i, p, e) => p + (i == s.length - 1 ? 0 : r2kp(kpm[e]!, kpm[i + 1]!)));
void d21(bool sub) {
  List<String> input = getLines();
  print(input.map(complexity).reduce((a, b) => a + b));
}
