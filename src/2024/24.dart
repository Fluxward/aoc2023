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

  CinAndXY? outCAXY;
  Sum? outSum;

  @override
  bool operator==(o) => gateEquals<XyXor>(o);
  @override
  int get hashCode => Object.hashAll([alias, 'XyXor']);
}

class XyAnd extends Gate {
  Cout? out;
  @override
  bool operator==(o) => gateEquals<XyAnd>(o);
  @override
  int get hashCode => Object.hashAll([alias, 'XyAnd']);
}

class CinAndXY extends Gate {

  Cout? out;

  XyXor? inXyX;
  Cin? inCin;
  @override
  bool operator==(o) => gateEquals<CinAndXY>(o);
  @override
  int get hashCode => Object.hashAll([alias, 'CAXY']);
}

class Cout extends Gate {
  Cin? out;

  XyAnd? inXY;
  CinAndXY? inCAXY;

  @override
  bool operator==(o) => gateEquals<Cout>(o);
  @override
  int get hashCode => Object.hashAll([alias, 'Cout']);
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
  Map<String, (bool xor, bool and, bool)> xorOpTest = {};
  Map<String, int> caxyMap = {};
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

  Set<String> setXYXors = xyxorGates.map((i) => i.$2[4]).toSet(); 
  Set<String> setXYAnds = xyandGates.map((i) => i.$2[4]).toSet(); 

  List<(int, List<String>)> caxyGates = andGates.whereNot((i) => setXYAnds.contains(i.$2[4])).toList();

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

  print("possible errors so far:");
  print(xyxorOut.difference(sumIns));
  print(xyxorOut.difference(caxyIns));
  print(caxyOut.difference(coutIns));
  print(xyandOut.difference(coutIns));
  print(coutOuts.difference(sumIns));
  print(coutOuts.difference(caxyIns));
  print('end of early search');


  Set<String> cinIn = {}; // gate names that are labelled as inputs and are cin/cout results
  Set<String> caxyIn = {}; // gate names that are labelled as inputs and are caxy results
  Set<String> xyandIn = {}; // gate names that are labelled as inputs and are xyand results.
  Set<String> xyxorIn = {}; // gate names that are labelled as inputs and are xyxor results.

  for (var v in xyandGates) {
    List<String> l = v.$2;
    int i = ip(l[0]);
    if (!ne(l[4], 'z')) {
      xyandOut.add(l[4]);
      xyands[i].alias = l[4];
      xyand[l[4]] = i;
      allGates[l[4]] = xyands[i];
    } else {
      print("incorrect Z at ${l.join(' ')}");
      foundErrors.add(l[4]);
    }
  }

  // Step 2. find caxy and xy xor elements as outputs

  for (var v in xyxorGates) {
    List<String> l = v.$2;
    int i = ip(l[0]);
    if (!ne(l[4], 'z')) {
      xyxors[i].alias = l[4];
      xyxor[l[4]] = i;

      Gate g = allGates.putIfAbsent(l[4], () => xyxors[i]);
      if (g is! XyXor) {
        print("mislabelled XyXor found! ${g.alias}");
        foundErrors.add(g.alias!);
      }
    } else if (i != 0) {
      print("incorrect Z at ${l.join(' ')}");
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

    Gate g = allGates.putIfAbsent(cout, () => cOuts[i]);
    if (g is! Cout) {
      print("mislabelled cout! $xya AND $caxy -> $cout vs ${g.alias}");
      foundErrors.add(g.alias!);
    }
  }

  for (var v in orGates) {
    List<String> l = v.$2;
    if (!ne(l[4], 'z')) {
      // look for the xyand operator.
      if (xyand.containsKey(l[0])) {
        doXYAnd(l[0], l[2], l[4]);
      } else if (xyand.containsKey(l[2])) {
        doXYAnd(l[2], l[0], l[4]);
      } else {
        print("invalid or gate ${l.join(' ')}");
      }
    } else if (ip(l[4]) != zeds.length - 1) {
      print("possible malformed cout at ${l.join(' ')}");
      foundErrors.add(l[4]);
    }
  }

  void doSum(String xyxor, String cin) {}
  for (var i in sums) {
    List<String> l = i.$2;
    if (xyxor.containsKey(l[0])) {

    }
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
