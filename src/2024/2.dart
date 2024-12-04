import 'dart:io';

import 'package:collection/collection.dart';

void d2(bool s) => s ? day2s() : day2();

bool isSafe(List<int> l) {
  bool safe = false;
  safe = safe || l.foldIndexed<bool>(true, (i, p, e) => p && (i < 1 || (0 < (e - l[i-1]).abs() && 4 > (e - l[i-1]).abs())));

  safe = safe && (l.foldIndexed<bool>(true, (i, p, e) => p && (i < 1 || l[i-1] < e)) || l.foldIndexed<bool>(true, (i, p, e) => p && (i < 1 || l[i-1] > e)));

  return safe;
}

bool isSafeWithSkip(List<int> l) {
  if (isSafe(l)) return true;

  for (int i = 0; i < l.length; i++) {
    if (isSafe([...l.whereNotIndexed((ind, e) => i == ind)])) return true;
  }

  return false;
}

void day2() {
  int count = 0;
  for (String? line = stdin.readLineSync();
      line != null;
      line = stdin.readLineSync()) {
    List<int> report = [...line.split(" ").map((e) => int.parse(e))];
    count = isSafe(report) ? count + 1 : count;
  }
  print(count);
}

void day2s() {
  int count = 0;
  for (String? line = stdin.readLineSync();
      line != null;
      line = stdin.readLineSync()) {
    List<int> report = [...line.split(" ").map((e) => int.parse(e))];
    count = isSafeWithSkip(report) ? count + 1 : count;
  }
  print(count);
}
