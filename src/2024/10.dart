import 'package:collection/collection.dart';

import '../common.dart';

d10(bool sub) {
  List<List<int>> grid =
      getLines().map((l) => l.split("").map(int.parse).toList()).toList();
  List<List<(Set<P>, int)>> scores = grid
      .mapIndexed((r, l) =>
          l.mapIndexed((c, e) => e == 9 ? ({P(r, c)}, 1) : (<P>{}, 0)).toList())
      .toList();

  for (int i = 8; i >= 0; i--)
    grid.indexed.map((l) => (l.$1, l.$2.indexed)).forEach((r) => r.$2
        .where((c) => c.$2 == i)
        .forEach((c) => scores[r.$1][c.$1] = dir.values
            .map((d) => d + P(r.$1, c.$1))
            .where((e) => inBounds(e.r, e.c, grid) && grid.at(e) == i + 1)
            .map((e) => scores.at(e))
            .fold((<P>{}, 0), (p, s) => (p.$1.union(s.$1), p.$2 + s.$2))));

  print(scores
      .mapIndexed((r, l) => l
          .mapIndexed((c, e) => sub ? scores[r][c].$2 : scores[r][c].$1.length)
          .whereIndexed((c, e) => grid[r][c] == 0)
          .fold(0, (a, b) => a + b))
      .reduce((a, b) => a + b));
}
