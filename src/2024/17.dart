import 'package:aoc/common.dart';
import 'package:collection/collection.dart';

class Comp {
  List<int> reg;
  List<int> prog;
  int ip = 0;

  List<int> output = [];
  late List<(int, bool) Function()> ops;

  int get combo => prog[ip + 1] < 4 ? prog[ip + 1] : reg[prog[ip + 1] - 4];

  Comp(this.reg, this.prog) {
    ops = [
      () => (reg[0] = (reg[0] >> combo), false),
      () => (reg[1] ^= prog[ip + 1], false),
      () => (reg[1] = combo % 8, false),
      () => (reg[0] != 0) ? (ip = prog[ip + 1], true) : (0, false),
      () => (reg[1] ^= reg[2], false),
      () {
        output.add(combo % 8);
        return (0, false);
      },
      () => (reg[1] = (reg[0] >> combo), false),
      () => (reg[2] = (reg[0] >> combo), false)
    ];
  }

  compute() {
    output.clear();
    while (ip < prog.length) {
      if (!ops[prog[ip]]().$2) {
        ip += 2;
      }
    }
  }

  reset(int A) {
    ip = 0;
    reg[0] = A;
    reg[1] = 0;
    reg[2] = 0;
  }
}

void d17(bool sub) {
  List<String> input = getLines();
  Comp c = Comp(
      input.take(3).map((s) => s.split(" ").last).map(int.parse).toList(),
      input.last.split(" ").last.split(",").map(int.parse).toList())
    ..compute();
  print("Part a: ${c.output.join(",")}");

  if (!sub) return;

  List<int> sols = [];
  bool dfs(int cur) {
    bool found = false;
    sols.add(cur);
    int sol = sols.reduce((a, b) => 8 * a + b);
    c..reset(sol)..compute();
    if (c.prog
        .whereIndexed((i, e) => i >= c.prog.length - c.output.length)
        .foldIndexed(true, (i, p, e) => p && c.output[i] == e)) {
      if (found = c.output.length == c.prog.length) {
        print("Part b: $sol");
      } else {
        for (int i = 0; i < 8 && !(found = found || dfs(i)); i++) {}
      }
    }

    sols.removeLast();
    return found;
  }

  for (int a = 0; a < 8 && !dfs(a); a++) {}
}
