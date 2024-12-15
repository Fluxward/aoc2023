import 'package:flutter/material.dart';
import '../../common.dart';

import 'package:collection/collection.dart';

import 'in15.dart';

List<List<bool>> wwalls = input
    .map((l) => l
        .split("")
        .map((m) => m == '#' ? [true, true] : [false, false])
        .flattened
        .toList())
    .toList();
List<List<bool>> lboxes = input
    .map((l) => l
        .split("")
        .map((m) => m == 'O' ? [true, false] : [false, false])
        .flattened
        .toList())
    .toList();
List<List<bool>> rboxes = input
    .map((l) => l
        .split("")
        .map((m) => m == 'O' ? [false, true] : [false, false])
        .flattened
        .toList())
    .toList();

bool lcanMove(P p, dir d) {
  P n = d + p;
  if (n.r == p.r) {
    if ((d == dir.r && wwalls.at(d + n)) || (d == dir.l) && wwalls.at(n))
      return false;

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
  return (!wwalls.at(n)) &&
      (!lboxes.at(n) || lcanMove(n, d)) &&
      (!rboxes.at(n) || lcanMove(dir.l + n, d));
}

void lmove(P p, dir d) {
  if (!lboxes.at(p)) return;

  lboxes[p.r][p.c] = false;
  rboxes[p.r][p.c + 1] = false;

  P n = d + p;

  lboxes[n.r][n.c] = true;
  rboxes[n.r][n.c + 1] = true;
}

List<dir> moves = movesMain
    .split("")
    .map((c) => c == '^'
        ? dir.u
        : c == 'v'
            ? dir.d
            : c == '<'
                ? dir.l
                : dir.r)
    .toList();

int rr = 0;
int rc = 0;
P robot = P(rr, rc);

void init15() {
  rr = input.indexWhere((s) => s.contains("@"));
  rc = 2 * input[rr].indexOf('@');
robot = P(rr, rc);
}

int curMove = 0;
void step() {
  if (curMove == moves.length) return;

  dir m = moves[curMove++];
  if (canMove(robot, m)) {
    robot = m + robot;
  }
}

int gr() => lboxes
      .mapIndexed((r, l) =>
          l.mapIndexed((c, b) => b ? 100 * r + c : 0).reduce((a, b) => a + b))
      .reduce((a, b) => a + b);

class Plotter15 extends StatelessWidget {
  const Plotter15({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: List.generate(wwalls.length, (r) {
        return Row(
          children: List.generate(wwalls[r].length, (c) {
            return SizedBox(
                width: 20,
                height: 20,
                child: wwalls[r][c]
                    ? const DecoratedBox(
                        decoration: BoxDecoration(color: Colors.black))
                    : lboxes[r][c]
                        ? const DecoratedBox(
                            decoration: BoxDecoration(color: Colors.lime))
                        : rboxes[r][c]
                            ? const DecoratedBox(
                                decoration: BoxDecoration(color: Colors.red))
                            : P(r, c) == robot
                                ? const DecoratedBox(
                                    decoration:
                                        BoxDecoration(color: Colors.blue))
                                : const DecoratedBox(
                                    decoration:
                                        BoxDecoration(color: Colors.white)));
          }),
        );
      }),
    );
  }
}