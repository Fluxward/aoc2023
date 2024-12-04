import 'dart:math';

import 'package:collection/collection.dart';

import '../common.dart';
import '../geom.dart';

d22(bool s) {
  s ? () {} : a();
}

P3d delta(P3d a, P3d b) {
  P3d v = b - a;
  return (v.x == 0
          ? v.y == 0
              ? v.z == 0
                  ? P3d(0, 0, 0)
                  : P3d(0, 0, 1)
              : P3d(0, 1, 0)
          : P3d(1, 0, 0)) *
      v.sign;
}

List<(P3d, P3d, int)> cs = getLines().map((e) => parse(e)).toList();
(P3d, P3d, int) c = cs[0];

final int xmin =
    cs.fold(min(c.$1.x, c.$2.x), (p, e) => p = min(p, min(e.$1.x, e.$2.x)));
final int xmax = cs.fold(0, (p, e) => p = max(p, max(e.$1.x, e.$2.x)));
final int ymin =
    cs.fold(min(c.$1.y, c.$2.y), (p, e) => p = min(p, min(e.$1.y, e.$2.y)));
final int ymax = cs.fold(0, (p, e) => p = max(p, max(e.$1.y, e.$2.y)));
final int zmin =
    cs.fold(min(c.$1.z, c.$2.z), (p, e) => p = min(p, min(e.$1.z, e.$2.z)));
final int zmax = cs.fold(0, (p, e) => p = max(p, max(e.$1.z, e.$2.z)));
a() {
  print("x: $xmin - $xmax");
  print("y: $ymin - $ymax");
  print("z: $zmin - $zmax");

  cs.sort((a, b) => a.$1.z - b.$1.z);
  List<(P3d, P3d, int)> fallen = [];
  List<List<List>> vol = List.generate(
      xmax - xmin + 1, (_) => List.generate(ymax - ymin + 1, (_) => [0]));
  for ((P3d, P3d, int) p in cs) {
    int z = 0;

    for (P3d c in span(p)) {
      z = max(vol[c.x - xmin][c.y - ymin].last, z);
    }

    z++;

    P3d a = P3d(p.$1.x, p.$1.y, z);
    P3d b = P3d(p.$2.x, p.$2.y, p.$2.z - p.$1.z + z);

    for (P3d c in span((a, b, 0))) {
      vol[c.x - xmin][c.y - ymin].add(c.z);
    }

    fallen.add((a, b, p.$3));
    print("$p -> ${fallen.last}");
  }
  int count = 0;
  int ch = 0;

  for (int i = 0; i < fallen.length; i++) {
    (P3d, P3d, int) cur = fallen[i];
    if (stable(List.of(fallen)..removeAt(i))) {
      count++;
      print("Brick ${cur.$3} ok");
    }
    ch += chain(List.of(fallen)..removeAt(i));
  }
  print(count);
  print(ch);
}

bool stable(List<(P3d, P3d, int)> cs) {
  List<List<List>> vol = List.generate(
      xmax - xmin + 1, (_) => List.generate(ymax - ymin + 1, (_) => [0]));
  for ((P3d, P3d, int) p in cs) {
    int z = 0;

    List<P3d> sp = span(p);
    for (P3d c in sp) {
      z = max(vol[c.x - xmin][c.y - ymin].last, z);
    }

    z++;

    P3d a = P3d(p.$1.x, p.$1.y, z);
    P3d b = P3d(p.$2.x, p.$2.y, p.$2.z - p.$1.z + z);

    if (p.$1.z != z) {
      //print("fell at $p -> $a $b");
      return false;
    }

    for (P3d c in span((a, b, 0))) {
      vol[c.x - xmin][c.y - ymin].add(c.z);
    }
  }

  return true;
}

int chain(List<(P3d, P3d, int)> cs) {
  List<List<List>> vol = List.generate(
      xmax - xmin + 1, (_) => List.generate(ymax - ymin + 1, (_) => [0]));
  int chain = 0;
  for ((P3d, P3d, int) p in cs) {
    int z = 0;

    List<P3d> sp = span(p);
    for (P3d c in sp) {
      z = max(vol[c.x - xmin][c.y - ymin].last, z);
    }

    z++;

    P3d a = P3d(p.$1.x, p.$1.y, z);
    P3d b = P3d(p.$2.x, p.$2.y, p.$2.z - p.$1.z + z);

    if (p.$1.z != z) {
      //print("fell at $p -> $a $b");
      chain++;
    }

    for (P3d c in span((a, b, 0))) {
      vol[c.x - xmin][c.y - ymin].add(c.z);
    }
  }

  return chain;
}

List<P3d> span((P3d, P3d, int) p) {
  List<P3d> ps = [for (P3d c = p.$1; c != p.$2; c += delta(p.$1, p.$2)) c];
  ps.add(p.$2);

  return ps;
}

int minZ((P3d, P3d, int) c) => min(c.$1.z, c.$2.z);
int maxZ((P3d, P3d, int) c) => max(c.$1.z, c.$2.z);

int ind = 0;
(P3d, P3d, int) parse(String s) {
  P3d parseInner(String s) {
    List<int> ss = s.split(',').map((e) => int.parse(e)).toList();
    return P3d(ss[0], ss[1], ss[2]);
  }

  List<String> ss = s.split('~');
  P3d a = parseInner(ss[0]);
  P3d b = parseInner(ss[1]);
  return a.z <= b.z ? (a, b, ind++) : (b, a, ind++);
}
