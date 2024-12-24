
import 'dart:collection';

import 'package:aoc/common.dart';
import 'package:collection/collection.dart';

List<String> inp = getLines();
int spl = inp.indexOf('');

Map<String, bool> iv = Map.fromEntries(inp.take(spl).map((s) => s.split(': ')).map((l) => MapEntry(l.first, l.last == '1')));

Map<String, bool Function(bool, bool)> jmp = {
  'XOR' : (a, b) => a != b,
  'OR' : (a, b) => a || b,
  'AND' : (a, b) => a && b
};

bool ze(String s) => s[0] == 'z';

void d24(bool sub) {
  Queue<List<String>> q = Queue.from(inp.skip(spl + 1).map((s) => s.split(' '))); 

  Set<String> zeds = {};
  while (q.isNotEmpty) {
    List<String> c = q.removeFirst();
    zeds.addAll(c.where(ze));
    if (iv.containsKey(c.first) && iv.containsKey(c[2])) {
      iv[c.last] = jmp[c[1]]!(iv[c[0]]!, iv[c[2]]!);
    } else {
      q.add(c);
    }
  }

  print(zeds.toList().sorted().reversed.fold<int>(0, (p, e) => (p << 1) + (iv[e]! ? 1 : 0)));
}