import 'dart:collection';

import 'package:aoc/common.dart';
import 'package:collection/collection.dart';

List<String> inp = getLines();
int spl = inp.indexOf('');

Map<String, bool> iv = Map.fromEntries(inp
    .take(spl)
    .map((s) => s.split(': '))
    .map((l) => MapEntry(l.first, l.last == '1')));

Map<String, bool Function(bool, bool)> jmp = {
  'XOR': (a, b) => a != b,
  'OR': (a, b) => a || b,
  'AND': (a, b) => a && b
};

int sparse(Set<String> s) => s
    .toList()
    .sorted()
    .reversed
    .fold<int>(0, (p, e) => (p << 1) + (iv[e]! ? 1 : 0));

bool ze(String s) => s[0] == 'z';
bool xe(String s) => s[0] == 'x';
bool ye(String s) => s[0] == 'y';

List<int> errors = [6];

List<List<String>> swaps = [
  ['dhg', 'z06'],
  ['dpd', 'brk'],
  ['z23', 'bhd'],
  ['nbf', 'z38']
];

void d24(bool sub) {
  Queue<List<String>> q =
      Queue.from(inp.skip(spl + 1).map((s) => s.split(' ')));

  Set<String> zeds = {};
  Set<String> xes = {};
  Set<String> whys = {};
  while (q.isNotEmpty) {
    List<String> c = q.removeFirst();
    zeds.addAll(c.where(ze));
    xes.addAll(c.where(xe));
    whys.addAll(c.where(ye));
    if (iv.containsKey(c.first) && iv.containsKey(c[2])) {
      iv[c.last] = jmp[c[1]]!(iv[c[0]]!, iv[c[2]]!);
    } else {
      q.add(c);
    }
  }

  int z = sparse(zeds);
  int y = sparse(whys);
  int x = sparse(xes);

  List<String> sx = xes.toList().sorted();
  List<String> sy = whys.toList().sorted();
  List<String> sz = zeds.toList().sorted();

  Map<String, int> id = {}
    ..addEntries(sx.indexed.map((i) => MapEntry(i.$2, i.$1)))
    ..addEntries(sz.indexed.map((i) => MapEntry(i.$2, i.$1)))
    ..addEntries(sy.indexed.map((i) => MapEntry(i.$2, i.$1)));

  print(z);

  List<String> ors = List.filled(sx.length, "");
  List<String> ans = List.filled(sx.length, "");
  List<String> xos = List.filled(sx.length, "");

  Map<String, Map<String, (String, String)>> rops = {};
  Map<String, Map<String, (String, String)>> ops = {};
  for (List<String> line in inp.skip(spl + 1).map((s) => s.split(" "))) {
    String o1 = line[0];
    String o2 = line[2];
    String o3 = line[4];
    rops.putIfAbsent(o3, () => {}).putIfAbsent(o2, () => (o1, line[1]));
    rops.putIfAbsent(o3, () => {}).putIfAbsent(o1, () => (o2, line[1]));
    ops.putIfAbsent(o1, () => {}).putIfAbsent(o2, () => (o3, line[1]));
    ops.putIfAbsent(o2, () => {}).putIfAbsent(o1, () => (o3, line[1]));

    if (id.containsKey(o1)) {
      int i = id[o1]!;
      switch (line[1]) {
        case 'AND':
          ans[i] = o3;
        case 'OR':
          ors[i] = o3;
        case 'XOR':
          xos[i] = o3;
        default:
      }
    }
  }

  List<String> sumRHS = [];

  for (int i = 0; i < ans.length; i++) {
    String oper = xos[i];
    String? roper = ops[oper]?.values.first.$1;
    sumRHS.add(roper ?? "None");
  }

  List<String> sums = [];

  for (int i = 0; i < sumRHS.length; i++) {
    String oper = sumRHS[i];
    String? roper = ops[oper]?.values.first.$1;
    sums.add(roper ?? "None");
    print("Co${i - 1}: $roper ");
    print("S$i: ${sx[i]} x ${sy[i]} x $roper");
  }

  StringBuffer mapGate(String gate, int nest) {
    StringBuffer buf = StringBuffer();
    if (!rops.containsKey(gate)) {
      return buf;
    }
    for (int i = 0; i < nest; i++) {
      buf.write(' ');
    }
    var oe = rops[gate]!;
    var left = oe.keys.first;
    var op = oe[left]!.$2;
    var right = oe[left]!.$1;
    buf.write('$gate <- $left $op $right:\n');
    buf.write(mapGate(left, nest + 1));
    buf.write(mapGate(right, nest + 1));
    return buf;
  }

  for (var z in sz) {
    print(mapGate(z, 0));
  }

  print(" ${x.toRadixString(2)}");
  print(" ${y.toRadixString(2)}");
  print(z.toRadixString(2));
  print((x + y).toRadixString(2));

  print(swaps.flattened.sorted().join(','));
}
