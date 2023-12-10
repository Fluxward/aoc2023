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

enum pT {
  // x is the row index, y is the column index.
  ud(0, -1, 0, 1),
  lr(-1, 0, 1, 0),
  ur(0, -1, 1, 0),
  ul(0, -1, -1, 0),
  dr(0, 1, 1, 0),
  dl(0, 1, -1, 0);

  final int yda;
  final int xda;
  final int ydb;
  final int xdb;

  const pT(this.yda, this.xda, this.ydb, this.xdb);

  bool connected(Point<int> d) {
    if (yda == -d.y && xda == -d.x) {
      return true;
    }

    if (ydb == -d.y && xdb == -d.x) {
      return true;
    }

    return false;
  }

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

List<Point<int>> ds = [
  Point(1, 0),
  Point(0, 1),
  Point(-1, 0),
  Point(0, -1),
];

List<Point<int>>? a10(List<String> m) {
  Point<int>? s = findS(m);
  if (s == null) {
    print("Couldn't find s!");
    return null;
  }

  int length = 0;

  // find next pipe
  Point<int> cur = s;
  Point<int>? next;
  Point<int>? prevD = null;
  List<Point<int>> path = [s];
  while ((prevD == null || cur != s)) {
    for (int i = 0; i < 4; i++) {
      pT? curP = pT.fromString(m[cur.x][cur.y]);
      if ((prevD != null && ds[i] == prevD) ||
          (cur != s && curP != null && !curP.connected(ds[i] * -1))) {
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
  print(length);
}

b10(List<String> m) {
  List<Point<int>>? p = a10(m);
  if (p == null) {
    return;
  }

  // determine pipe type of S
  Point<int> s = p[0];
  pT? u = pT.fromString(m[s.x - 1][s.y]);
  pT? d = pT.fromString(m[s.x + 1][s.y]);
  pT? l = pT.fromString(m[s.x][s.y - 1]);
  pT? r = pT.fromString(m[s.x][s.y + 1]);

  bool bu = false;
  bool bd = false;
  bool bl = false;
  bool br = false;

  if (u != null) {
    bu = u.connected(Point<int>(-1, 0));
  }
  if (d != null) {
    bd = d.connected(Point<int>(1, 0));
  }
  if (l != null) {
    bl = l.connected(Point<int>(0, -1));
  }

  pT spt = bu
      ? (bd ? pT.ud : (bl ? pT.ul : (pT.ur)))
      : (bd ? (bl ? pT.dl : pT.dr) : pT.lr);

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
  printArea(m, inside, path.keys.toSet());
  print(count);
}
