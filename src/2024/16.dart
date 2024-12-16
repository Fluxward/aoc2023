import '../common.dart';

import '4.dart';

void d16(bool sub) {
  sub ? b() : a();
}

void a() {
  Map<GridVec, int> m = {};

  List<String> input = getLines();
  List<List<bool>> walls =
      input.map((s) => s.split("").map((c) => c == '#').toList()).toList();

  P s = input.pointOf('S');
  P e = input.pointOf('E');

  print([s, e].join('=>'));
}

void b() {}
