
import 'package:collection/collection.dart';

import '../common.dart';

d14(bool sub) {
  List<String> input = getLines();

  RegExp re = RegExp(r'((?:-|\d)+)');

  final int w = 101;
  final int h = 103;

  List<int> counts = List.filled(5, 0);

  int quadrant(int x, int y) {
    while (x < 0) x += w;
    while (y < 0) y += h;

    return (x == (w ~/ 2) || y == (h ~/ 2))
        ? 0
        : 
  x < (w ~/ 2) ? y < (h ~/ 2) ? 1 : 2 : y < (h ~/ 2) ? 3 : 4;} 

  void count(List<int> l) {
   // print(l);
   // print("${(l[0] + l[2] * 100) % w} ${(l[1] + l[3] * 100) % h}");
    counts[quadrant((l[0] + l[2] * 100) % w, (l[1] + l[3] * 100) % h)]++;
  }

  List<List<int>> rs = 
  input
      .map((e) => re.allMatches(e).map((m) => m.group(1)!).map(int.parse).toList()).toList();

  rs.forEach((l) => count(l.toList()));

 // print(counts);
  print(counts.skip(1).reduce((a, b) => a * b));

  for (int i = 0; i < 100000; i++) {
    print("Step $i");
    List<List<bool>> grid = List.generate(h, (i)=>List.filled(w, false));

    for (var l in rs) {
      int x = (l[0] + l[2] * 100) % w;
      int y = (l[1] + l[3] * 100) % h;

      while (x < 0) x += w;
      while (y < 0) y += h;

      grid[y][x] = true;
    }

    grid.map((l) => l.map((b) => !b ? "." : "X").join()).forEach(print);
  }
}