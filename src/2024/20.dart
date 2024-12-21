import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';

import '../common.dart';

List<String> input = getLines();
List<List<bool>> walls = input.map(( l) => l.split("").map((s) => s == "#").toList()).toList();

final P s = input.pointOf('S');
final P e = input.pointOf('E');

extension NextP on P {
 Iterable<P> get next =>
      dir.values.map((d) => d + this).where((p) => p.x >= 0 && p.y >= 0 && p.x < walls.length && p.y < walls[0].length);

  Set<P> get subN {
    Set<P> boundary = {};

    Set<P> seen = {this};

    Set<P> front = {this};
    for (int i = 0; i < 20; i++) {
      Set<P> nextFront = Set.from(front.map((n) => n.next).whereNot(seen.contains).flattened);
      if (front.isEmpty || nextFront.isEmpty) break;
      seen.addAll(nextFront);
      //nextFront.removeWhere((p) {
      //  bool t = !walls.at(p);
      //  if (t) boundary[p] = i;
      //  return t;
      //});
      boundary.addAll(nextFront.whereNot(walls.at));
      front = nextFront;
    }

    return boundary;
  }
}

List<P> mainPath = () {
  P c = s;
  List<P> path = [];
  Set<P> seen = {};
  while (c != e) {
    seen.add(c);
    path.add(c);
    c = c.next.whereNot(walls.at).whereNot(seen.contains).first;
  }

  return path..add(e);
}();

void d20(bool sub) {
  Map<P, int> m = {for (var i in mainPath.indexed) i.$2 : i.$1};

  int count = 0;

  for (int i = 0; i < mainPath.length; i++) {
    Iterable<P> nn = mainPath[i].next.where(walls.at).map((p) => p.next.whereNot(walls.at).where((q) => m.containsKey(q))).flattened;

    for (P n in nn) {
      if (m[n]! - i >= 101) count++;
    }
  } 
  print(count);

  //Set<P> sc = s.subN;

  //walls.mapIndexed((r, l) => l.mapIndexed((c, x) => P(r,c) == s ? 'S' : x ? '#' : sc.contains(P(r,c)) ? 'O' : '.').join()).forEach(print);
  
  int count2 = 0;

  for (int i = 0; i < mainPath.length; i++) {
    for (P p in mainPath[i].subN) {
      if (m[p]! - i - p.mhd(mainPath[i]) >= 100) count2++;
    }
  }

  print(count2);
}
