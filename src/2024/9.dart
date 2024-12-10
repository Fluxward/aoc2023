import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

d9(bool s) {
  List<int> input = stdin.readLineSync()!.split("").map(int.parse).toList();

  (s ? d92 : d91)(input);
}

d91(List<int> input) {
  int totalSpace =
      input.whereIndexed((i, e) => i % 2 == 0).reduce((v, w) => v + w);

  int count = 0;
  int i = 0;
  int id = 0;
  int lastId = (input.length) ~/ 2;
  while (i < totalSpace && id <= lastId) {
    count += (id * (2 * i + input[2 * id] - 1) * input[2 * id]) ~/ 2;
    i += input[2 * id];
    input[2 * id] = 0;

    while (input[2 * id + 1] > 0) {
      if (input[2 * lastId] == 0 && lastId-- == id) {
        break;
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

d92(List<int> input) {
  Map<int, HeapPriorityQueue<int>> spaces = {};
  int move(int id, int d, int pos) {
    int minPos = pos;
    int space = -1;
    for (int i = d; i < 10; i++) {
      if ((spaces[i]?.isNotEmpty ?? false) &&
          (spaces[i]?.first ?? pos) < minPos) {
        space = i;
        minPos = spaces[i]!.first;
      }
    }
    if (space >= 0) {
      spaces[space]!.removeFirst();
      space -= d;
      if (space > 0) {
        spaces[space]!.add(minPos + d);
      }
    }

    //print("moving $id at $pos to $minPos");
    return minPos;
  }

  int id = input.length ~/ 2;
  int pos = 0;
  List<int> initialPos = List.generate(input.length, (i) {
    int prevPos = pos;
    pos += input[i];
    return prevPos;
  });

  input.whereIndexed((i, e) => i % 2 == 1).forEachIndexed((i, size) {
    spaces
        .putIfAbsent(size, () => HeapPriorityQueue((a, b) => a - b))
        .add(initialPos[2 * i + 1]);
  });

  print(input
          .whereIndexed((i, e) => i % 2 == 0)
          .toList()
          .reversed
          .map(
              (e) => id * e * (2 * move(id, e, initialPos[2 * (id--)]) + e - 1))
          .reduce((a, b) => a + b) ~/
      2);
}
