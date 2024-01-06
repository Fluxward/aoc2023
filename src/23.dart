import 'dart:collection';
import 'dart:isolate';
import 'dart:math';

import 'package:collection/collection.dart';

import 'bitstuff.dart';
import 'common.dart';
import 'debug.dart';

List<String> trail = getLines();

int nr = trail.length;
int nc = trail[0].length;
P fin = P(nr - 1, nc - 2);
BitArray visited = BitArray(nr * nc);
bool ignoreSlope = false;
int steps = 0;
P n = P(0, 1);
SendPort? sp;
Future<void> d23(bool sub) async {
  visited[1] = true;
  sp = await getTimerSendPort(Duration(seconds: 10));
  ignoreSlope = sub;

  if (!sub) {
    maxDfs();
    print(maxS);
  }
  //indexChokes();
  //fin = P(1, 1);
  maxDfs();
  print(maxS);
  cleanup();
}

void indexChokes() {
  List<P> chokes = [
    for (int r = 0; r < nr; r++)
      for (int c = 0; c < nc; c++)
        if (isChoke(r, c)) P(r, c)
  ];

  print("choke points:");
  chokes.forEach((element) {
    print(element);
  });
}

bool isChoke(int r, int c) {
  Map<P, P> parent = {};
  Map<P, int> children = {};

  P root(P p) {
    P pp = parent.putIfAbsent(p, () => p);
    return pp == p ? p : parent[p] = root(pp);
  }

  void join(P a, P b) {
    P aa = root(a);
    P bb = root(b);
    if (aa == bb) return;
    int naa = children.putIfAbsent(aa, () => 1);
    int nbb = children.putIfAbsent(bb, () => 1);
    if (naa < nbb) {
      parent[aa] = bb;
      children[bb] = naa + nbb;
    } else {
      parent[bb] = aa;
      children[aa] = naa + nbb;
    }
  }

  P p = P(r, c);
  Set<P> seen = {p};

  List<P> getNext(P p) {
    List<P> ns = [];
    for (dir d in dir.values) {
      P n = p + d.p;
      if (seen.contains(n) ||
          !inBounds(n.r, n.c, trail) ||
          trail[n.r][n.c] == '#') continue;
      ns.add(n);
    }

    return ns;
  }

  List<P> ns = getNext(p);

  if (ns.length < 2) return false;

  Queue<P> q = Queue.from(ns);
  while (q.isNotEmpty) {
    P a = q.removeFirst();
    if (seen.add(a)) {
      continue;
    }
    List<P> neighs = getNext(a);
    neighs.forEach((element) => join(element, a));
    q.addAll(neighs);
  }

  for (int i = 0; i < ns.length; i++) {
    for (int j = i + 1; j < ns.length; j++) {
      if (root(ns[i]) == ns[j]) return false;
    }
  }

  return true;
}

int maxS = 0;
void maxDfs() {
  if (n == fin) {
    sp?.send("maxS: $maxS");
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
    if (!inBounds(n.r, n.c, trail) ||
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
