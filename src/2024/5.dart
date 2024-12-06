import '../common.dart';
import 'package:collection/collection.dart';

void d5(bool isPart2) {
  Map<int, Set<int>> ordering = {};
  int comp(int a, int b) => ordering[a]?.contains(b) ?? false ? -1 : 1;

  List<String> lines = getLines();
  int rulesEnd = lines.indexWhere((line) => line.isEmpty);

  lines
      .sublist(0, rulesEnd)
      .map((l) => l.split('|').map((e) => int.parse(e)).toList())
      .forEach((r) => ordering.putIfAbsent(r[0], Set.new).add(r[1]));

  print(lines
      .sublist(rulesEnd + 1)
      .map((e) => e.split(",").map((s) => int.parse(s)).toList())
      .fold<int>(
          0,
          (p, e) =>
              p +
              (e.isSorted(comp) != isPart2
                  ? e.sorted(comp)[e.length >> 1]
                  : 0)));
}
