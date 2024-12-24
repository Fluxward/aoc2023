import 'dart:collection';

import 'package:aoc/common.dart';

void d22(bool sub) {
  Iterable<int> a = getLines().map(int.parse).map(succ);
  if (!sub) {
    print(a.reduce((u, v) => u + v));
  } else {
    a.toList();
    print(best);
  }
}

Map<(int, int, int, int), int> freq = HashMap(hashCode: (k) => Object.hashAll([k.$1, k.$2, k.$3, k.$4]), equals: (a, b) => a.$1 == b.$1 && a.$2 == b.$2 && a.$3 == b.$3 && a.$4 == b.$4,);
int best = 0;

int succ(int i) {
  int r = i;
  List<int> seq = List.filled(2001, 0);
  List<int> db = List.filled(2000, 0);
  Set<(int, int, int, int)> seen = {};
  seq[0] = r;
  //int total = r;
  for (int j = 0; j < 2000; j++) {
    seq[j + 1] = (r = suc(r)) % 10;
    db[j] = seq[j + 1] - seq[j];
    if (j >= 3) {
      var k = (db[j], db[j - 1], db[j - 2], db[j - 3]);
      if (!seen.add(k)) continue;

      int ret = (freq[k] = freq.putIfAbsent(k, () => 0) + seq[j + 1]);
      if (ret > best) best = ret;
    }
  }

  return r;
}

int suc(int i) {
  int sec = i;

  void mix(int j) {
    sec ^= j;
  }

  void prune() {
    sec %= 16777216;
  }

  void a() {
    mix(sec * 64);
    prune();
  }

  void b() {
    mix(sec ~/ 32);
    prune();
  }

  void c() {
    mix(sec * 2048);
    prune();
  }

  a();
  b();
  c();

  return sec;
}
