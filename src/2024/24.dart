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
    .sorted((a, b) => -a.compareTo(b))
    .fold<int>(0, (p, e) => (p << 1) + (iv[e]! ? 1 : 0));

bool ne(String s, String c) => s[0] == c;

List<String> swaps = ['dhg', 'z06', 'dpd', 'brk', 'z23', 'bhd', 'nbf', 'z38'];
Set<String> sswaps = swaps.toSet();

//1100110010111101011100001101110011111100100110
List<String> gates = Set<String>.from(inp
        .skip(spl + 1)
        .map((s) => s.split(' '))
        .map((s) => s.whereIndexed((i, s) => i % 2 == 0))
        .flattened)
    .toList();
Map<String, int> gids = {for (var e in gates.indexed) e.$2: e.$1};

void d24(bool sub) {
  List<List<String>> gates =
      inp.skip(spl + 1).map((s) => s.split(' ')).toList();
  Queue<List<String>> q = Queue.from(gates);

  Set<String> zeds = {};
  Set<String> xes = {};
  Set<String> whys = {};
  while (q.isNotEmpty) {
    List<String> c = q.removeFirst();
    zeds.addAll(c.where((String s) => ne(s, 'z')));
    xes.addAll(c.where((String s) => ne(s, 'x')));
    whys.addAll(c.where((String s) => ne(s, 'y')));
    if (iv.containsKey(c.first) && iv.containsKey(c[2])) {
      iv[c.last] = jmp[c[1]]!(iv[c[0]]!, iv[c[2]]!);
    } else {
      q.add(c);
    }
  }

  gates
      .where((l) => sswaps.contains(l[4]))
      .forEach((l) => print("dbg: btw this output is an error: $l"));
  gates.where((l) => sswaps.contains(l[0])).forEach((l) => print("dbg: lhs is error: $l"));
  gates.where((l) => sswaps.contains(l[2])).forEach((l) => print("dbg: rhs is error: $l"));
  
  List<(int, List<String>)> orGates =
      gates.indexed.where((i) => i.$2[1] == 'OR').toList();
  List<(int, List<String>)> xorGates =
      gates.indexed.where((i) => i.$2[1] == 'XOR').toList();
  List<(int, List<String>)> andGates =
      gates.indexed.where((i) => i.$2[1] == 'AND').toList();

  Set<String> foundErrors = {};

  int ip(String s) => int.parse(s.substring(1, 3));

  // Step 1. find X and Y elements and caxy elements as outputs
  Set<String> xyandOut = {}; // might have error.
  Set<String> caxyOut = {}; // might have error.
  Set<String> coutOuts = {}; // might have errors.

  Set<String> caxyIns = {}; // everything in here is either an x XOR y input or a Cin input.

  for (var v in andGates) {
    List<String> l = v.$2;
    if (ne(l[0], 'x') || ne(l[0], 'y')) {
      if (ip(l[0]) == 0) {
        // this is actually the carryout of gate 0
        coutOuts.add(l[4]);
      } else {
        // supposed x y and gate.
        xyandOut.add(l[4]);
      }
    } else {
      caxyOut.add(l[4]);
      caxyIns.add(l[0]);
      caxyIns.add(l[2]);
    }
  }

  Set<String> xyxorOut = {}; // might have error
  Set<String> sumOut = {}; // might have error
  Set<String> sumIns = {}; // everything in here is either an x XOR y input or a Cin input.
  // Step 2. find x xor y outputs OR sum outputs.
  for (var v in xorGates) {
    List<String> l = v.$2;
    if (ne(l[0], 'x') || ne(l[0], 'y')) {
      if (ip(l[0]) == 0) {
        // actually the output bit of gate 0
        sumOut.add(l[4]);
      } else {
        xyxorOut.add(l[4]);
      }
    } else {
      sumOut.add(l[4]);
      sumIns.add(l[2]);
      sumIns.add(l[0]);
    }
  }

  Set<String> coutIns = {}; // everything in here is either an x AND y input or a caxy input.
  for (var v in orGates) {
    List<String> l = v.$2;
    if (ne(l[4], 'z') && ip(l[4]) == zeds.length-1) {
      // this is actually a sum.
      sumOut.add(l[4]);
    } else {
      coutOuts.add(l[4]);
    }
    coutIns.add(l[0]);
    coutIns.add(l[2]);
  }

  foundErrors.addAll(xyxorOut.difference(sumIns));
  foundErrors.addAll(xyxorOut.difference(caxyIns));
  foundErrors.addAll(caxyOut.difference(coutIns));
  foundErrors.addAll(xyandOut.difference(coutIns));
  foundErrors.addAll(coutOuts.difference(sumIns));
  foundErrors.addAll(coutOuts.difference(caxyIns));
  foundErrors.addAll(caxyIns.intersection(xyandOut));
  foundErrors.addAll(caxyIns.intersection(caxyOut));
  foundErrors.addAll(caxyIns.intersection(sumOut));
  foundErrors.addAll(sumIns.intersection(xyandOut));
  foundErrors.addAll(sumIns.intersection(caxyOut));
  foundErrors.addAll(sumIns.intersection(sumOut));
  foundErrors.addAll(coutIns.intersection(xyxorOut));
  foundErrors.addAll(coutIns.intersection(coutOuts));
  foundErrors.addAll(coutIns.intersection(sumOut));

  print(foundErrors.sorted().join(','));

  int z = sparse(zeds);
  print(z);
}
