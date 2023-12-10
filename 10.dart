import 'dart:math';

import 'common.dart';

d10(bool s) => s ? b10(getLines()) : a10(getLines());

Point<int>? findS(List<String> m) {
  for (int i = 0; i < m.length; i++) {
    for (int j = 0; j < m[0].length; j++) {
      if (m[i][j] == 'S') {
        return Point(i, j);
      }
    }
  }
  return null;
}

enum dir {
  u(Point<int>(-1, 0)),
  d(Point<int>(1, 0)),
  l(Point<int>(0, -1)),
  r(Point<int>(0, 1));

  final Point<int> p;
  const dir(this.p);
}

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

  bool connected(Point<int> d) => a == d * -1 || b == d * -1;

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

bool inBounds(int x, int y, List<String> m) =>
    x >= 0 && y >= 0 && x < m.length && y < m[0].length;

bool pInBounds(Point<int> p, List<String> m) => inBounds(p.x, p.y, m);

pT getStartPipeType(Point<int> s, List<String> m) {
  // determine pipe type of S
  pT? u = pT.fromString(m[s.x - 1][s.y]);
  pT? d = pT.fromString(m[s.x + 1][s.y]);
  pT? l = pT.fromString(m[s.x][s.y - 1]);

  bool bu = false;
  bool bd = false;
  bool bl = false;

  if (u != null) {
    bu = u.connected(Point<int>(-1, 0));
  }
  if (d != null) {
    bd = d.connected(Point<int>(1, 0));
  }
  if (l != null) {
    bl = l.connected(Point<int>(0, -1));
  }

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

  int length = 0;

  // dfs the path
  Point<int> cur = s;
  Point<int>? next;
  dir? prevD = null;
  List<Point<int>> path = [s];
  while ((prevD == null || cur != s)) {
    for (int i = 0; i < 4; i++) {
      pT? curP = pT.fromString(m[cur.x][cur.y]);
      dir d = dir.values[i];
      // don't check backwards
      if (prevD == d ||
          // don't check an adjacent pipe if it isn't connected to this
          (cur != s && curP != null && !curP.connected(dir.values[i].p * -1))) {
        continue;
      }

      next = cur + ds[i];

      if (next.x < 0 ||
          next.y < 0 ||
          next.x >= m.length ||
          next.y >= m.length) {
        continue;
      }

      if (next == s) {
        length++;
        print("$length, ${length ~/ 2}");
        return path;
      }

      pT? np = pT.fromString(m[next.x][next.y]);
      if (np == null) {
        continue;
      }

      if (np.connected(ds[i])) {
        cur = next;
        prevD = ds[i] * -1;
        length++;
        path.add(cur);
        break;
      }
    }
  }

  return null;
}

void a10(List<String> m) {
  print(getPath(m)!.length ~/ 2);
}

void b10(List<String> m) {
  List<Point<int>>? p = getPath(m);
  if (p == null) {
    return;
  }

  Map<Point<int>, pT> path = Map.fromIterable(p,
      key: (p) => p, value: (p) => p == s ? spt : pT.fromString(m[p.x][p.y])!);

  // track vertical crossings, horizontal crossings.
  Map<int, Set<int>> inside = {};

  int count = 0;
  for (int i = 0; i < m.length; i++) {
    bool outside = true;
    pT? prevCorner = null;
    for (int j = 0; j < m[i].length; j++) {
      pT? c = path[Point<int>(i, j)];
      if (c != null) {
        switch (c) {
          case pT.ud:
            outside = !outside;
            break;
          case pT.ur:
          case pT.dr:
            prevCorner = c;
          case pT.ul:
            if (prevCorner == pT.dr) {
              outside = !outside;
            }
            prevCorner = null;
          case pT.dl:
            if (prevCorner == pT.ur) {
              outside = !outside;
            }
          case pT.lr:
          // fall through
        }
        continue;
      }
      if (!outside) {
        count += 1;
        inside.putIfAbsent(i, () => {})..add(j);
      }
    }
  }
  print(count);
}

void printGrid(List<String> m, int x, int y) {
  print("-" * m.length);
  for (int i = 0; i < m.length; i++) {
    if (i == x) {
      String c = m[i];
      print(c.replaceRange(y, y + 1, 'X'));
    } else {
      print(m[i]);
    }
  }
  print("-" * m.length);
}

void printArea(
    List<String> m, Map<int, Set<int>> inside, Set<Point<int>> path) {
  for (int i = 0; i < m.length; i++) {
    StringBuffer b0 = StringBuffer();
    StringBuffer b1 = StringBuffer();
    StringBuffer b2 = StringBuffer();

    Set<int>? a = inside[i];
    for (int j = 0; j < m[0].length; j++) {
      if (a != null && a.contains(j)) {
        modSB(b0, b1, b2, 'X', true);
      } else {
        modSB(b0, b1, b2, m[i][j], path.contains(Point<int>(i, j)));
      }
    }
    print(b0);
    print(b1);
    print(b2);
  }
}

void modSB(
    StringBuffer b0, StringBuffer b1, StringBuffer b2, String c, bool draw) {
  if (!draw) {
    b0.write('   ');
    b1.write('   ');
    b2.write('   ');
    return;
  }
  switch (c) {
    case '.':
      b0.write('   ');
      b1.write(' O ');
      b2.write('   ');
    case 'X':
      b0.write(r'***');
      b1.write(r'*X*');
      b2.write(r'***');
    case '|':
      b0.write(' | ');
      b1.write(' | ');
      b2.write(' | ');
    case '-':
      b0.write('   ');
      b1.write('---');
      b2.write('   ');
    case 'L':
      b0.write(' | ');
      b1.write(' *-');
      b2.write('   ');

    case 'F':
      b0.write('   ');
      b1.write(' *-');
      b2.write(' | ');

    case 'J':
      b0.write(' | ');
      b1.write('-* ');
      b2.write('   ');

    case '7':
      b0.write('   ');
      b1.write('-* ');
      b2.write(' | ');
    case 'S':
      b0.write(' *-');
      b1.write(' | ');
      b2.write('-* ');
  }
}
