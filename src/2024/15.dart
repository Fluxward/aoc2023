
import 'package:collection/collection.dart';

import '../common.dart';

List<String> input = getLines();
int splitIndex = input.indexOf("");
List<List<bool>> wwalls = input
    .take(splitIndex)
    .map((l) => l
        .split("")
        .map((m) => m == '#' ? [true, true] : [false, false])
        .flattened
        .toList())
    .toList();
List<List<bool>> lboxes = input
    .take(splitIndex)
    .map((l) => l
        .split("")
        .map((m) => m == 'O' ? [true, false] : [false, false])
        .flattened
        .toList())
    .toList();
List<List<bool>> rboxes = input
    .take(splitIndex)
    .map((l) => l
        .split("")
        .map((m) => m == 'O' ? [false, true] : [false, false])
        .flattened
        .toList())
    .toList();

  bool lcanMove(P p, dir d) {
    P n = d + p;
    if (n.r == p.r) {
      if ((d == dir.r && wwalls.at(d + n)) || (d == dir.l) && wwalls.at(n)) return false;

      if (!lboxes.at(d + n) || lcanMove(d + n, d)) {
        lmove(p, d);
        return true;
      }
    } else {
      if (wwalls.at(n) || wwalls.at(dir.r + n)) return false;
      
      if ((!rboxes.at(n) || lcanMove(dir.l + n, d)) &&
        (!lboxes.at(n) || lcanMove(n, d)) &&
        (!lboxes.at(dir.r + n) || lcanMove(dir.r + n, d))) {
        lmove(p, d);
        return true;
      }
    }

    return false;
  }

  bool canMove(P p, dir d) {
    P n = d + p;
    return (!wwalls.at(n)) && (!lboxes.at(n) || lcanMove(n, d)) && (!rboxes.at(n) || lcanMove(dir.l + n, d));
  }

  void lmove(P p, dir d) {
    if (!lboxes.at(p)) return;

    lboxes[p.r][p.c] = false;
    rboxes[p.r][p.c + 1] = false;

    P n = d + p;

    lboxes[n.r][n.c] = true;
    rboxes[n.r][n.c + 1] = true;
  }

d15(bool sub) {
  sub ? b15() : a15();  
}

b15() {
  

  int rr, rc;
  rr = input.indexWhere((s) => s.contains("@"));
  rc = 2*input[rr].indexOf('@');
  P robot = P(rr, rc);

  void printState(dir? move) => wwalls.forEachIndexed( (r, l) => print(l.mapIndexed((c, w) => w ? "#" : lboxes[r][c] ? "[" : rboxes[r][c] ? "]" : robot == P(r, c) ? move??'@' : '.').join()));

  //printState(null);
  List<dir> moves = input.skip(splitIndex + 1).map((s) => s.split("").map((c) => c == '^' ? dir.u : c == 'v' ? dir.d : c == '<' ? dir.l : dir.r)).flattened.toList();

  int count = 0;
  for (dir move in moves) {
    //printState(move);
    if (canMove(robot, move)) {
      robot = move + robot;
    }
    count++;
  }

  print(count);

  //printState(null);
  print(lboxes.mapIndexed((r, l) => l.mapIndexed((c, b) => b ? 100 * r + c : 0).reduce((a, b) => a + b)).reduce((a, b) => a + b));
  print(rboxes.mapIndexed((r, l) => l.mapIndexed((c, b) => b ? 100 * r + c : 0).reduce((a, b) => a + b)).reduce((a, b) => a + b));
}

a15() {
  List<List<bool>> walls = input.take(splitIndex).map((l) => l.split("")).map((l) => l.map((m) => m == '#').toList()).toList();
  List<List<bool>> boxes = input.take(splitIndex).map((l) => l.split("")).map((l) => l.map((m) => m == 'O').toList()).toList();
  int rr, rc;
  rr = input.indexWhere((s) => s.contains("@"));
  rc = input[rr].indexOf('@');

  P robot = P(rr, rc);

  List<dir> moves = input.skip(splitIndex + 1).map((s) => s.split("").map((c) => c == '^' ? dir.u : c == 'v' ? dir.d : c == '<' ? dir.l : dir.r)).flattened.toList();
  bool doMove(P p, dir d) {
    P next = d + p;
    //print("trying to move $p => $next");  
    if (walls.at(d + p)) return false;

    if (!boxes.at(d + p) || doMove(d + p, d)) {
      if (boxes[p.r][p.c]) {
        boxes[next.r][next.c] = true;
        boxes[p.r][p.c] = false;
      }

      return true;
    }
    return false;
  } 

  for (dir move in moves) {
    //walls.forEachIndexed( (r, l) => print(l.mapIndexed((c, w) => w ? "#" : boxes[r][c] ? "O" : robot == P(r, c) ? move.toString() : '.').join()));
    if (doMove(robot, move)) {
      robot = move + robot;
    }
  }

  walls.forEachIndexed(
    (r, l) => print(l.mapIndexed((c, w) => w ? "#" : boxes[r][c] ? "O" : robot == P(r, c) ? '@' : '.').join())
  );
  print(boxes.mapIndexed((r, l) => l.mapIndexed((c, b) => b ? 100 * r + c : 0).reduce((a, b) => a + b)).reduce((a, b) => a + b));
}

