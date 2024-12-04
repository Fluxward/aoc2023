import '../common.dart';

void d4(bool sub) {
  List<String> lines = getLines();
  sub ? day4b(lines) : day4a(lines);
}

void day4a(List<String> lines) {
  print(countXmas(lines) + countXmas(transpose(lines)) + countXmas(diagonalise(lines)) + countXmas(diagonalise(lines.reversed.toList())));
}

void day4b(List<String> lines) {
  Map<String, int> v = {"M" : 1, "A" : 0, "S" : -1};
  List<List<int?>> g = lines.map((e) => e.split("").map((c) => v[c]).toList()).toList();
  int count = 0;
  for (int i = 0; i < g.length - 2; i++)
    for (int j = 0; j < g.length - 2; j++)
      if ((g[i][j] != null &&
              g[i + 1][j + 1] != null &&
              g[i + 2][j + 2] != null &&
              g[i + 2][j] != null &&
              g[i][j + 2] != null) &&
          ((g[i][j] == 1 || g[i][j] == -1) && g[i + 1][j + 1] == 0) &&
          (g[i + 2][j] == 1 || g[i + 2][j] == -1) &&
          (g[i][j] == -g[i + 2][j + 2]!) &&
          (g[i + 2][j] == -g[i][j + 2]!)) count++;

  print(count);
}

int countXmas(Iterable<String> lines) {
  return lines.fold(0, (p, e) => p + RegExp(r'XMAS').allMatches(e).length) + lines.fold(0, (p, e) => p + RegExp(r'SAMX').allMatches(e).length);
}

List<String> transpose(Iterable<String> lines) {
  return [for (int i = 0; i < lines.length; i++) lines.map((e) => e[i]).join()];
}

List<String> diagonalise(List<String> lines) {
  return [...[for (int r = 0; r < lines.length; r++) [for (int c = 0; c <= r; c++) lines[r - c][c]].join()],
  ...[for (int c = 1; c < lines.length; c++) [for (int r = lines.length - 1; r >= c; r--) lines[r][lines.length - 1 + c - r]].join()]
  ];
}