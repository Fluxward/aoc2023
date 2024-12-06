import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';

import '../bitstuff.dart';
import '../common.dart';

List<String> trail = getLines();

int nr = trail.length;
int nc = trail[0].length;
P fin = P(nr - 1, nc - 2);
BitArray visited = BitArray(nr * nc);
bool ignoreSlope = false;
int steps = 0;
P n = P(0, 1);
List<P> forks = [
  for (int r = 0; r < nr; r++)
    for (int c = 0; c < nc; c++)
      if (isFork(r, c)) P(r, c)
]
  ..add(n)
  ..add(fin);
Map<P, int> forkIndices = {for (int i = 0; i < forks.length; i++) forks[i]: i};
List<Map<P, int>> dist = List.generate(forks.length, (_) => {});

Future<void> d23(bool sub) async {
  visited[1] = true;
  ignoreSlope = sub;

  sub ? b() : maxDfs();
  print(maxS);
}

void b() {
  Stopwatch sw = Stopwatch()..start();
  int exp = 0;
  forks.forEachIndexed((i, e) => getAdj(e, i));
  dist.forEachIndexed((i, element) {
    print("${forks[i]} -> $element");
  });
  int dfs(int c, Set<int> visited, int steps) {
    if (exp % 1000000 == 0) {
      print("${sw.elapsed}: ${exp}: $c, $steps");
    }
    exp++;
    if (c == forks.length - 1) return steps;
    int mS = 0;
    Map<P, int> next = dist[c];

    for (P p in next.keys) {
      int pi = forkIndices[p]!;
      if (visited.contains(pi)) continue;
      int d = steps + dist[c][forks[pi]]!;

      mS = max(mS, dfs(pi, Set.of(visited)..add(pi), d));
    }

    return mS;
  }

  int sI = forks.length - 2;
  print(dfs(sI, {sI}, 0));
  print(sw.elapsed);
}

void getAdj(P p, int pi) {
  Queue<(P, int)> q = Queue();
  Set<P> visited = {};
  q.add((p, 0));
  while (q.isNotEmpty) {
    int steps = q.first.$2;
    P c = q.removeFirst().$1;
    if (!visited.add(c)) continue;
    if (c != p && forkIndices.containsKey(c)) {
      dist[pi][c] = steps;
      continue;
    }
    q.addAll(getNext(c)
        .where((e) => inBoundsString(e.r, e.c, trail))
        .map((e) => (e, steps + 1)));
  }
}

List<P> getNext(p) {
  List<P> next = [];
  for (dir d in dir.values) {
    P n = p + d.p;
    if (!inBoundsString(n.r, n.c, trail) || trail[n.r][n.c] == '#') {
      continue;
    }
    next.add(n);
  }
  return next;
}

bool isFork(int r, int c) {
  return getNext(P(r, c)).length > 2;
}

int maxS = 0;
void maxDfs() {
  if (n == fin) {
    maxS = max(maxS, steps);
    return;
  }

  if (!ignoreSlope) {
    dir? slope;
    switch (trail[n.r][n.c]) {
      case '^':
        slope = dir.u;
      case '>':
        slope = dir.r;
      case 'v':
        slope = dir.d;
      case '<':
        slope = dir.l;
    }

    if (slope != null) {
      n += slope.p;
      if (visited[n.r * nc + n.c]) {
        n -= slope.p;
        return;
      } // invalid path
      visited[n.r * nc + n.c] = true;
      steps++;
      maxDfs();
      visited[n.r * nc + n.c] = false;
      steps--;
      n -= slope.p;
    }
  }

  for (dir d in dir.values) {
    n += d.p;
    if (!inBoundsString(n.r, n.c, trail) ||
        visited[n.r * nc + n.c] ||
        trail[n.r][n.c] == '#') {
      n -= d.p;
      continue;
    }
    visited[n.r * nc + n.c] = true;
    steps++;
    maxDfs();
    steps--;
    visited[n.r * nc + n.c] = false;
    n -= d.p;
  }
}
