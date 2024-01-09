import 'dart:collection';

import 'package:collection/collection.dart';

class Network {
  final int source;
  final int sink;
  final List<List<(int, int)>> e = [[], []];
  late final List<int> caps;

  final Map<int, Set<({int n, int e, int r})>> adj = {};

  int get s => source;
  int get t => sink;

  Network(this.source, this.sink, List<(int, int)> edges)
      : caps = List.unmodifiable(List.filled(edges.length, 1)) {
    e[0].addAll(edges);
    e[1].addAll(edges.map((e) => (e.$2, e.$1)));
    //forward edges
    e[0].forEachIndexed((i, el) =>
        adj.putIfAbsent(el.$1, () => {}).add((n: el.$2, e: i, r: 0)));

    //reverse edges
    e[1].forEachIndexed((i, el) =>
        adj.putIfAbsent(el.$1, () => {}).add((n: el.$2, e: i, r: 1)));
  }

  ({Set<int> s, Set<int> t}) minCut() {
    // set up forward and reverse flow
    List<List<int>> flow =
        List.generate(2, (index) => List.filled(caps.length, 0));

    List<({int r, int i})>? cp = st(flow);
    while (cp != null) {
      for (var p in cp) {
        flow[p.r][p.i] += 1;
        flow[1 - p.r][p.i] -= 1;
      }

      cp = st(flow);
    }

    Set<int> retS = reachable(s, flow, {});
    Set<int> all = Set.from(List.generate(adj.length, (i) => i));

    return (s: retS, t: all.difference(retS));
  }

  List<({int r, int i})>? st(List<List<int>> flow) {
    Queue<({int e, int n, int r, int p})> q = Queue();

    List<({int e, int n, int r, int p})?> visited =
        List.filled(adj.keys.length, null);

    q.add((n: source, e: -1, r: -1, p: -1));
    while (q.isNotEmpty) {
      var n = q.removeFirst();
      visited[n.n] = n;
      if (n.n == sink) break;

      var ne = adj[n.n]!;

      for (var nex in ne) {
        if (visited[nex.n] != null) continue;
        if (flow[nex.r][nex.e] == 1) continue;
        q.add((e: nex.e, n: nex.n, r: nex.r, p: n.n));
      }
    }

    if (visited[sink] != null) {
      int c = sink;
      List<({int r, int i})> path = [];
      while (c != source) {
        var ed = visited[c];
        if (ed!.e >= 0) {
          path.add((r: ed.r, i: ed.e));
        }
        c = ed.p;
      }
      return path;
    }

    return null;
  }

  Set<int> reachable(int n, List<List<int>> flow, Set<int> visited) {
    var next = adj[n]!;
    visited.add(n);

    for (var e in next) {
      if (caps[e.e] == flow[e.r][e.e] || visited.contains(e.n)) continue;
      visited.addAll(reachable(e.n, flow, visited));
    }

    return visited;
  }
}
