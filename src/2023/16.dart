import 'dart:math';
import '../common.dart';

d16(bool s) {
  List<String> ls = getLines();
  if (!s) {
    Set<P> en = {};
    traverse(ls, dir.r, P(0, 0), en, {});
    print(en.length);
  }

  final int nr = ls.length;
  final int nc = ls[0].length;

  List<(P, dir)> starts = [
    for (dir d in dir.values)
      if (d == dir.r || d == dir.l)
        for (int i = 0; i < nr; i++) (P(i, d == dir.r ? 0 : nc - 1), d)
      else
        for (int i = 0; i < nc; i++) (P(d == dir.d ? 0 : nr - 1, i), d)
  ];

  int m = 0;
  for ((P, dir) s in starts) {
    Set<P> en = {};
    traverse(ls, s.$2, s.$1, en, {});
    m = max(m, en.length);
  }
  print(m);
}

void traverse(List<String> ls, dir ed, P pos, Set<P> en, Set<(P, dir)> seen) {
  dir cDir = ed;
  P curT = pos;

  while (inBounds(curT.r, curT.c, ls)) {
    if (!seen.add((curT, cDir.rev()))) return;
    en.add(curT);

    bool? splitV;
    switch (ls.at(curT)) {
      case '.':
        curT += cDir.p;
      case '/':
        cDir = cDir.reflect(true);
        curT += cDir.p;
      case '\\':
        cDir = cDir.reflect(false);
        curT += cDir.p;
      case '|':
        splitV = true;
      case '-':
        splitV = false;
    }

    if (splitV != null) {
      List<dir> next = cDir.split(splitV) ?? [cDir];

      for (dir d in next) {
        P nP = curT + d.p;
        traverse(ls, d, nP, en, seen);
      }
      return;
    }
  }
}

extension Reflections on dir {
  dir reflect(bool right) {
    switch (this) {
      case dir.u:
        return right ? dir.r : dir.l;
      case dir.d:
        return right ? dir.l : dir.r;
      case dir.r:
        return right ? dir.u : dir.d;
      case dir.l:
        return right ? dir.d : dir.u;
    }
  }

  List<dir>? split(bool v) {
    switch (this) {
      case dir.u:
      case dir.d:
        return v ? null : [dir.l, dir.r];
      case dir.r:
      case dir.l:
        return v ? [dir.u, dir.d] : null;
    }
  }
}
