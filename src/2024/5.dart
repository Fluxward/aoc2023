import '../common.dart';
import 'package:collection/collection.dart';

void d5(bool isPart2) {
  Map<int, Set<int>> ordering = {};
  int cm(int a, int b) => ordering[a]?.contains(b) ?? false ? -1 : 1;

  List<String> lines = getLines();
  int rulesEnd = lines.indexWhere((line) => line.isEmpty);

  lines
      .take(rulesEnd)
      .map((line) => line.split('|').map((e) => int.parse(e)).toList())
      .forEach((rule) => ordering.putIfAbsent(rule[0], Set.new).add(rule[1]));

  print(lines
      .skip(rulesEnd + 1)
      .map((line) => line.split(",").map((s) => int.parse(s)).toList())
      .map((e) => e.isSorted(cm) != isPart2 ? e.sorted(cm)[e.length >> 1] : 0)
      .reduce((p, e) => p + e));
}
