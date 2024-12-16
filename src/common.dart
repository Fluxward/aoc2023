import 'dart:io';
import 'dart:math';

typedef P = Point<int>;
typedef Ps = List<P>;

class GridVec {
  P pos;
  dir d;

  GridVec(this.pos, this.d);

  String toString() => "$pos => $d";

  int get hashCode => Object.hashAll([pos, d]);

  bool operator ==(other) =>
      other is GridVec && other.pos == pos && other.d == d;

  GridVec walk() => GridVec(d + pos, d);
}

extension RCUtil on P {
  int get r => this.x;
  int get c => this.y;
}

extension RCLUtil on Ps {
  void rsort([bool ascending = true]) {
    if (ascending) {
      sort((a, b) => rComp(a, b));
    } else {
      sort(((a, b) => -rComp(a, b)));
    }
  }

  void rcsort([bool ascending = true]) {
    if (ascending) {
      sort((a, b) => rcComp(a, b));
    } else {
      sort(((a, b) => -rcComp(a, b)));
    }
  }

  void csort([bool ascending = true]) {
    if (ascending) {
      sort((a, b) => cComp(a, b));
    } else {
      sort(((a, b) => -cComp(a, b)));
    }
  }

  void crsort([bool ascending = true]) {
    if (ascending) {
      sort((a, b) => crComp(a, b));
    } else {
      sort(((a, b) => -crComp(a, b)));
    }
  }

  int rComp(P a, P b) {
    return a.r - b.r;
  }

  int rcComp(P a, P b) {
    int r = a.r - b.r;
    return r == 0 ? a.c - b.c : r;
  }

  int cComp(P a, P b) {
    return a.c - b.c;
  }

  int crComp(P a, P b) {
    int c = a.c - b.c;
    return c == 0 ? a.r - b.r : c;
  }
}

extension SUtil on String {
  int firstWhere(bool Function(int) test) {
    int i = 0;
    for (; i < this.length; i++) {
      if (test(i)) {
        return i;
      }
    }
    return -1;
  }
}

Map<String, int> _digits =
    Map.fromEntries([for (int i = 0; i < 10; i++) MapEntry(i.toString(), i)]);

int? isDigit(String s) {
  assert(s.length == 1);
  return _digits[s];
}

int? stoi(String s) {
  int? acc;
  for (int i = 0; i < s.length; i++) {
    int? d = isDigit(s[i]);
    if (d == null) {
      break;
    }

    acc = acc != null ? 10 * acc + d : d;
  }
  return acc;
}

List<int> stois(String s, {String sep = ' '}) {
  return List.from(s.split(sep).map((e) => int.tryParse(e)).nonNulls);
}

List<String> getLines() => [
      for (String? line = stdin.readLineSync();
          line != null;
          line = stdin.readLineSync())
        line
    ];

bool inBoundsString(int r, int c, List<String> l) {
  return !(r < 0 || r >= l.length || c < 0 || c >= l[r].length);
}

bool inBounds(int r, int c, List<List<Object>> l) {
  return !(r < 0 || r >= l.length || c < 0 || c >= l[r].length);
}

bool _debug = true;
void setDebug(bool d) => _debug = d;

void dpr(Object? object) {
  if (!_debug) {
    return;
  }
  print(object);
}

enum dir {
  u(Point<int>(-1, 0)),
  d(Point<int>(1, 0)),
  l(Point<int>(0, -1)),
  r(Point<int>(0, 1));

  final Point<int> p;
  const dir(this.p);

  dir rev() {
    switch (this) {
      case u:
        return d;
      case d:
        return u;
      case l:
        return r;
      case r:
        return l;
    }
  }

  dir get rt {
    switch (this) {
      case u:
        return r;
      case d:
        return l;
      case l:
        return u;
      case r:
        return d;
    }
  }

  dir get lt {
    switch (this) {
      case u:
        return l;
      case d:
        return r;
      case l:
        return d;
      case r:
        return u;
    }
  }

  Point<int> operator +(other) => other + p;

  String toString() {
    switch (this) {
      case u:
        return '^';
      case d:
        return 'v';
      case l:
        return '<';
      case r:
        return '>';
    }
  }
}

int exp(int base, int pow) => pow != 0
    ? exp(base, pow ~/ 2) * exp(base, pow ~/ 2) * ((pow % 2 == 1) ? base : 1)
    : 1;

extension IntOps on int {
  int concat(int other) => (this * exp(10, other.numDigits())) + other;
  int numDigits() => this == 0 ? 1 : (log(this.abs()) / log(10)).floor() + 1;
}

extension PointAccess on List<String> {
  String at(P p) => this[p.r][p.c];
}

extension PointAccessList<T> on List<List<T>> {
  T at(P p) => this[p.r][p.c];
}

int lcm(int a, int b) {
  if (a == 0 || b == 0) return 0;
  return ((a ~/ a.gcd(b)) * b);
}

extension MazeStuff on List<String> {
  P pointOf(String ch) {
    int r = indexWhere((s) => s.contains(ch));
    return r >= 0 ? P(r, this[r].indexOf(ch)) : P(-1, -1);
  }
}
