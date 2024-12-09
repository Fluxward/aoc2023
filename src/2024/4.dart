import 'package:collection/collection.dart';

import '../common.dart';

void d4(bool sub) {
  List<String> lines = getLines();
  sub ? day4b(lines) : day4a(lines);
}

void day4a(List<String> lines) {
  print(countXmas(lines) + countXmas(transpose(lines)) + countXmas(diagonalise(lines)) + countXmas(diagonalise(lines.reversed.toList())));
}

void day4b(List<String> lines) {
  Set<String> ms = {'M', 'S'};
  List<List<String>> g = lines.map((e) => e.split("")).toList();
  int count = 0;
  for (int i = 1; i < g.length - 1; i++)
    for (int j = 1; j < g.length - 1; j++)
      if (g[i][j] == 'A' &&
          ms.difference({g[i - 1][j - 1], g[i + 1][j + 1]}).isEmpty &&
          ms.difference({g[i - 1][j + 1], g[i + 1][j - 1]}).isEmpty) count++;

  print(count);
}

int countXmas(Iterable<String> lines) => [RegExp(r'XMAS'), RegExp(r'SAMX')]
    .map((e) => lines.map((m) => e.allMatches(m).length))
    .flattened
    .reduce((v, e) => v + e);

List<String> transpose(Iterable<String> lines) =>
    IterableZip(lines.map((s) => s.split(''))).map((l) => l.join()).toList();

List<String> diagonalise(List<String> lines) =>
  [...[for (int r = 0; r < lines.length; r++) [for (int c = 0; c <= r; c++) lines[r - c][c]].join()],
  ...[for (int c = 1; c < lines.length; c++) [for (int r = lines.length - 1; r >= c; r--) lines[r][lines.length - 1 + c - r]].join()]
  ];
