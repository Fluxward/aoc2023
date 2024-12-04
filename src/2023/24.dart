import 'dart:math';

import '../alg.dart';
import '../common.dart';
import '../geom.dart';

void d24(bool hard) {
  hard ? doHard() : doEasy();
}

void doHard() {
  List<HS> hsl = getLines().map((e) => fromLine(e)).toList();

  List<Vector3d> pi = List.generate(3, (i) => Vector3d.p(hsl[i].p));
  List<Vector3d> vi = List.generate(3, (i) => Vector3d.p(hsl[i].v));
  List<Vector3d> pij = List.generate(3, (i) => pi[i] - pi[(i + 1) % 3]);
  List<Vector3d> vij = List.generate(3, (i) => vi[i] - vi[(i + 1) % 3]);
  List<Vector3d> picj = List.generate(3, (i) => pi[i].cross(pi[(i + 1) % 3]));
  List<Vector3d> rows = List.generate(3, (i) => vij[i].cross(pij[i]));
  List<Rat> D = List.generate(3, (i) => vij[i].dot(picj[i]));
  Matrix3d C = Matrix3d.rows(rows);
  Matrix3d Cinv = C.invert();

  Vector3d p = (Cinv * Vector3d.r(D));

  print(p.dot(Vector3d.p(P3d(1, 1, 1))));
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
