import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

d9(bool s) {
  List<int> input = stdin.readLineSync()!.split("").map(int.parse).toList();
  var data = input.whereIndexed((i, e) => (i % 2) == 0).toList();
  var space = input.whereIndexed((i, e) => (i % 2) == 1).toList();

  int totalSpace = data.reduce((v, w) => v + w);

  int count = 0;
  int i = 0;
  int id = 0;
  int lastId = data.length - 1;
  while (i < totalSpace && id < lastId) {
    count += (id * (2 * i + data[id] - 1) * data[id]) ~/ 2;
    i += data[id];
    data[id] = 0;

    while (space[id] > 0) {
      if (data[lastId] == 0 && lastId-- == id) {
        print(count);
        return;
      }
      int dif = min(space[id], data[lastId]);
      count += (lastId * (2 * i + dif - 1) * dif) ~/ 2;

      space[id] -= dif;
      data[lastId] -= dif;
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
