import 'common.dart';

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
