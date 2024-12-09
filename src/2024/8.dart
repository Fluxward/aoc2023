import 'package:collection/collection.dart';

import '../common.dart';

void d8(bool sub) {
  Map<String, List<P>> a = {};
  var input = getLines();
  input.forEachIndexed((r, line) => line
      .split("")
      .mapIndexed((c, e) => (e != '.') ? (e, P(r, c)) : null)
      .nonNulls
      .forEach((e) => a.putIfAbsent(e.$1, () => []).add(e.$2)));

  Set<P> ps = {};
  for (List<P> l in a.values) {
    for (int i = 0; i < l.length; i++) {
      for (int j = i + 1; j < l.length; j++) {
        sub ? d8b(l, i, j, ps, input) : d8a(l, i, j, ps, input);
      }
    }
  }

  print(ps.length);
}

void d8a(List<P> l, int i, int j, Set<P> ps, List<String> input) {
  void dap(P p) => inBoundsString(p.r, p.c, input) ? ps.add(p) : ();
  dap((l[j] * 2) - l[i]);
  dap((l[i] * 2) - l[j]);
}

void d8b(List<P> l, int i, int j, Set<P> ps, List<String> input) {
  db(l, j, i, ps, input);
  db(l, i, j, ps, input);
}

void db(List<P> l, int i, int j, Set<P> ps, List<String> input) {
  P c = l[i];
  while (inBoundsString(c.r, c.c, input)) {
    ps.add(c);
    c += (l[i] - l[j]);
  }
}
