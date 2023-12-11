import 'dart:math';

import 'common.dart';

d11(bool s) {
  setDebug(false);

  List<String> lines = getLines();
  var d = parse(lines, subset: s);
  List<P> n = d.galaxies;

  int sum = 0;
  for (int i = 0; i < n.length; i++) {
    for (int j = i + 1; j < n.length; j++) {
      sum += m(n[i], n[j]);
    }
  }
  print(sum);
}

typedef P = Point<int>;

extension PiUtil on P {
  int get r => this.x;
  int get c => this.y;
}

({List<P> galaxies, List<int> emptyCols, List<int> emptyRows}) parse(
    List<String> input,
    {bool subset = false}) {
  List<P> galaxies = [];
  List<P> og = [];
  List<int> cols = [];
  List<int> rows = [];

  int mult = (subset ? 1000000 : 2) - 1;

  int rowOffset = 0;
  for (int i = 0; i < input.length; i++) {
    bool found = false;
    for (int j = 0; j < input[0].length; j++) {
      if (input[i][j] == '#') {
        found = true;
        og.add(P(i, j));
        galaxies.add(P(i + (rowOffset * mult), j));
      }
    }
    if (!found) {
      rows.add(i);
      rowOffset++;
    }
  }

  for (int c = 0; c < input[0].length; c++) {
    if (input.every((element) => element[c] == '.')) {
      cols.add(c);
    }
  }

  galaxies.sort((a, b) => a.c - b.c);

  int i = 0;
  while (galaxies[i].c < cols[0]) {
    i++;
  }
  for (int c = 0; c < cols.length; c++) {
    while (i < galaxies.length) {
      if (c < cols.length - 1 && galaxies[i].c > cols[c + 1]) {
        break;
      }
      galaxies[i] += P(0, (c + 1) * mult);
      i++;
    }
  }
  return (galaxies: galaxies, emptyCols: cols, emptyRows: rows);
}

int m(P a, P b) => (a.r - b.r).abs() + (a.c - b.c).abs();
