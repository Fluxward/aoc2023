import 'package:aoc/common.dart';

List<String> input = getLines();
Set<String> ts = Set.from(input.first.split(', '));
Map<String, int> dp = {};

int dpm(String s) => dp.putIfAbsent(
    s,
    () => s.isNotEmpty
        ? ts
            .where((t) => t.matchAsPrefix(s) != null)
            .map((t) => dpm(s.substring(t.length)))
            .fold(0, (a, b) => a + b)
        : 1);

void d19(bool sub) {
  print(input
      .skip(2)
      .map((s) => dpm(s))
      .map((i) => sub
          ? i
          : i > 0
              ? 1
              : 0)
      .reduce((a, b) => a + b));
}
