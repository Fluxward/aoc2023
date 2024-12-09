import 'dart:io';

import 'package:collection/collection.dart';


d9(bool s) {
  List<int> input = stdin.readLineSync()!.split("").map(int.parse).toList();
  var data = input.whereIndexed((i, e) => (i % 2) == 0);
  var space = input.whereIndexed((i, e) => (i % 2) == 1);

  int pdl = 0;
  int pdr = data.length - 1;
  int ps = 0;
  int index = 0;

  int totalSpace = input.reduce((v, w) => v + w);
}


