import 'dart:collection';

import 'package:collection/collection.dart';

import '../common.dart';
import '../networkflow.dart';

d25(bool hardP) {
  hardP ? hard() : easy();
}

hard() {}

easy() async {
  // SendPort sp = await getTimerSendPort(Duration(seconds: 2));
  Map<String, Set<String>> adj =
      LinkedHashMap.fromEntries(getLines().map((e) => parse(e)));

/*
  // add both edge directions
  Map<String, Set<String>> toCopy = {};
  adj.forEach((k, v) {
    v.forEach((e) {
      toCopy.putIfAbsent(e, () => Set())..add(k);
    });
  });

  toCopy.forEach((k, v) => adj.putIfAbsent(k, () => Set()).addAll(v));
  */

  List<String> cs = List.of(Set.from(adj.keys)..addAll(adj.values.flattened));
  for (String s in cs) {
    adj.putIfAbsent(s, () => {});
  }

  Map<String, int> cis =
      Map.fromEntries(cs.mapIndexed((i, e) => MapEntry(e, i)));

/*
  for (var e in adj.entries) {
    for (var k in e.value) {
      adj[k]?.add(e.key);
    }
  }
  */

  List<(int, int)> edges = adj.entries
      .expand((e) => e.value.map((el) => (cis[e.key]!, cis[el]!)))
      .toList();
  //edges.forEach((e) => print(e));
  // edges.forEach((e) => print("${cs[e.$1]} <=> ${cs[e.$2]}"));

  print(cs.length);
  int s = 0;
  Set<int> res = {};
  for (int t = 1; t < cs.length; t++) {
    Network nw = Network(s, t, edges);
    var st = nw.minCut();

    int resu = (st.s.length) * (st.t.length);
    if (res.add(resu)) {
      print(resu);
    }
    if (res.length == 2) break;
  }
  //cleanup();
}

MapEntry<String, Set<String>> parse(String l) {
  List<String> cs = l.split(' ');
  return MapEntry(cs[0].replaceAll(':', ''), Set.from(cs.sublist(1)));
}

(int, int)? isBipartite(Map<int, Set<int>> a) {
  List<bool?> colour = List.filled(a.keys.length, null);
  Queue<({int i, bool pco})> q = Queue();
  q.add((i: 0, pco: true));

  while (q.isNotEmpty) {
    var s = q.removeFirst();

    bool cco = !s.pco;
    if (colour[s.i] != null) {
      if (colour[s.i] != cco) {
        print(s.i);
        return null;
      }
      continue;
    }

    colour[s.i] = cco;
    for (int n in a[s.i]!) {
      q.add((i: n, pco: cco));
    }
  }

  int nt = colour.fold<int>(0, (p, e) => p + (e == true ? 1 : 0));
  return (nt, colour.length - nt);
}
