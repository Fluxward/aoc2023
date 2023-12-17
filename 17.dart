import 'dart:collection';

import 'common.dart';
import 'matrix.dart';
import 'package:collection/collection.dart';

d17(bool subset) {
  List<String> ip = getLines();
  M<int> m = M(List.generate(ip.length,
      (i) => List.generate(ip[0].length, (j) => int.parse(ip[i][j]))));
  P g = P(ip.length - 1, ip[0].length - 1);

  Map<St, int> seen = {};
  PriorityQueue<St> q = PriorityQueue((a, b) => a.priority(g) - b.priority(g))
    ..add(St(P(0, 1), 1, dir.r, m[0][1]))
    ..add(St(P(1, 0), 1, dir.d, m[1][0]));

  St c;
  for (c = q.removeFirst(); !done(c, g, subset); c = q.removeFirst()) {
    for (St s in getNext(m, c, subset)) {
      if (seen.containsKey(s) && seen[s]! <= s.l) continue;
      seen[s] = s.l;
      q.add(s);
    }
  }

  print(c.l);
}

class St {
  final P p;
  final int s;
  final dir d;
  final int l;

  St(this.p, this.s, this.d, this.l);

  int get hashCode => Object.hashAll([p, s, d]);

  bool operator ==(other) =>
      other is St && other.p == p && other.s == s && other.d == d;

  int priority(P g) => mh(p, g) + l;

  String toString() => "$p $s $d $l";
}

int mh(P a, P b) => (b.r - a.r).abs() + (b.c - a.c).abs();

bool done(St c, P g, bool s) => c.p == g && (!s || c.s >= 4);

List<St> getNext(M<int> m, St s, bool subset) {
  return [(s.d.rt), (s.d.lt), (s.d)]
      .map((d) {
        if ((subset && ((s.d == d && s.s + 1 > 10) || (s.d != d && s.s < 4))) ||
            (!subset && (s.d == d && s.s + 1 > 3))) return null;
        P n = d.p + s.p;
        return m.inBounds(n)
            ? St(n, s.d == d ? 1 + s.s : 1, d, s.l + m.at(n))
            : null;
      })
      .nonNulls
      .toList();
}
