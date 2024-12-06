import '../common.dart';
import 'package:collection/collection.dart';

void d5(bool isPart2) {
  Map<int, Set<int>> ordering = {};
  int comp(int a, int b) => ordering[a]?.contains(b) ?? false ? -1 : 1;

  List<String> lines = getLines();
  int rulesEnd = lines.indexWhere((line) => line.isEmpty);

  lines
      .sublist(0, rulesEnd)
      .map((line) => line.split('|').map((e) => int.parse(e)).toList())
      .forEach((rule) => ordering.putIfAbsent(rule[0], Set.new).add(rule[1]));

  print(lines
      .sublist(rulesEnd + 1)
      .map((line) => line.split(",").map((s) => int.parse(s)).toList())
      .fold<int>(
          0,
          (p, e) =>
              p +
              (e.isSorted(comp) != isPart2
                  ? e.sorted(comp)[e.length >> 1]
                  : 0)));
}
