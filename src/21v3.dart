import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';

import 'bitstuff.dart';
import 'common.dart';

List<String> ls = getLines();
int nr = ls.length;
int nc = ls[0].length;
AlignedBitMatrix plot = AlignedBitMatrix(nr, nc);
void main() {
  ls.forEachIndexed((r, e) => e.split('').forEachIndexed((c, ch) {
        if (ch == 'S') {
          assert(r == 65 && c == 65);
        }
        plot[r][c] = ch != '#';
      }));

  AlignedBitMatrix m = AlignedBitMatrix(nr + 2, nc + 2);

  // Patterns to simulate
  final seeds = [
    [P(66, 66)],
    [P(1, 66)],
    [P(66, 131)],
    [P(131, 66)],
    [P(66, 1)],
    [P(1, 66), P(66, 131)],
    [P(66, 131), P(131, 66)],
    [P(131, 66), P(66, 1)],
    [P(66, 1), P(1, 66)]
  ];

  Map<List<P>, List<int>> patterns = LinkedHashMap();

  for (List<P> s in seeds) {
    (AlignedBitMatrix, Set<dir>) cur = (AlignedBitMatrix(nr + 2, nc + 2), {});
    for (P p in s) {
      cur.$1[p.r][p.c] = true;
    }
    patterns[s] = [s.length];
    for (int i = 1; i <= 65 + (4 * 131); i++) {
      cur = evolve(cur.$1);
      patterns[s]!.add(cur.$1
          .countTrue(startCol: 1, startRow: 1, endCol: nc + 1, endRow: nr + 1));
    }
  }

  List<int> testIndices = [0, 31, 66, 99, 130, 196, 130 + 131, 130 + 262];

  patterns.values
      .forEach((element) => print(testIndices.map((e) => element[e]).toList()));
  int n = 100 * 2023;
  int a = 0;
  int b = 0;
  for (int i = 0; i <= n; i++) {
    if (i % 2 == 0) {
      b += (4 * i);
    } else {
      a += (4 * i);
    }
  }
  print("$a, $b");
  int ac = patterns[seeds[1]]![263];
  int bc = ac == 7331 ? 7282 : 7331;

  int total = b * ac + a * bc;

  for (int i = 1; i < 5; i++) {
    total += patterns[seeds[i]]![130 + 262];
  }
  for (int i = 5; i < 9; i++) {
    total += n * patterns[seeds[i]]![130 + 262];
  }
  total += patterns[seeds[0]]![262 + 65];
  print(total);
}

(AlignedBitMatrix, Set<dir>) evolve(AlignedBitMatrix m) {
  AlignedBitMatrix next = AlignedBitMatrix(nr + 2, nc + 2);
  Set<dir> hasNext = {};

  int nIntsC = nc.ceilDiv(64);
  for (int r = 0; r < nr; r++) {
    int bits = 0;
    for (int ch = 0; ch < nIntsC; ch++) {
      // do left and right
      int left = m[r + 1].data[ch];
      int right = m[r + 1].getIntAt(bits + 2);

      // do up and down
      int up = m[r].getIntAt(bits + 1);
      int down = m[r + 2].getIntAt(bits + 1);

      int res = plot[r].data[ch] & (left | right | up | down);
      next.rows[r + 1].copySubIntFrom(res, min(nc - bits, 64), bits + 1);
      bits += min(nc - bits, 64);

      if (ch == 0 && next[r + 1][1]) {
        hasNext.add(dir.l);
      }
      if (ch == nIntsC - 1 && next[r + 1][bits]) {
        hasNext.add(dir.r);
      }
    }

    if (r == 0 && next[1].numTrue > 0) {
      hasNext.add(dir.u);
    }

    if (r == nr - 1 && next[nr].numTrue > 0) {
      hasNext.add(dir.d);
    }
  }

  return (next, hasNext);
}
