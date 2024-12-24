import 'dart:collection';

import 'package:aoc/common.dart';
import 'package:collection/collection.dart';

List<List<String>> inp = getLines().map((l) => l.split("-")).toList();

int npc = 0;
Map<String, int> m = {};
List<String> nodes = [];
Map<int, Set<int>> adj = {};
//List<(int, int)> links = [];

int memoCount = 0;
int itC = 0;
Map<Set<int>, Set<int>> memo = HashMap(
    hashCode: SetEquality<int>().hash,
    equals: SetEquality<int>().equals);
Set<int> bestDp(Set<int> cont) {
  itC++;
  if (memo.containsKey(cont)) {
    memoCount++;
  }
  return memo.putIfAbsent(cont, () => _bestDp(cont));
}

Set<int> _bestDp(Set<int> cont) {
  Set<int> best = {...cont};
  Set<int> cand = Set.from(cont.map((s) => adj[s]!).flattened)..removeAll(cont);

  for (int i in cand) {
    Set<int> a = adj[i]!;
    if (cont.intersection(a).length != cont.length) continue;

    Set<int> c = bestDp({...cont, i});
    if (c.length > best.length) best = c;
  }

  return best;
}

void d23(bool sub) {
  for (var l in inp) {
    List<int> k = [];
    for (var pc in l) {
      if (!m.containsKey(pc)) {
        nodes.add(pc);
        m[pc] = npc++;
      }
      k.add(m[pc]!); 
    }

    adj.putIfAbsent(k.first, () => {}).add(k.last);
    adj.putIfAbsent(k.last, () => {}).add(k.first);
    //links.add((m[l.first]!, m[l.last]!));
  }

  Set<Set<int>> triples = HashSet(
      equals: SetEquality<int>().equals, hashCode: SetEquality<int>().hash);

  for (int i in m.keys.where((s) => s[0] == 't').map((k) => m[k]!)) {
    //Set<int> seen = {};
    Queue<List<int>> q = Queue()..add([i]);

    while (q.isNotEmpty) {
      List<int> c = q.removeFirst();

      if (c.length == 4) {
        if (c.last == i) triples.add(Set.from(c));
        continue;
      }

      if (c.length == 3 && c.last == i) continue;

      for (int n in adj.putIfAbsent(c.last, () => {})) {
        q.add([...c, n]);
      }
    }
  }

  print(triples.length);

  Set<int> best = {};

  for (int i = 0; i < npc; i++) {
    Set<int> c = bestDp({i});
    print({c.map((i)=>nodes[i])});
    if (c.length > best.length) best = c;
  }

  print(best.toList().map((i) => nodes[i]).sorted().join(","));
  print(memoCount);
  print(itC);
}
