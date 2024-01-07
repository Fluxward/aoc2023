import 'dart:math';

typedef Vector2d<T extends num> = Point<T>;

class Matrix2d<T extends num> {
  final num a;
  final num b;
  final num c;
  final num d;

  Matrix2d(this.a, this.b, this.c, this.d);

  num get det => a * d - b * c;

  Matrix2d? get detInverse => det == 0 ? null : Matrix2d(d, -b, -c, a);

  Matrix2d? get inverse => det == 0 ? null : detInverse! / det.toDouble();

  Matrix2d operator /(double div) =>
      Matrix2d(a / div, b / div, c / div, d / div);

  Matrix2d operator ~/(int div) =>
      Matrix2d(a ~/ div, b ~/ div, c ~/ div, d ~/ div);

  Vector2d<double> operator *(Vector2d<double> v) =>
      Vector2d(v.x * a + v.y * b, v.x * c + v.y * d);
}
