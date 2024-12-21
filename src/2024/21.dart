import 'package:collection/collection.dart';

import '../common.dart';

/*
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
    | 0 | A |
    +---+---+
*/

List<List<int>> kp = [
  [7, 8, 9],
  [4, 5, 6],
  [1, 2, 3],
  [11, 0, 10]
];
Map<int, P> kpm = {
  0: P(3, 1),
  1: P(2, 0),
  2: P(2, 1),
  3: P(2, 2),
  4: P(1, 0),
  5: P(1, 1),
  6: P(1, 2),
  7: P(0, 0),
  8: P(0, 1),
  9: P(0, 2),
  10: P(3, 2),
  11: P(3, 0)
};

/*
    +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+
*/
enum btn {
  u(dir.u),
  l(dir.l),
  r(dir.r),
  d(dir.d),
  a(null),
  na(null);

  final dir? v;

  const btn(this.v);
}

List<List<btn>> dp = [
  [btn.na, btn.u, btn.a],
  [btn.l, btn.d, btn.r]
];

Map<btn, P> dpm = {
  btn.na: P(0, 0),
  btn.u: P(0, 1),
  btn.a: P(0, 2),
  btn.l: P(1, 0),
  btn.d: P(1, 1),
  btn.r: P(1, 2),
};

Map<dir, btn> dbm = {dir.u: btn.u, dir.d: btn.d, dir.l: btn.l, dir.r: btn.r};

List<String> ip = getLines();
List<List<int>> input = ip
    .map((l) => l.split("").map((s) => int.parse(s, radix: 16)).toList())
    .toList();

//int complexity(String s) => int.parse(s.substring(0, s.length - 1)) * search(s.split("").map((c) => int.parse(c, radix: 16)).toList());

final P dpA = P(0, 2);
final P kpA = P(3, 2);

// first order pathing. This is human input -> robot input. int is number of presses to enter each button input on robot0.
Map<P, int> m0 = Map.fromEntries(dp
    .mapIndexed((r, l) =>
        l.mapIndexed((c, i) => MapEntry(P(r, c), 1 + P(r, c).mhd(dpA))))
    .flattened
    .where((me) => me.key != P(0, 0)));

//Map<P, int> m1 = m0.map((k, v) => );

// second order pathing.
// int is number of human button presses to enter an input.
// to enter an input for robot1, robot0 must navigate to that input and press down.
void doM1() {
  for (int r = 0; r < 2; r++) {
    for (int c = 0; c < 3; c++) {
      if (r == 0 && c == 0) continue;
    }
  }
}

extension P21 on P {
  Iterable<P> get dpn => dir.values
      .map((d) => d + this)
      .where((p) => p != P(0, 0) && dpm.values.contains(p));
  Iterable<P> get kpn => dir.values
      .map((d) => d + this)
      .where((p) => p != P(3, 0) && kpm.values.contains(p));
}

P e = P(0, 0);

class State {
  P r0;
  P r1;
  P r2;

  int d;
  State? prev;

  State(this.r0, this.r1, this.r2, this.d, this.prev);

  ///int get hn => e.mhd(p) - 1;
  int get gn => d;
  //int get fn => hn + gn;

  @override
  bool operator ==(Object other) =>
      other is State &&
      other.d == d &&
      other.r0 == r0 &&
      other.r1 == r1 &&
      other.r2 == r2;

  @override
  int get hashCode => Object.hashAll([d, r0, r1, r2]);

  @override
  String toString() =>
      [r0, r1, r2].mapIndexed((i, r) => "Robot $i : $r").join((', '));
}

void d21(bool sub) {
  print(m0);
  //print(m1);
}
