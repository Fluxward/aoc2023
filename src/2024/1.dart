import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void d1(bool s) {
  s ? day1s() : day1();
}

void day1() {
  print(IterableZip(
          IterableZip(getLines().map((l) => l.split('   ').map(int.parse)))
              .map((l) => l.sorted((a, b) => a - b)))
      .fold<int>(0, (p, e) => p + (e.first - e.last).abs()));
}

void day1s() {
  List<List<int>> input =
      IterableZip(getLines().map((l) => l.split('   ').map(int.parse)).toList())
          .toList();
  Map<int, int> freq = {};
  input[1].forEach((e) => freq[e] = (freq[e] ?? 0) + 1);
  print(input[0].fold<int>(0, (p, e) => p + ((freq[e]??0) * e)));
}
