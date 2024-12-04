import 'dart:io';

import 'package:collection/collection.dart';

void d1(bool s) {
  s ? day1s() : day1();
}

void day1() {
  List<List<int>> input = [[], []];
  for (String? line = stdin.readLineSync();
      line != null;
      line = stdin.readLineSync()) {
        line.split('   ').map((e) => int.parse(e)).forEachIndexed((i, e) => input[i].add(e));
      }

  input.forEach((e) => e.sort());

  print(input[1].foldIndexed<int>(0, (i, p, e) => p + (e - input[0][i]).abs()));
}

void day1s() {
  List<List<int>> input = [[], []];
  for (String? line = stdin.readLineSync();
      line != null;
      line = stdin.readLineSync()) {
        line.split('   ').map((e) => int.parse(e)).forEachIndexed((i, e) => input[i].add(e));
      }

  Map<int, int> freq = {};
  input[1].forEach((e) => freq[e] = (freq[e] ?? 0) + 1);
  print(input[0].fold<int>(0, (p, e) => p + ((freq[e]??0) * e)));
}
