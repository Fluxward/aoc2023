import 'package:collection/collection.dart';

import 'bitstuff.dart';
import 'common.dart';

int nr = 0;
int nc = 0;
void do21b() {
  List<String> ls = getLines();
  nr = ls.length;
  nc = ls[0].length;
  BitMatrix plot = BitMatrix(ls.length, ls[0].length);
  P start = P(0, 0);
  ls.forEachIndexed((r, e) => e.split('').forEachIndexed((c, ch) {
        if (ch == 'S') start = P(r, c);
        plot[P(r, c)] = ch != '#';
      }));
  // stage 1. characterise grids/steady states

  Grid init = Grid(nr, nc);
  init.m[start] = true;
}

class Grid {
  final int nr;
  final int nc;
  final BitMatrix m;
  final BitArray u;
  final BitArray d;
  final BitArray l;
  final BitArray r;

  Grid(this.nr, this.nc)
      : m = BitMatrix(nr, nc),
        u = BitArray(nc),
        d = BitArray(nc),
        l = BitArray(nr),
        r = BitArray(nr);
}
