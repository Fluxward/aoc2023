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

  for (int i = 0; i < hsl.length; i++) {
    for (int j = i + 1; j < hsl.length; j++) {
      for (int k = j + 1; k < hsl.length; k++) {
        P3d p0 = hsl[i].p;
        P3d p1 = hsl[j].p;
        P3d p2 = hsl[k].p;
        P3d v0 = hsl[i].v;
        P3d v1 = hsl[j].v;
        P3d v2 = hsl[k].v;
        P3d v01 = v0 - v1;
        P3d v12 = v1 - v2;
        P3d v02 = v0 - v2;
        P3d p01 = p0 - p1;
        P3d p02 = p0 - p2;
        P3d p12 = p1 - p2;
        P3d p0c1 = p0.cross(p1);
        P3d p0c2 = p0.cross(p2);
        P3d p1c2 = p1.cross(p2);
        P3d a = v01.cross(p01);
        P3d b = v02.cross(p02);
        P3d c = v12.cross(p12);
        P3d d = P3d(v01.dot(p0c1), v02.dot(p0c2), v12.dot(p1c2));
        Vector3d D = Vector3d.p(d);
        Matrix3d C = Matrix3d(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z);
        Matrix3d Cinv = C.invert();

        Vector3d p = (Cinv * D);

        //if ((p.a + p.b + p.c).d == 1) {
        print("$i, $j, $k");
        print(p);
        print((p.a) + (p.b) + (p.c));
        return;
        //}
      }
    }
  }
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
  //findSquareInts(h);
  // nothing coplanar
  //anyCoplanar(h);
  // nothing parallel
  //anyParallel(h);
  int t = 100000000;
  ranges(h);
  print("t: $t");
  ranges(simulate(h, t));
  t = 1000000000;
  print("t: $t");
  ranges(simulate(h, t));
  t = 10000000000;
  print("t: $t");
  ranges(simulate(h, t));
  t = 100000000000; // this appears to be the one
  print("t: $t");
  ranges(simulate(h, t));
  t = 200000000000; // this appears to be the one
  print("t: $t");
  ranges(simulate(h, t));
  t = 300000000000; // this appears to be the one
  print("t: $t");
  ranges(simulate(h, t));
  t = 400000000000; // this appears to be the one
  print("t: $t");
  ranges(simulate(h, t));
  t = 500000000000; // this appears to be the one
  print("t: $t");
  ranges(simulate(h, t));
  t = 600000000000; // this appears to be the one
  print("t: $t");
  ranges(simulate(h, t));
  t = 700000000000; // this appears to be the one
  print("t: $t");
  ranges(simulate(h, t));
  t = 800000000000; // this appears to be the one
  print("t: $t");
  ranges(simulate(h, t));
  t = 900000000000; // this appears to be the one
  print("t: $t");
  ranges(simulate(h, t));
  t = 1000000000000;
  print("t: $t");
  ranges(simulate(h, t));
  t = 10000000000000;
  print("t: $t");
  ranges(simulate(h, t));
  t = 100000000000000;
  print("t: $t");
  ranges(simulate(h, t));
}

List<HS> ranges(List<HS> h) {
  List<HS> n = List.of(h);
  List<int> r = [
    h[0].p.x,
    h[0].p.x,
    h[0].p.y,
    h[0].p.y,
    h[0].p.z,
    h[0].p.z,
  ];
  for (int i = 0; i < h.length; i++) {
    HS hs = h[i];
    r[0] = min(r[0], hs.p.x);
    r[1] = max(r[1], hs.p.x);
    r[2] = min(r[2], hs.p.y);
    r[3] = max(r[3], hs.p.y);
    r[4] = min(r[4], hs.p.z);
    r[5] = max(r[5], hs.p.z);
  }
  print("x: ${r[0]} - ${r[1]}");
  print("y: ${r[2]} - ${r[3]}");
  print("z: ${r[4]} - ${r[5]}");
  for (int i = 0; i < n.length; i++) {
    n[i] = HS(n[i].p - P3d(r[0], r[2], r[4]), n[i].v);
  }
  return n;
}

List<HS> simulate(List<HS> h, int t) {
  List<HS> n = List.of(h);

  for (int i = 0; i < n.length; i++) {
    n[i] = HS(n[i].p + (n[i].v * t), n[i].v);
  }

  return n;
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
