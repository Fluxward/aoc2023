import 'dart:io';

import '../common.dart';

var res =
    RegExp(r"(?:don\'t\(\)(?:.(?<!do\(\)))*do\(\))|(?:mul\((\d*),(\d*)\))");
var re = RegExp(r"mul\((\d*),(\d*)\)");

void d3(bool s) => print((s ? res : re)
    .allMatches(getLines().join())
    .where((e) => !s || e.group(0)![0] != 'd')
    .map((e) =>
        e.groups([1, 2]).map((e) => int.parse(e!)).reduce((v, e) => v * e))
    .reduce((v, e) => v + e));
