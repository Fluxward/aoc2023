import 'dart:io';

import '../common.dart';

void d3(bool s) => s ? day3s() : day3();
void day3s() {
  print(RegExp(r"(?:don\'t\(\)(?:.(?<!do\(\)))*do\(\))|(?:mul\((\d*),(\d*)\))")
      .allMatches([
        for (String? line = stdin.readLineSync();
            line != null;
            line = stdin.readLineSync())
          line
      ].join())
      .fold<int>(
          0,
          (p, e) =>
              p +
              (e.group(0)![0] != 'd'
                  ? e.groups([1, 2]).fold<int>(1, (p, f) => p * int.parse(f!))
                  : 0)));
}

void day3() {
  print(RegExp(r"mul\((\d*),(\d*)\)").allMatches([
    for (String? line = stdin.readLineSync();
        line != null;
        line = stdin.readLineSync())
      line
  ].join()).fold<int>(
      0, (p, e) => p + e.groups([1, 2]).fold(1, (p, f) => p * int.parse(f!))));
}
