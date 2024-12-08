import 'dart:io';

import '../common.dart';

var res =
    RegExp(r"(?:don\'t\(\)(?:.(?<!do\(\)))*do\(\))|(?:mul\((\d*),(\d*)\))");
var re = RegExp(r"mul\((\d*),(\d*)\)");

int ma(RegExpMatch m) => m.groups([1, 2]).fold(1, (p, f) => p * int.parse(f!));
int mb(RegExpMatch m) => m.group(0)![0] != 'd'
    ? m.groups([1, 2]).fold<int>(1, (p, f) => p * int.parse(f!))
    : 0;

void d3(bool s) => print((s ? res : re)
    .allMatches(getLines().join())
    .fold<int>(0, (p, e) => p + (s ? mb(e) : mb(e))));
