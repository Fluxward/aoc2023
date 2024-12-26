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
abstract class Gate {
  String? alias;
  
  bool gateEquals<T extends Gate>(Object o) => o is T && o.alias == alias;
}

class Cin extends Gate {
  Cout? inCout;
  Sum? outSum;
  CinAndXY? outCAXY;

  @override
  bool operator==(o) => gateEquals<Cin>(o);
  @override
  int get hashCode => Object.hashAll([alias, 'Cin']);
  
  
}

class Sum extends Gate {
  XyXor? inXyX;
  Cin? inCin;

  @override
  bool operator==(o) => gateEquals<Sum>(o);
  @override
  int get hashCode => Object.hashAll([alias, 'Sum']);
}

class XyXor extends Gate {
  @override
  String? alias;

  CinAndXY? outCAXY;
  Sum? outSum;
}

class XyAnd implements Gate {
  @override
  String? alias;

  Cout? out;

  bool equals(Gate other)
}

class CinAndXY implements Gate {
  @override
  String? alias;

  Cout? out;

  XyXor? inXyX;
  Cin? inCin;
}

class Cout implements Gate {
  @override
  String? alias;

  Cin? out;

  XyAnd? inXY;
  CinAndXY? inCAXY;
}

Map<String, Gate> allGates = {};

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

  List<Cin> cins = List.generate(zeds.length, (i) => Cin());
  List<Sum> sumGs = List.generate(zeds.length, (i) => Sum());
  List<XyXor> xyxors = List.generate(zeds.length, (i) => XyXor());
  List<XyAnd> xyands = List.generate(zeds.length, (i) => XyAnd());
  List<CinAndXY> caxys = List.generate(zeds.length, (i) => CinAndXY());
  List<Cout> cOuts = List.generate(zeds.length, (i) => Cout());

  gates
      .where((l) => sswaps.contains(l[4]))
      .forEach((l) => print("dbg: btw this is an error: $l"));

  Map<String, int> xyand = {};
  Map<String, int> xyxor = {};
  Map<String, int> couts = {};

  List<(int, List<String>)> orGates =
      gates.indexed.where((i) => i.$2[1] == 'OR').toList();
  List<(int, List<String>)> xorGates =
      gates.indexed.where((i) => i.$2[1] == 'XOR').toList();
  List<(int, List<String>)> andGates =
      gates.indexed.where((i) => i.$2[1] == 'AND').toList();

  List<(int, List<String>)> xyxorGates =
      xorGates.where((i) => ne(i.$2[0], 'x') || ne(i.$2[2], 'x')).toList();
  List<(int, List<String>)> xyandGates =
      andGates.where((i) => ne(i.$2[0], 'x') || ne(i.$2[2], 'x')).toList();
  List<(int, List<String>)> sums =
      xorGates.where((i) => !ne(i.$2[0], 'x') && !ne(i.$2[2], 'x')).toList();

  Set<String> foundErrors = {};

  int ip(String s) => int.parse(s.substring(1, 3));

  for (int i = 0; i < zeds.length; i++) {
    cins[i].inCout = (i > 0) ? cOuts[i - 1] : null;
    cins[i].outSum = sumGs[i];
    cins[i].outCAXY = caxys[i];
    sumGs[i].inCin = cins[i];
    sumGs[i].inXyX = xyxors[i];
    xyxors[i].outSum = sumGs[i];
    xyxors[i].outCAXY = caxys[i];
    xyands[i].out = cOuts[i];
    caxys[i].inXyX = xyxors[i];
    caxys[i].inCin = cins[i];
    caxys[i].out = cOuts[i];
    cOuts[i].inCAXY = caxys[i];
    cOuts[i].inXY = xyands[i];
    if (i < zeds.length - 1) cOuts[i].out = cins[i + 1];
  }

  for (var v in xyandGates) {
    List<String> l = v.$2;
    int i = ip(l[0]);
    if (!ne(l[4], 'z')) {
      xyands[i].alias = l[4];
      xyand[l[4]] = i;

      Gate g = allGates.putIfAbsent(l[4], () => xyands[i]);
      if (g)
    } else {
      print("possible error at ${l.join(' ')}");
      foundErrors.add(l[4]);
    }
  }

  for (var v in xyxorGates) {
    List<String> l = v.$2;
    int i = ip(l[0]);
    if (!ne(l[4], 'z')) {
      xyxors[i].alias = l[4];
      xyxor[l[4]] = i;
    } else if (i != 0) {
      print("possible error at ${l.join(' ')}");
    }
  }

  void doXYAnd(String xya, String caxy, String cout) {
    int i = xyand[xya]!;
    couts[cout] = i;
    cOuts[i].alias = cout;
    caxys[i].alias = caxy;
    if (i < zeds.length - 1) {
      cins[i + 1].alias = cout;
    }
  }

  for (var v in orGates) {
    List<String> l = v.$2;
    if (!ne(l[4], 'z')) {
      // look for the xyand operator.
      if (xyand.containsKey(l[0])) {
        doXYAnd(l[0], caxy, cout)
      } else if (xyand.containsKey(l[2])) {
        // int i = xyand[l[2]]!;
        // couts[l[4]] = i;
        // if (cells[i].cinandxyAlias != null) {
        //   print("collision! ${l[2]} vs ${cells[i].cinandxyAlias}");
        // }
        // cells[i].cinandxyAlias = l[2];
        // if (cells[i].coutAlias != null) {
        //   print("collision! ${l[4]} vs ${cells[i].coutAlias}");
        // }
        // cells[i].coutAlias = l[4];
        // if (i < cells.length) {
        //   if (cells[i + 1].cinAlias != null && cells[i + 1].cinAlias != l[4]) {
        //     print("collision! ${l[4]} vs ${cells[i + 1].cinAlias}");
        //   }
        //   cells[i + 1].cinAlias = l[4];
        // }
      } else {
        print("invalid or gate ${l.join(' ')}");
      }
    }
    // } else if (ip(l[4]) != cells.length - 1) {
    //   print("possible malformed cout at ${l.join(' ')}");
    //   foundErrors.add(l[4]);
    // }
  }
  for (var i in sums) {
    List<String> l = i.$2;
    String cin;
    if (xyxor.containsKey(l[0])) {
      // l[2] is a Cin
      cin = l[2];
      if (!couts.containsKey(l[2])) {
        print("possible missing cin: ${l[2]}: ${l.join(' ')}");
        continue;
      }
    } else if (xyxor.containsKey(l[2])) {
      cin = l[0];
      if (!couts.containsKey(l[0])) {
        print("possible missing cin: ${l[0]}: ${l.join(' ')}");
        continue;
      }
    } else {
      print("possible malformed sum at ${l.join(' ')}");
      continue;
    }

    int id = couts[cin]!;
    id++;
    // if (cells[id].cinAlias != null && cells[id].cinAlias != cin) {
    //   print("cin collision: $cin, ${gates[i.$1]}");
    // }
  }

  for (List<String> l in gates) {
    if (l[1] != 'XOR' && ne(l[4], 'z')) {
      int i = ip(l[4]);
      // if (i < cells.length - 1 && i > 0) {
      //   foundErrors.add(l[4]);
      //   print("possible error at ${l.join(' ')}");
      // }
    }
  }

  // for (int i = 1; i < cells.length; i++) {
  //   if (cells[i].xyandAlias == null) {
  //     print("cell $i missing x AND y");
  //   }
  //   if (cells[i].xyxorAlias == null) {
  //     print("cell $i missing x OR y");
  //   }
  //   if (cells[i].cinAlias == null) {
  //     print("cell $i missing cin");
  //   }
  //   if (cells[i].cinandxyAlias == null) {
  //     print("cell $i missing cin and x XOR y");
  //   }
  //   if (cells[i].coutAlias == null) {
  //     print("cell $i missing cout");
  //   }
  //   if (cells[i - 1].coutAlias != cells[i].cinAlias) {
  //     print("mismatch: ${cells[i - 1].coutAlias} != ${cells[i].cinAlias}");
  //   }
  // }
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
