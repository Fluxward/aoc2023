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

List<List<int>> kp = [[7, 8, 9], [4, 5, 6], [1, 2, 3], [11, 0, 10]];

/*
    +---+---+
    | ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+
*/
enum btn {
  u(dir.u), l(dir.l), r(dir.r), d(dir.d), a(null), na(null);

  final dir? v;

  const btn(this.v);
}
List<List<btn>> dp = [[btn.na, btn.u, btn.a], [btn.l, btn.d, btn.r]];

List<String> ip = getLines();
List<List<int>> input = ip.map((l) => l.split("").map((s) => int.parse(s, radix: 16)).toList()).toList();

int complexity(String s) => int.parse(s.substring(0, s.length - 1)) * search(s.split("").map((c) => int.parse(c, radix: 16)).toList());



int search(List<int> i) {
  return 0;
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
      other is State && other.d == d && other.r0 == r0 && other.r1 == r1 && other.r2 == r2;

  @override
  int get hashCode => Object.hashAll([d, r0, r1, r2]);

  @override
  String toString() => [r0, r1, r2].mapIndexed((i, r) => "Robot $i : $r").join((', '));
} 

void d21(bool sub) {}

