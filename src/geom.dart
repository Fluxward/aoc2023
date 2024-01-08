import 'dart:math';

import 'common.dart';

final double EPS = 0.000000001;

class P3d {
  final int x;
  final int y;
  final int z;

  P get xy => P(x, y);

  P3d(this.x, this.y, this.z);

  String toString() => "x: $x, y: $y, z: $z";

  int get hashCode => Object.hashAll([x, y, z]);

  bool operator ==(other) =>
      other is P3d && other.x == x && other.y == y && other.z == z;

  P3d operator -(P3d o) => P3d(x - o.x, y - o.y, z - o.z);
  P3d operator +(P3d o) => P3d(x + o.x, y + o.y, z + o.z);
  P3d operator *(int k) => P3d(x * k, y * k, z * k);
  P3d operator ~/(int d) => P3d(x ~/ d, y ~/ d, z ~/ d);

  int dot(P3d o) => x * o.x + y * o.y + z * o.z;
  int get lenSq => dot(this);

  double get lend => sqrt(lenSq);

  P3d cross(P3d b) {
    P3d? a = this;
    return P3d(
        a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
  }

  int get sign => x == 0
      ? y == 0
          ? z == 0
              ? 0
              : z.sign
          : y.sign
      : x.sign;
}

class Segment {
  final P x;
  final P y;

  Segment(this.x, this.y);
}

int cross(P a, P b) => a.x * b.y - a.y * b.x;

int iarea(Ps pts) {
  double res = 0;
  for (int i = 0; i < pts.length; i++)
    res += cross(pts[i] - pts[0], pts[(i + 1) % pts.length] - pts[0]);
  return res ~/ 2;
}

/// > 0 if left, < 0 if right, 0 if straight
int ccw(P a, P b, P c) {
  return cross(b - a, c - a);
}

double dist(P a, P b) => sqrt(sqDist(a, b));
int sqDist(P a, P b) => a.squaredDistanceTo(b);

bool overlap(Segment a, Segment b) {
  // all four points collinear
  return cross(a.y - a.x, b.x - a.x) == 0 && cross(a.y - a.x, b.y - a.x) == 0;
}

bool intersect(Segment a, Segment b) {
  if (overlap(a, b)) {
    int maxDist = 0;
    maxDist = max(maxDist, sqDist(a.x, a.y));
    maxDist = max(maxDist, sqDist(a.x, b.x));
    maxDist = max(maxDist, sqDist(a.x, b.y));
    maxDist = max(maxDist, sqDist(b.x, b.y));
    maxDist = max(maxDist, sqDist(b.x, a.y));
    maxDist = max(maxDist, sqDist(a.y, b.y));

    return sqrt(maxDist) < dist(a.x, a.y) + dist(b.x, b.y) + EPS;
  }
  return ccw(a.x, a.y, b.x) != ccw(a.x, a.y, b.y) &&
      ccw(b.x, b.y, a.x) != ccw(b.x, b.y, a.y);
}
