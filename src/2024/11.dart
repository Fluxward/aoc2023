import '../common.dart';

import 'dart:io';

List<Map<int, int>> memo = List.generate(76, (i) => Map());
d11(bool sub) {
  print(stdin
      .readLineSync()!
      .split(" ")
      .map(int.parse)
      .map((i) => countMemo(i, sub ? 75 : 25))
      .reduce((a, b) => a + b));
}

int countMemo(int i, int s) => s == 0
    ? 1
    : memo[s].putIfAbsent(
        i,
        () => i == 0
            ? countMemo(1, s - 1)
            : i.numDigits() % 2 == 0
                ? countMemo(i ~/ exp(10, i.numDigits() ~/ 2), s - 1) +
                    countMemo(i % (exp(10, i.numDigits() ~/ 2)), s - 1)
                : countMemo(i * 2024, s - 1));
