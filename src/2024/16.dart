import 'package:collection/collection.dart';

import '../2023/21.dart';
import '../common.dart';

import '4.dart';

List<String> input = getLines();
List<List<bool>> walls =
    input.map((s) => s.split("").map((c) => c == '#').toList()).toList();

P s = input.pointOf('S');
P e = input.pointOf('E');

class State {
  GridVec g;
  int t;
  int d;

  State(this.g, this.t, this.d);

  int get hn => e.mhd(g.pos);
  
  int get gn => 1000 * t + d;

  int get fn => hn + gn;

  P get p => g.pos;
  State get walk => State(g.walk, t, d + 1);

  State get rt => State(g.rt, t + 1, d);
  State get lt => State(g.lt, t + 1, d);

  @override
  bool operator ==(Object other) =>
      other is State && other.g == g && other.t == t && other.d == d;
      
  @override
  int get hashCode => Object.hashAll([g, t, d]);

  @override
  String toString() => "$g: gn: $gn";
}

void d16(bool sub) {
  PriorityQueue<(State, State?)> q = PriorityQueue((a, b) => a.$1.fn - b.$1.fn);
  Set<GridVec> seen = {};
  Map<GridVec, (int, Set<State>)> anc = {};
  State st = State(GridVec(s, dir.r), 0, 0);

  q.add((st, null));

  while (q.first.$1.p != e) {
    var curS = q.removeFirst();
    State cur = curS.$1;
    seen.add(cur.g);
    (int, Set<State>) a = anc.putIfAbsent(cur.g, () => (cur.gn, {}));
    if (curS.$2 != null) {
      if (a.$1 > cur.gn) {
        anc[cur.g] = (cur.gn, {curS.$2!});
      } else if (a.$1 == cur.gn) {
        anc[cur.g]!.$2.add(curS.$2!);
      }
    }
    // check forward
    if (!walls.at(cur.walk.p)) q.add((cur.walk, cur));

    [cur.rt, cur.lt].where((tv) => !seen.contains(tv.g) && !seen.contains(tv.g.rev)).forEach((s) => q.add((s, cur)));
  }

  final int best = q.first.$1.gn;
  print(best);

  if (!sub) return;

  GridVec fv = q.first.$1.g;

  anc.putIfAbsent(fv, () => (0, {q.first.$2!}));

  Map<P, int> on = {};
  Set<State> prev(GridVec v) => anc[v]?.$2??{};

  void addOn(P p) => on[p] = 1 + on.putIfAbsent(p, () => 0);
  

  void bt(State s) {
    addOn(s.p);
    prev(s.g).forEach(bt);
  }

  bt(q.first.$1);

  print(on.length);

  //walls.mapIndexed((r, l) => l.mapIndexed((c, b) => b ? '#' : on.containsKey(P(r, c))? (on[P(r,c)]! < 10) ? on[P(r,c)] : 'X' : '.').join()).forEach(print);
  //walls.mapIndexed((r, l) => l.mapIndexed((c, b) => b ? '#' : dir.values.any((d) => seen.contains(GridVec(P(r,c), d))) ? 'O' : '.').join()).forEach(print);
}
