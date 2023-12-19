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

  Map<mem, (int, int)> map = {
    mem.x: (1, 4001),
    mem.m: (1, 4001),
    mem.a: (1, 4001),
    mem.s: (1, 4001)
  };

  List<RangePart> rs = rangeTester(RangePart(map), "in", wfs);

  print("accepted ranges:");
  rs.forEach((element) => print(element.rs));

  print(rs.fold<int>(0, (p, e) => p + e.mult()));
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

List<RangePart> rangeTester(
    RangePart p, String cwf, Map<String, List<Rule>> wfs) {
  print("testing $cwf");
  List<RangePart> accepted = [];

  RangePart cur = p;
  List<RangePart> open = [cur];

  for (Rule r in wfs[cwf]!) {
    List<tr> trs = open.expand((e) => r.rangeTest(e)).toList();
    open.clear();

    //r.rangeTest(cur);

    for (int i = 0; i < trs.length; i++) {
      tr r = trs[i];
      if (r.aed == true) {
        accepted.add(r.rp);
      } else if (r.dest != null) {
        accepted.addAll(rangeTester(r.rp, r.dest!, wfs));
      } else if (r.aed != false) {
        open.add(r.rp);
      }
    }
  }

  return accepted;
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

    Map<mem, (int, int)> map1 = Map.of(rs);
    Map<mem, (int, int)> map2 = Map.of(rs);

    map1[m] = (range.$1, split);
    map2[m] = (split, range.$2);

    return [RangePart(map1), RangePart(map2)];
  }

  int mult() {
    return mem.values.fold<int>(1, (p, e) => p * (rs[e]!.$2 - rs[e]!.$1));
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
    print("testing $this on:");
    print(p.rs);
    if (compLt == null) {
      return [tr(aed: accepted, dest: dest, rp: p)];
    }

    int split = v!;

    if (!compLt!) {
      split++;
    }

    List<RangePart> lr = p.split(m!, split);
    if (lr.isEmpty) {
      if ((compLt == true && p.rs[m!]!.$2 < v!) ||
          (compLt == false && p.rs[m!]!.$2 > v!)) {
        return [tr(rp: p, aed: accepted, dest: dest)];
      }
      return [tr(rp: p)];
    }

    if (compLt == true) {
      return [tr(rp: lr[0], aed: accepted, dest: dest), tr(rp: lr[1])];
    }
    return [tr(rp: lr[0]), tr(rp: lr[1], aed: accepted, dest: dest)];
  }
}
