import 'common.dart';

d19(bool s) {
  List<String> ls = getLines();

  int i = 0;

  Map<String, List<Rule>> wfs =
      Map.fromEntries([for (; ls[i].isNotEmpty; i++) parseWorkflow(ls[i])]);

  List<Part> ps = [];
  for (i = i + 1; i < ls.length; i++) {
    List<int> d = ls[i]
        .substring(1, ls[i].length - 1)
        .split(',')
        .map((e) => int.parse(e.split('=')[1]))
        .toList();
    ps.add(Part(d));
  }

  print(ps
      .where((p) => accepted(p, "in", wfs))
      .fold<int>(0, (p, e) => p + e.sum));

  List<Range> rs = rangeTester(
      Range([(1, 4001), (1, 4001), (1, 4001), (1, 4001)]), "in", wfs);
  print(rs.fold<int>(0, (p, e) => p + e.mult()));
}

bool accepted(Part p, String cwf, Map<String, List<Rule>> wfs) {
  List<Rule> ts = wfs[cwf]!;

  for (int i = 0; i < ts.length; i++) {
    Jump r = ts[i].test(p);
    if (!r.hasResult) {
      continue;
    }

    if (r.des != null) {
      return accepted(p, r.des!, wfs);
    } else {
      return r.aed == true;
    }
  }

  return false;
}

List<Range> rangeTester(Range p, String cwf, Map<String, List<Rule>> wfs) {
  List<Range> accepted = [];

  Range cur = p;
  List<Range> open = [cur];

  for (Rule r in wfs[cwf]!) {
    List<tr> trs = open.expand((e) => r.rtest(e)).toList();
    open.clear();

    for (int i = 0; i < trs.length; i++) {
      tr r = trs[i];
      if (!r.jump.hasResult) {
        open.add(r.rp);
      } else if (r.jump.aed == true) {
        accepted.add(r.rp);
      } else if (r.jump.des != null) {
        accepted.addAll(rangeTester(r.rp, r.jump.des!, wfs));
      }
    }
  }

  return accepted;
}

MapEntry<String, List<Rule>> parseWorkflow(String s) {
  List<String> d = s.substring(0, s.length - 1).split('{');

  return MapEntry(
      d[0], d[1].split(',').map((e) => parseRule(e)).toList(growable: false));
}

Rule parseRule(String s) {
  if (!s.contains(":")) return Jump.parse(s);

  List<String> d = s.split(':');
  Jump res = Jump.parse(d[1]);

  if (d[0].contains('<')) {
    List<String> d2 = d[0].split('<');
    return CompRule(true, 'xmas'.firstWhere((p) => d2[0] == 'xmas'[p]),
        int.parse(d2[1]), res);
  }

  List<String> d2 = d[0].split('>');
  return CompRule(false, 'xmas'.firstWhere((p) => d2[0] == 'xmas'[p]),
      int.parse(d2[1]), res);
}

class Part {
  final List<int> ps;

  Part(this.ps);

  int get sum => ps.fold(0, (p, e) => p + e);
}

class Range {
  final List<(int, int)> rs;

  Range(this.rs);

  List<Range> split(int m, int split) {
    (int, int) range = rs[m];

    if (split < range.$1 || split >= range.$2) {
      return [];
    }

    List<(int, int)> l1 = List.of(rs);
    List<(int, int)> l2 = List.of(rs);

    l1[m] = (range.$1, split);
    l2[m] = (split, range.$2);

    return [Range(l1), Range(l2)];
  }

  int mult() {
    return List.generate(4, (i) => i)
        .fold<int>(1, (p, e) => p * (rs[e].$2 - rs[e].$1));
  }
}

class tr {
  Jump jump;
  final Range rp;

  tr({required this.jump, required this.rp});
}

abstract class Rule {
  Jump test(Part p);

  List<tr> rtest(Range rp);
}

class Jump implements Rule {
  bool hasResult;
  bool? aed;
  String? des;

  Jump({this.hasResult = false, this.aed, this.des});

  static Jump parse(String s) {
    switch (s) {
      case 'A':
        return Jump(hasResult: true, aed: true);
      case 'R':
        return Jump(hasResult: true, aed: false);
      default:
        return Jump(hasResult: true, des: s);
    }
  }

  Jump test(Part p) {
    return this;
  }

  List<tr> rtest(Range p) {
    return [tr(rp: p, jump: this)];
  }
}

class CompRule implements Rule {
  final bool lt;
  final int m;
  final int v;
  final Jump res;
  CompRule(this.lt, this.m, this.v, this.res);

  Jump test(Part p) {
    return (lt ? p.ps[m] < v : p.ps[m] > v) ? res : Jump();
  }

  List<tr> rtest(Range p) {
    int split = v + (lt ? 0 : 1);

    List<Range> lr = p.split(m, split);
    if (lr.isEmpty) {
      return (lt ? p.rs[m].$2 < v : p.rs[m].$2 > v)
          ? [tr(rp: p, jump: res)]
          : [tr(rp: p, jump: Jump())];
    }

    return lt
        ? [tr(rp: lr[0], jump: res), tr(rp: lr[1], jump: Jump())]
        : [tr(rp: lr[0], jump: Jump()), tr(rp: lr[1], jump: res)];
  }
}
