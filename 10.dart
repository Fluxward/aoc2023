import 'dart:math';

import 'common.dart';

d10(bool s) => s ? b10(getLines()) : a10(getLines());

enum dir {
  u(Point<int>(-1, 0)),
  d(Point<int>(1, 0)),
  l(Point<int>(0, -1)),
  r(Point<int>(0, 1));

  final Point<int> p;
  const dir(this.p);

  dir rev() {
    switch (this) {
      case u:
        return d;
      case d:
        return u;
      case l:
        return r;
      case r:
        return l;
    }
  }

  Point<int> operator +(other) => other + p;
}

extension DeltaAddition on Point<int> {
  Point<int> operator +(dir d) => d + this;
}

// pipe type
enum pT {
  // x is the row index, y is the column index.
  ud(dir.u, dir.d),
  lr(dir.l, dir.r),
  ur(dir.u, dir.r),
  ul(dir.u, dir.l),
  dr(dir.d, dir.r),
  dl(dir.d, dir.l);

  final dir a;
  final dir b;

  const pT(this.a, this.b);

  bool connected(dir d) => a == d.rev() || b == d.rev();

  static pT? fromString(String s) {
    switch (s) {
      case '|':
        return ud;
      case '-':
        return lr;
      case 'L':
        return ur;
      case 'F':
        return dr;
      case 'J':
        return ul;
      case '7':
        return dl;
    }
    return null;
  }
}

extension PointAccess on List<String> {
  pT? pTat(Point<int> p) => inBounds(p)
      ? this[p.x][p.y] == 'S'
          ? getStartPipeType(p, this)
          : pT.fromString(this[p.x][p.y])
      : null;

  bool inBounds(Point<int> p) =>
      p.x >= 0 && p.y >= 0 && p.x < this.length && p.y < this[0].length;
}

Point<int>? findS(List<String> m) {
  int y = -1;
  int x = m.indexWhere((line) => (y = max(line.indexOf('S'), y)) >= 0);

  return x >= 0 && y >= 0 ? Point<int>(x, y) : null;
}

// determine pipe type of S
pT getStartPipeType(Point<int> s, List<String> m) {
  bool isConnected(Point<int> p, dir d) => m.pTat(d + p)?.connected(d) ?? false;

  bool bu = isConnected(s, dir.u);
  bool bd = isConnected(s, dir.d);
  bool bl = isConnected(s, dir.l);

  return bu
      ? (bd ? pT.ud : (bl ? pT.ul : (pT.ur)))
      : (bd ? (bl ? pT.dl : pT.dr) : pT.lr);
}

List<Point<int>>? getPath(List<String> m) {
  Point<int>? s = findS(m);
  if (s == null) {
    print("Couldn't find s!");
    return null;
  }

  // dfs the path
  Point<int> cur = s;
  dir? prevD = null;
  List<Point<int>> path = [];

  while ((prevD == null || cur != s)) {
    path.add(cur);
    pT cpt = m.pTat(cur)!;
    dir d = cpt.a == prevD ? cpt.b : cpt.a;
    cur = d + cur;
    prevD = d.rev();
  }

  return path;
}

void a10(List<String> m) {
  print(getPath(m)!.length ~/ 2);
}

void b10(List<String> m) {
  List<Point<int>>? p = getPath(m);

  if (p == null) {
    return;
  }
  Map<Point<int>, pT> path =
      Map.fromIterable(p, key: (p) => p, value: (p) => m.pTat(p)!);

  // track vertical crossings, horizontal crossings.

  int count = 0;
  for (int i = 0; i < m.length; i++) {
    bool outside = true;
    pT? prevCorner = null;
    for (int j = 0; j < m[i].length; j++) {
      // only care about pipes on the path.
      pT? c = path[Point<int>(i, j)];
      switch (c) {
        case pT.ud:
          outside = !outside;
        case pT.ur:
        case pT.dr:
          // this will always happen before an l corner.
          prevCorner = c;
        case pT.ul:
          outside = prevCorner == pT.dr ? !outside : outside;
        case pT.dl:
          outside = prevCorner == pT.ur ? !outside : outside;
        default:
      }
      if (c == null && !outside) {
        count += 1;
      }
    }
  }
  print(count);
}
