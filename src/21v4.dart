import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

import 'bitstuff.dart';
import 'common.dart';

int k = 17;
List<String> ls = File(Directory.current.path + "/inputs/21").readAsLinesSync();
int bnr = ls.length;
int bnc = ls[0].length;
int nr = bnr * k;
int nc = bnc * k;
AlignedBitMatrix plot = AlignedBitMatrix(nr, nc);

void loop2d(int rs, int cs, void Function(int a, int b) f) {
  for (int r = 0; r < rs; r++) for (int c = 0; c < cs; c++) f(r, c);
}

void main() {
  ls.forEachIndexed((r, e) => e.split('').forEachIndexed((c, ch) {
        loop2d(k, k, (i, j) {
          plot[r + i * bnr][c + j * bnc] = ch != '#';
        });
      }));

  print("$nr, $nc");

  (AlignedBitMatrix, Set<dir>) cur = (AlignedBitMatrix(nr + 2, nc + 2), {});
  List<List<int>> counts = List.generate(k, (i) => List.filled(k, 0));
  cur.$1[66 + (k ~/ 2) * bnr][66 + (k ~/ 2) * bnc] = true;
  for (int i = 1; i <= 65 + ((k ~/ 2) * 131); i++) {
    cur = evolve(cur.$1);
    if (i == 65 || ((i + 131 - 65) % 131) == 0) {
      print("$i:");
      loop2d(k, k, (a, b) {
        counts[a][b] = cur.$1.countTrue(
            startRow: 1 + bnr * a,
            startCol: 1 + bnc * b,
            endRow: 1 + (a + 1) * bnr,
            endCol: 1 + (b + 1) * bnc);
      });
      counts.forEach((element) {
        print(element.map((e) => e.toString().padLeft(4)).join(", "));
      });
    }
  }
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
