import 'dart:math';

import 'bitstuff.dart';
import 'common.dart';

List<String> trail = getLines();

int nr = trail.length;
int nc = trail[0].length;
P fin = P(nr - 1, nc - 2);
BitArray visited = BitArray(nr * nc);
bool ignoreSlope = false;
int steps = 0;
P n = P(0, 1);

void d23(bool sub) {
  visited[1] = true;
  ignoreSlope = sub;

  print(maxDfs());
}

int maxDfs() {
  if (n == fin) {
    return steps;
  }
  int maxS = 0;

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
        return 0;
      } // invalid path
      visited[n.r * nc + n.c] = true;
      steps++;
      int ret = maxDfs();
      visited[n.r * nc + n.c] = false;
      steps--;
      n -= slope.p;
      return ret;
    }
  }

  for (dir d in dir.values) {
    n += d.p;
    if (!inBounds(n.r, n.c, trail) ||
        visited[n.r * nc + n.c] ||
        trail[n.r][n.c] == '#') {
      n -= d.p;
      continue;
    }
    visited[n.r * nc + n.c] = true;
    steps++;
    maxS = max(maxS, maxDfs());
    steps--;
    visited[n.r * nc + n.c] = false;
    n -= d.p;
  }
  return maxS;
}
