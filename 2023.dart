import 'dart:io';

import 'package:args/args.dart';

import '1.dart';
import '10.dart';
import '11.dart';
import '12.dart';
import '13.dart';
import '14.dart';
import '15.dart';
import '16.dart';
import '17.dart';
import '2.dart';
import '3.dart';
import '4.dart';
import '5.dart';
import '6.dart';
import '7.dart';
import '8.dart';
import '9.dart';

List<Function(bool)> jump = [
  d1,
  d2,
  d3,
  d4,
  d5,
  d6,
  d7,
  d8,
  d9,
  d10,
  d11,
  d12,
  d13,
  d14,
  d15,
  d16,
  d17,
];
void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()
    ..addOption("day", help: "AOC day to solve", abbr: 'd')
    ..addFlag('subset', help: "subset", abbr: 's');

  ArgResults argResults = parser.parse(arguments);
  bool s = argResults['subset'];

  int? to = int.tryParse(argResults['day']);
  if (to != null) {
    jump[to - 1](s);
  }
}
