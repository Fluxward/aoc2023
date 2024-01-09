import 'dart:math';

import 'package:collection/collection.dart';

import 'geom.dart';

extension BILCM on BigInt {
  BigInt lcm(BigInt a) {
    return a * this ~/ a.gcd(this);
  }
}

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
  final BigInt n;
  final BigInt d;

  Rat()
      : n = BigInt.one,
        d = BigInt.one;

  Rat.i(this.n) : d = BigInt.one;

  Rat.f(BigInt nu, BigInt de)
      : n = nu ~/ nu.gcd(de),
        d = de ~/ nu.gcd(de);

  Rat operator +(Rat o) => Rat.f(n * o.d + d * o.n, d * o.d);

  Rat im(BigInt i) => Rat.f(n * i, d);

  Rat operator *(Rat o) => Rat.f(n * o.n, d * o.d);

  Rat operator /(Rat o) => Rat.f(n * o.d, d * o.n);

  Rat operator -() => Rat.f(-n, d);

  Rat operator -(Rat o) => this + -o;

  bool operator ==(o) =>
      o is Rat && ((n == o.n && d == o.d) || (n == -o.n && d == -o.d));

  String toString() {
    return d.abs() == BigInt.one
        ? (n * BigInt.from(d.sign)).toString()
        : "$n/$d";
  }
}

class Vector3d {
  final List<Rat> data;

  Vector3d(Rat a, Rat b, Rat c, [Rat? denom])
      : data = denom == null
            ? List.unmodifiable([a, b, c])
            : List.unmodifiable([a / denom, b / denom, c / denom]);

  Vector3d.r(List<Rat> r, [Rat? denom]) : this(r[0], r[1], r[2], denom);

  Vector3d.p(P3d p)
      : data = List.unmodifiable([
          Rat.i(BigInt.from(p.x)),
          Rat.i(BigInt.from(p.y)),
          Rat.i(BigInt.from(p.z))
        ]);

  Rat get a => data[0];
  Rat get b => data[1];
  Rat get c => data[2];

  Rat get x => data[0];
  Rat get y => data[1];
  Rat get z => data[2];

  Vector3d operator +(Vector3d v) => Vector3d(a + v.a, b + v.b, c + v.c);

  Vector3d operator -() => Vector3d(-a, -b, -c);

  Vector3d operator -(Vector3d o) => this + -o;

  Vector3d operator *(Rat r) => Vector3d(a * r, b * r, c * r);

  Rat operator [](int i) => data[i];

  bool operator ==(o) => o is Vector3d && a == o.a && b == o.b && c == o.c;
  Rat dot(Vector3d o) => a * o.a + b * o.b + c * o.c;

  Vector3d cross(Vector3d b) {
    Vector3d? a = this;
    return Vector3d(
        a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
  }

  String toString() {
    return data.map((e) => e.toString()).join('\n');
  }
}

class Matrix3d {
  late final List<List<BigInt>> data;

  late final BigInt? denom;

  Matrix3d(BigInt a, BigInt b, BigInt c, BigInt d, BigInt e, BigInt f, BigInt g,
      BigInt h, BigInt i,
      [this.denom])
      : data = List.unmodifiable([
          List<BigInt>.unmodifiable([a, b, c]),
          List<BigInt>.unmodifiable([d, e, f]),
          List<BigInt>.unmodifiable([g, h, i]),
        ]);
  Matrix3d.r(Rat a, Rat b, Rat c, Rat d, Rat e, Rat f, Rat g, Rat h, Rat i,
      [BigInt? denom]) {
    List<Rat> input = [a, b, c, d, e, f, g, h, i];
    BigInt lcm = input.fold(denom ?? BigInt.one, (p, e) => p.lcm(e.d));
    input.forEachIndexed((index, element) {
      input[index] = element.im(lcm);
      assert(input[index].d == BigInt.one);
    });
    data = List<List<BigInt>>.unmodifiable(List<List<BigInt>>.generate(
        3,
        (r) => List<BigInt>.unmodifiable(
            List<BigInt>.generate(3, (c) => input[r * 3 + c].n))));
    this.denom = lcm;
  }

  Matrix3d.rows(List<Vector3d> r)
      : this.r(r[0][0], r[0][1], r[0][2], r[1][0], r[1][1], r[1][2], r[2][0],
            r[2][1], r[2][2]);

  BigInt get a => data[0][0];
  BigInt get b => data[0][1];
  BigInt get c => data[0][2];
  BigInt get d => data[1][0];
  BigInt get e => data[1][1];
  BigInt get f => data[1][2];
  BigInt get g => data[2][0];
  BigInt get h => data[2][1];
  BigInt get i => data[2][2];

  BigInt get det =>
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
        v.a.im(a) + v.b.im(b) + v.c.im(c),
        v.a.im(d) + v.b.im(e) + v.c.im(f),
        v.a.im(g) + v.b.im(h) + v.c.im(i),
        Rat.i(denom ?? BigInt.one),
      );

  String toString() {
    return "$denom * \n ${data.map((e) => e.map((f) => f).join(', ')).join('\n')}";
  }
}
