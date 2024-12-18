import 'dart:math';

import 'package:collection/collection.dart';

import '../common.dart';

List<P> input = getLines()
    .map((s) => s.split(",").map(int.parse))
    .map((i) => P(i.first, i.last))
    .toList();
Map<P, int> walls = {for (int i = 0; i < input.length; i++) input[i]: i};

final int size = 1 + input.fold(0, (p, e) => p = max(p, max(e.x, e.y)));

final P s = P(0, 0);
final P e = P(size - 1, size - 1);

class State {
  int d;
  P p;
  State? prev;

  State(this.p, this.d, this.prev);

  int get hn => e.mhd(p) - 1;
  int get gn => d;
  int get fn => hn + gn;

  @override
  bool operator ==(Object other) =>
      other is State && other.p == p && other.d == d;

  @override
  int get hashCode => Object.hashAll([p, d]);

  Iterable<State> get next =>
      dir.values.map((di) => State(di + p, d + 1, this)).where(
          (st) => st.p.x >= 0 && st.p.y >= 0 && st.p.x < size && st.p.y < size);

  @override
  String toString() => p.toString();
}

int search(int t) {
  PriorityQueue<State> q = PriorityQueue((a, b) => a.fn - b.fn);
  Set<P> seen = {};
  State st = State(s, 0, null);

  q.add(st);

  while (q.isNotEmpty && q.first.p != e) {
    State cur = q.removeFirst();
    if (!seen.add(cur.p)) continue;

    q.addAll(
        cur.next.where((ns) => !walls.containsKey(ns.p) || walls[ns.p]! >= t));
  }

  if (q.isEmpty) return -1;

  Set<P> path = {q.first.p};
  State c = q.first;
  for (c = q.first; c.prev != null; c = c.prev!) path.add(c.p);

  return path.length;
}

void d18(bool sub) {
  if (!sub) {
    print(search(1024) - 1);
    return;
  }

  int lo = 0;
  int hi = input.length;

  while (lo < hi)
    search((lo + hi) ~/ 2) < 0 ? hi = (lo + hi) ~/ 2 : lo = 1 + (lo + hi) ~/ 2;

  print(input[lo - 1]);
}
