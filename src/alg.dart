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

class Rat {
  final int n;
  final int d;

  const Rat()
      : n = 1,
        d = 1;

  Rat.i(this.n) : d = 1;

  Rat.f(int numerator, int denominator)
      : n = numerator ~/ numerator.gcd(denominator),
        d = numerator.gcd(denominator);

  Rat operator +(Rat o) => Rat.f(n * o.d + d * o.n, d * o.d);

  Rat operator *(int i) => Rat.f(n * i, d);

  Rat rm(Rat o) => Rat.f(n * o.n, d * o.d);

  Rat operator /(Rat o) => Rat.f(n * o.d, d * o.n);

  Rat operator -() => Rat.f(-n, d);

  Rat operator -(Rat o) => this + -o;

  bool operator ==(o) =>
      o is Rat && ((n == o.n && d == o.d) || (n == -o.n && d == -o.d));
}

class Vector3d {
  final List<Rat> data;

  Vector3d(Rat a, Rat b, Rat c, [Rat? denom])
      : data = denom == null
            ? List.unmodifiable([a, b, c])
            : List.unmodifiable([a / denom, b / denom, c / denom]);

  Rat get a => data[0];
  Rat get b => data[1];
  Rat get c => data[2];

  Vector3d operator +(Vector3d v) => Vector3d(a + v.a, b + v.b, c + v.c);

  Vector3d operator -() => Vector3d(-a, -b, -c);

  Vector3d operator -(Vector3d o) => this + -o;

  Vector3d operator *(Rat r) => Vector3d(a.rm(r), b.rm(r), c.rm(r));

  bool operator ==(o) => o is Vector3d && a == o.a && b == o.b && c == o.c;
}

class Matrix3d {
  final List<List<int>> data;

  final int denom;

  Matrix3d(int a, int b, int c, int d, int e, int f, int g, int h, int i,
      [this.denom = 1])
      : data = List.unmodifiable([
          List.unmodifiable([a, b, c]),
          List.unmodifiable([d, e, f]),
          List.unmodifiable([g, h, i]),
        ]);

  int get a => data[0][0];
  int get b => data[0][1];
  int get c => data[0][2];
  int get d => data[1][0];
  int get e => data[1][1];
  int get f => data[1][2];
  int get g => data[2][0];
  int get h => data[2][1];
  int get i => data[2][2];

  int get det =>
      a * (e * i - f * h) + b * (f * g - d * i) + c * (d * h - e * g);

  Matrix3d invert() => Matrix3d(
        e * i - f * h,
        c * h - b * i,
        b * f - c * e,
        f * g - d * i,
        a * i - c * g,
        c * d - a * f,
        d * h - e * g,
        b * g - a * h,
        a * e - b * d,
        det,
      );

  Vector3d operator *(Vector3d v) => Vector3d(
        v.a * a + v.b * b + v.c * c,
        v.a * d + v.b * e + v.c * f,
        v.a * g + v.b * h + v.c * i,
        Rat.i(denom),
      );
}
