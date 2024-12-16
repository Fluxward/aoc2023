import 'dart:collection';
import 'package:collection/collection.dart';
import '../common.dart';

d12(bool sub) {
  List<List<int>> garden = getLines().map((s) => s.codeUnits).toList();
  Set<P> visited = {};

  int total = 0;

  void bfs(P start, int type) {
    Queue<P> q = Queue()..add(start);
    Set<P> currentRegion = {};
    Map<P, Set<dir>> edgeSet = {};

    while (q.isNotEmpty) {
      P p = q.removeFirst();
      if (visited.contains(p) ||
          garden.at(p) != type ||
          (!currentRegion.add(p))) continue;
      edgeSet[p] = Set.of(dir.values);
      for (GridVec n in dir.values.map((d) => GridVec(d + p, d)).where((n) =>
          inBounds(n.pos.r, n.pos.c, garden) && garden.at(n.pos) == type)) {
        if (currentRegion.contains(n)) {
          edgeSet[p]!.remove(n.d);
          edgeSet[n]!.remove(n.d.rev);
        }
        q.add(n.pos);
      }
    }

    visited.addAll(currentRegion);
    if (currentRegion.length != 0) {
      total += sub
          ? currentRegion.length * numEdges(edgeSet)
          : currentRegion.length *
              edgeSet.values.map((s) => s.length).reduce((a, b) => a + b);
    }
  }

  for (int r = 0; r < garden.length; r++) {
    for (int c = 0; c < garden.length; c++) {
      bfs(P(r, c), garden[r][c]);
    }
  }

  print(total);
}

int numEdges(Map<P, Set<dir>> m) {
  int ret = 0;

  Set<GridVec> visited = {};

  Queue<GridVec> q = Queue<GridVec>.from(
      m.entries.map((me) => me.value.map((d) => GridVec(me.key, d))).flattened);

  while (q.isNotEmpty) {
    GridVec c = q.removeFirst();
    if (!visited.add(c)) continue;
    ret++;
    void trav(dir d) {
      for (P p = d + c.pos; m.containsKey(p) && m[p]!.contains(c.d); p = d + p)
        visited.add(GridVec(p, c.d));
    }

    [c.d.rt, c.d.lt].forEach((d) => trav(d));
  }

  return ret;
}
