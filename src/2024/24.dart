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

bool ne(String s, String c) => s[0] == c;

List<String> swaps = ['dhg', 'z06', 'dpd', 'brk', 'z23', 'bhd', 'nbf', 'z38'];
Set<String> sswaps = swaps.toSet();

//1100110010111101011100001101110011111100100110
class FACell {
  FACell(this.id);
  final int id;

  // S = (X ^ Y) ^ Cin
  // Cout = (XY) + (Cin.(X ^ Y))

  String? cinAlias;
  String? xyxorAlias;
  String? xyandAlias;
  String? cinandxyAlias;
  String? coutAlias;
}

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
      .forEach((l) => print("dbg: btw this is an error: $l"));
  List<FACell> cells = List.generate(zeds.length, (i) => FACell(i));
  Map<String, int> xyand = {};
  Map<String, int> xyxor = {};

  Set<String> foundErrors = {};

  for (List<String> l in gates) {
    if (l[1] != 'XOR' && ne(l[4], 'z')) {
      int i = int.parse(l[4].substring(1, 3));
      if (i < cells.length - 1) {
        foundErrors.add(l[4]);
        print("possible error at ${l.join(' ')}");
      }
    }
    if (ne(l[0], 'x') || ne(l[0], 'y')) {
      int i = int.parse(l[0].substring(1, 3));
      String alias = l[4];
      switch (l[1]) {
        case 'AND':
          if (!ne(l[4], 'z')) {
            cells[i].xyandAlias = l[4];
            xyand[l[4]] = i;
          } else {
            print("possible error at ${l.join(' ')}");
            foundErrors.add(l[4]);
          }

        case 'XOR':
          if (!ne(l[4], 'z')) {
            cells[i].xyxorAlias = l[4];
            xyxor[l[4]] = i;
          } else if (i != 0) {
            print("possible error at ${l.join(' ')}");
          }
        case 'OR':
        default:
          print("invalid input: $l");
      }
    }
  }

  for (List<String> l in gates) {
    if (xyand.containsKey(l[0])) {}
  }

  for (int i = 0; i < cells.length; i++) {
    if (cells[i].xyandAlias == null) {
      print("cell $i missing x AND y");
    }
    if (cells[i].xyxorAlias == null) {
      print("cell $i missing x OR y");
    }
  }
  print("found errors: $foundErrors");

  int z = sparse(zeds);
  int y = sparse(whys);
  int x = sparse(xes);

  print(z);

  print(" ${x.toRadixString(2)}");
  print(" ${y.toRadixString(2)}");
  print(z.toRadixString(2));
  print((x + y).toRadixString(2));

  print(swaps.sorted().join(','));
}
