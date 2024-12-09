import 'dart:io';

import 'package:collection/collection.dart';

d9(bool s) {
  List<int> input = stdin.readLineSync()!.split("").map(int.parse).toList();
  var data = input.whereIndexed((i, e) => (i % 2) == 0).toList();
  var space = input.whereIndexed((i, e) => (i % 2) == 1).toList();

  var rdi = data.reversed.iterator;
  var spi = space.iterator;

  int totalSpace = data.reduce((v, w) => v + w);

  int count = 0;
  int i = 0;
  int id = 0;
  int lastId = data.length - 1;
  List<String> out = [];
  while (i < totalSpace && id <= lastId) {
    while (data[id] > 0) {
      count += id * i;
      data[id]--;
      i++;
    }

    while (space[id] > 0) {
      space[id]--;
      while (data[lastId] == 0) {
        lastId--;
        if (lastId < id) {

          print(count);
          return;
        }
      }
      count += lastId * i;
      data[lastId]--;
      // out.add("$lastId");
      i++;
      // print(out);
    }

    // print("next");
    id++;
  }

  print(count);
}

d92() {
  List<int> input = stdin.readLineSync()!.split("").map(int.parse).toList();
  var data = input.whereIndexed((i, e) => (i % 2) == 0).toList();
  var space = input.whereIndexed((i, e) => (i % 2) == 1).toList();

}