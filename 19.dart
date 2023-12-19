import 'dart:html';

import 'bitset.dart';
import 'common.dart';

RegExp re = RegExp(r'([^{}]+)');
d19(bool s) {
  List<String> ls = getLines();

  int i = 0;

  Map<String, List<Rule>> wfs = {};
  while (ls[i].isNotEmpty) {
    var d = parseWorkflow(ls[i]);
    wfs[d.$1] = d.$2;
    i++;
  }
  if (!s) {
    i++;

    List<Part> ps = [];
    while (i < ls.length) {
      List<int> d = ls[i]
          .substring(1, ls[i].length - 1)
          .split(',')
          .map((e) => int.parse(e.split('=')[1]))
          .toList();
      ps.add(Part(d[0], d[1], d[2], d[3]));
      i++;
    }

    print(ps.fold<int>(0, (p, e) => p + (accepted(e, 'in', wfs) ? e.sum : 0)));
  }
}

bool accepted(Part p, String cwf, Map<String, List<Rule>> wfs) {
  List<Rule> ts = wfs[cwf]!;

  for (int i = 0; i < ts.length; i++) {
    var r = ts[i].test(p);
    if (r == null) {
      continue;
    }

    if (r.$1 == null) {
      return accepted(p, r.$2!, wfs);
    } else {
      return r.$1!;
    }
  }

  assert(false);
  return false;
}

(String, List<Rule>) parseWorkflow(String s) {
  var d = re.allMatches(s);
  return (
    d.first.group(0)!,
    d.last.group(0)!.split(',').map((e) => parseRule(e)).toList(growable: false)
  );
}

Rule parseRule(String s) {
  if (!s.contains(":")) {
    switch (s) {
      case 'A':
        return Rule(accepted: true);
      case 'R':
        return Rule(accepted: false);
      default:
        return Rule(dest: s);
    }
  }

  bool? accepted;
  String? dest;

  List<String> d = s.split(':');
  switch (d[1]) {
    case 'A':
      accepted = true;
    case 'R':
      accepted = false;
    default:
      dest = d[1];
  }
  if (d[0].contains('<')) {
    List<String> d2 = d[0].split('<');
    return Rule(
        compLt: true,
        m: mem.stop(d2[0]),
        v: int.parse(d2[1]),
        accepted: accepted,
        dest: dest);
  }

  List<String> d2 = d[0].split('>');
  return Rule(
      compLt: false,
      m: mem.stop(d2[0]),
      v: int.parse(d2[1]),
      accepted: accepted,
      dest: dest);
}

class Part {
  final int x;
  final int m;
  final int a;
  final int s;

  Part(this.x, this.m, this.a, this.s);

  int get sum => x + m + a + s;
}

class RangePart {
  final Map<mem, (int, int)> rs;

  RangePart(this.rs);

  // range 1 ends at split, exclusive
  List<RangePart> split(mem m, int split) {
    (int, int) range = rs[m]!;

    if (split < range.$1 || split >= range.$2) {
      return [];
    }

    (int, int) range1 = (range.$1, split);
    (int, int) range2 = (range.$2, split);
    Map<mem, (int, int)> map1 = Map.of(rs);
    Map<mem, (int, int)> map2 = Map.of(rs);

    map1[m] = range1;
    map2[m] = range2;

    return [RangePart(map1), RangePart(map2)];
  }
}

enum mem {
  x(),
  m(),
  a(),
  s();

  static mem stop(String st) {
    switch (st) {
      case 'x':
        return x;
      case 'm':
        return m;
      case 'a':
        return a;
      default:
        return s;
    }
  }

  int toInt() {
    switch (m) {
      case x:
        return 0;
      case m:
        return 1;
      case a:
        return 2;
      case s:
        return 3;
    }
  }
}

class tr {
  final bool? aed;
  final String? dest;
  final RangePart rp;

  tr({this.aed, this.dest, required this.rp});
}

class Rule {
  final bool? compLt;
  final mem? m;

  final int? v;
  final bool? accepted;
  final String? dest;

  Rule({this.compLt, this.m, this.v, this.accepted, this.dest});

  String toString() {
    if (compLt == null) {
      return accepted == null
          ? dest!
          : accepted!
              ? 'A'
              : 'R';
    }

    StringBuffer s = StringBuffer();

    switch (m!) {
      case mem.x:
        s.write('x');
      case mem.m:
        s.write('m');
      case mem.a:
        s.write('a');
      case mem.s:
        s.write('s');
    }

    s.write(compLt! ? '<' : '>');
    s.write(v);
    s.write(":");
    s.write(dest ?? (accepted! ? 'A' : 'R'));
    return s.toString();
  }

  (bool?, String?)? test(Part p) {
    if (compLt == null) {
      return (accepted, dest);
    }

    int comp;

    switch (m!) {
      case mem.x:
        comp = p.x;
      case mem.m:
        comp = p.m;
      case mem.a:
        comp = p.a;
      case mem.s:
        comp = p.s;
    }

    comp -= v!;

    bool sat = compLt! ? comp < 0 : comp > 0;

    return sat ? (accepted, dest) : null;
  }

  List<tr> rangeTest(RangePart p) {
    if (compLt == null) {
      return [tr(aed: accepted, dest: dest, rp: p)];
    }

    int split = v!;

    if (!compLt!) {
      split++;
    }

    List<RangePart> lr = p.split(m!, split);

    if (compLt == true) {
      return [tr(rp: lr[0], aed: accepted, dest: dest), tr(rp: lr[1])];
    }
    return [tr(rp: lr[0]), tr(rp: lr[1], aed: accepted, dest: dest)];
  }
}
