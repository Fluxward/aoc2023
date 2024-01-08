import 'dart:math';

import 'package:collection/collection.dart';

import 'alg.dart';
import 'common.dart';
import 'geom.dart';

void d24(bool hard) {
  hard ? doHard() : doEasy();
}

void doHard() {
  List<HS> hsl = getLines().map((e) => fromLine(e)).toList();
  investigations(hsl);
}

void doEasy() {
  List<HS> hsl = getLines().map((e) => fromLine(e)).toList();

  int lo = 200000000000000;
  int hi = lo * 2;

  int count = 0;
  for (int i = 0; i < hsl.length; i++) {
    for (int j = i + 1; j < hsl.length; j++) {
      Point<double>? itn = i2d(hsl[i], hsl[j]);
      if (itn == null) continue;
      if (lo > itn.x || lo > itn.y) continue;
      if (hi < itn.x || hi < itn.y) continue;

      count++;
    }
  }
  print(count);
}

Point<double>? i2d(HS _a, HS _b) {
  // a line as a vector is essentially:
  // v = (p.x, p.y) + lambda(v.x, v.y)
  // so trying to find l, k such that
  // a.p.x - b.p.x = l * b.v.x - k * a.v.x
  // a.p.y - b.p.y = l * b.v.y - k * a.v.y

  //
  // |bvx -avx|   | l |   |apx - bpx|
  // |bvy -avy| * | k | = |apy - bpy|

  // the intersection is at (apx + kavx, apy + kavy)

  int a = _b.v.x;
  int b = -_a.v.x;
  int c = _b.v.y;
  int d = -_a.v.y;
  Matrix2d? minv = Matrix2d(a, b, c, d).inverse;
  if (minv == null) return null;
  Vector2d<double> lk = minv *
      Vector2d<double>(
          (_a.p.x - _b.p.x).toDouble(), (_a.p.y - _b.p.y).toDouble());

  if (lk.x < 0 || lk.y < 0) return null;

  return Matrix2d(_a.p.x, _a.v.x, _a.p.y, _a.v.y) * Vector2d<double>(1, lk.y);
}

HS fromLine(String line) {
  List<String> d = line.replaceAll(' ', '').split('@');

  return HS(fromString(d[0]), fromString(d[1]));
}

P3d fromString(String d) {
  List<String> ds = d.split(',');

  return P3d(int.parse(ds[0]), int.parse(ds[1]), int.parse(ds[2]));
}

class HS {
  final P3d p;
  final P3d v;

  HS2d get xy => HS2d(p.xy, v.xy);

  HS(this.p, this.v);

  String toString() {
    return "$p @ $v";
  }
}

class HS2d {
  final P p;
  final P v;

  HS2d(this.p, this.v);
}

void investigations(List<HS> h) {
  // no perfect squares
  findSquareInts(h);
  // nothing coplanar
  anyCoplanar(h);
  // nothing parallel
  anyParallel(h);
  bfs(h);
}

void findSquareInts(List<HS> h) {
  for (int i = 0; i < h.length; i++) {
    HS hs = h[i];
    double len = hs.v.lend;
    if (len.ceil() == len.floor()) print("$i : $hs");
  }
}

void anyCoplanar(List<HS> h) {
  for (int i = 0; i < h.length; i++) {
    for (int j = i + 1; j < h.length; j++) {
      if (coplanar(h[i], h[j])) {
        print('${h[i]}, ${h[j]} coplanar');
      }
    }
  }
}

void anyParallel(List<HS> h) {
  for (int i = 0; i < h.length; i++) {
    for (int j = i + 1; j < h.length; j++) {
      if (h[i].v.cross(h[j].v) == 0) {
        print('${h[i]}, ${h[j]} parallel');
      }
    }
  }
}

bool doIntersect(HS a, HS b) {
  P3d p = b.p - a.p;
  return Matrix3d(a.v.x, a.v.y, a.v.z, b.v.x, b.v.y, b.v.z, p.x, p.y, p.z)
          .det !=
      0;
}

void bfs(List<HS> h) {
  int lim = 10000;
  for (int ti = 0; ti < lim; ti++) {
    print("Testing: $ti");
    for (int tj = ti + 1; tj < lim + 1; tj++) {
      bfsFTL(h, ti, tj);
    }
  }
}

void bfsFTL(List<HS> h, int ti, int tj) {
  // pi + ti*vi = pr + ti*vr
  // pj + tj*vj = pr + tj*vr
  int td = tj - ti;
  for (int i = 0; i < h.length; i++) {
    for (int j = i + 1; j < h.length; j++) {
      P3d a = h[i].p + h[i].v * ti;
      P3d b = h[j].p + h[j].v * tj;
      if (!divides(b - a, td)) continue;
      P3d v = (b - a) ~/ td;
      HS c = HS(a, v);
      bool allIntersect = true;
      for (int k = 0; k < h.length; k++) {
        if (!doIntersect(c, h[k])) {
          allIntersect = false;
          break;
        }
      }
      if (allIntersect) {
        print("Solution found: ");
        print("testing $ti, $tj, ${h[i]}, ${h[j]}");
      }
    }
  }
}

bool divides(P3d p, int d) => p.x % d == 0 && p.y % d == 0 && p.z % d == 0;

bool coplanar(HS a, HS b) {
  P3d p = a.p - b.p;

  P3d c = a.v.cross(b.v);

  return p.cross(c).lenSq == 0;
}
