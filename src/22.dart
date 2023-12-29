import 'dart:math';

import 'common.dart';

d22(bool s) {}

class P3d {
  final int x;
  final int y;
  final int z;

  P3d(this.x, this.y, this.z);
}

a() {
  List<(P3d, P3d)> cs = getLines().map((e) => parse(e)).toList();

  final int xmin =
      cs.fold(100000000, (p, e) => p = min(p, min(e.$1.x, e.$2.x)));
  final int xmax = cs.fold(0, (p, e) => p = max(p, max(e.$1.x, e.$2.x)));
  final int ymin =
      cs.fold(100000000, (p, e) => p = min(p, min(e.$1.y, e.$2.y)));
  final int ymax = cs.fold(0, (p, e) => p = max(p, max(e.$1.y, e.$2.y)));

  cs.sort((a, b) => minZ(a) - minZ(b));
}

int minZ((P3d, P3d) c) => min(c.$1.z, c.$2.z);

(P3d, P3d) parse(String s) {
  P3d parseInner(String s) {
    List<int> ss = s.split(',').map((e) => int.parse(e)).toList();
    return P3d(ss[0], ss[1], ss[2]);
  }

  List<String> ss = s.split('~');
  return (parseInner(ss[0]), parseInner(ss[1]));
}
