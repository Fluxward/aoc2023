import 'dart:io';

import 'package:args/args.dart';

import '1.dart';
import '2.dart';

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
    case '2':
      subset ? day2s() : day2();
      break;
  }
}
