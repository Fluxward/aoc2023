import 'dart:io';

import 'package:args/args.dart';

import '1.dart';
import '2.dart';
import '3.dart';
import '4.dart';
import '5.dart';
import '6.dart';
import '7.dart';
import '8.dart';
import '9.dart';

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()
    ..addOption("day", help: "AOC day to solve", abbr: 'd')
    ..addFlag('subset', help: "subset", abbr: 's');

  ArgResults argResults = parser.parse(arguments);
  bool subset = argResults['subset'];

  switch (argResults["day"]) {
    case '1':
      subset ? day1s() : day1();
      break;
    case '2':
      subset ? day2s() : day2();
      break;
    case '3':
      subset ? day3s() : day3();
      break;
    case '4':
      day4(subset);
      break;
    case '5':
      day5(subset);
      break;
    case '6':
      day6(subset);
      break;
    case '7':
      day7(subset);
      break;
    case '8':
      d8(subset);
      break;
    case '9':
      d9(subset);
      break;
  }
}
