import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

d9(bool s) {
  List<int> input = stdin.readLineSync()!.split("").map(int.parse).toList();

  int totalSpace =
      input.whereIndexed((i, e) => i % 2 == 0).reduce((v, w) => v + w);

  int count = 0;
  int i = 0;
  int id = 0;
  int lastId = (input.length - 1) ~/ 2;
  while (i < totalSpace && id < lastId) {
    count += (id * (2 * i + input[2 * id] - 1) * input[2 * id]) ~/ 2;
    i += input[2 * id];
    input[2 * id] = 0;

    while (input[2 * id + 1] > 0) {
      if (input[2 * lastId] == 0 && lastId-- == id) {
        print(count);
        return;
      }
      int dif = min(input[2 * id + 1], input[2 * lastId]);
      count += (lastId * (2 * i + dif - 1) * dif) ~/ 2;

      input[2 * id + 1] -= dif;
      input[2 * lastId] -= dif;
      i += dif;
    }
    id++;
  }

  print(count);
}

d92() {
  List<int> input = stdin.readLineSync()!.split("").map(int.parse).toList();
  var data = input.whereIndexed((i, e) => (i % 2) == 0).toList();
  var space = input.whereIndexed((i, e) => (i % 2) == 1).toList();
}
