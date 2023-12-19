import 'common.dart';

d19(bool s) {
  List<String> ls = getLines();

  int i = 0;

  Map<String, List<Rule>> wfs =
      Map.fromEntries([for (; ls[i].isNotEmpty; i++) parseWorkflow(ls[i])]);

  if (!s) {
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
    return;
  }
  List<Range> rs = rangeTester(
      Range([(1, 4001), (1, 4001), (1, 4001), (1, 4001)]), "in", wfs);
  print(rs.fold<int>(0, (p, e) => p + e.mult()));
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

bool accepted(Part p, String cwf, Map<String, List<Rule>> wfs) {
  List<Rule> ts = wfs[cwf]!;

  for (int i = 0; i < ts.length; i++) {
    Jump r = ts[i].test(p);
    if (!r.hasResult) {
      continue;
    }
    return r.des != null ? accepted(p, r.des!, wfs) : r.aed == true;
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

    for (tr r in trs) {
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

class Part {
  final List<int> ps;

  Part(this.ps);

  int get sum => ps.fold(0, (p, e) => p + e);
}

class Range {
  final List<(int, int)> rs;

  Range(this.rs);

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

    if (p.rs[m].$1 > split || p.rs[m].$2 <= split) {
      return (lt ? p.rs[m].$2 < v : p.rs[m].$2 > v)
          ? [tr(rp: p, jump: res)]
          : [tr(rp: p, jump: Jump())];
    }

    List<(int, int)> l1 = List.of(p.rs);
    List<(int, int)> l2 = List.of(p.rs);

    l1[m] = (p.rs[m].$1, split);
    l2[m] = (split, p.rs[m].$2);

    return lt
        ? [tr(rp: Range(l1), jump: res), tr(rp: Range(l2), jump: Jump())]
        : [tr(rp: Range(l1), jump: Jump()), tr(rp: Range(l2), jump: res)];
  }
}
