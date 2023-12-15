import 'dart:math';

import 'common.dart';

class Race {
  final int t;
  final int d;

  Race(this.t, this.d);
}

d6(bool subset) {
  List<String> lines = getLines();

  List<int> ts = stois(lines[0].split(": ")[1], sep: ' ');
  List<int> ds = stois(lines[1].split(": ")[1], sep: ' ');

  List<Race> races =
      List.generate(ts.length, (index) => Race(ts[index], ds[index]));

  !subset ? d6a(races) : d6b(lines);
}

int ways(Race r) {
  Stopwatch s = Stopwatch()..start();
  // direct calculation of ways
  int ws = 0;
  for (int i = 0; i <= r.t; i++) {
    ws += ((r.t - i) * i) > r.d ? 1 : 0;
  }

  Duration brute = s.elapsed;
  s.reset();
  // inequality based solution
  // the determinant of the quadratic is the size of the interval
  double det = sqrt((r.t * r.t) - 4 * r.d);

  // need a fudge factor to deal with integer endpoints
  double fudge = 0.00001;

  // <insert explanation here>
  int a = ((fudge - det) / 2).ceil();
  int b = ((-fudge + det) / 2).floor();

  Duration maths = s.elapsed;

  // print both answers to see that they are correct
  print(
      "brute force took: ${brute.inMicroseconds}, maths took: ${maths.inMicroseconds}");
  print("$ws, ${b - a + 1}");

  return ws;
}

d6a(List<Race> races) {
  print(races.fold<int>(1, (p, e) => p *= ways(e)));
}

d6b(List<String> lines) {
  print(ways(Race(stoi(lines[0].split(": ")[1].replaceAll(' ', ''))!,
      stoi(lines[1].split(": ")[1].replaceAll(' ', ''))!)));
}
