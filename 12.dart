import 'dart:collection';
import 'common.dart';

d12(bool s) {
  setDebug(false);
  print(getLines().fold<int>(0, (p, e) {
    int c = processLine(e, s);
    dpr(c);
    return p + c;
  }));
}

int processLine(String line, bool s) {
  List<String> d = line.split(' ');

  Map<K, int> w = HashMap();
  List<int> rs = stois(d[1], sep: ',');
  String data = d[0];

  if (s) {
    rs = List.generate(rs.length * 5, (i) => rs[i % rs.length]);
    data = List.generate(5, (index) => data).join('?');
  }

  List<int> rSum = List<int>.generate(
      rs.length, (i) => rs.sublist(i).fold(rs.length - i - 1, (p, e) => p + e));
  return waysMem(w, data, rs, K(0, 0), rSum);
}

class K {
  final int si;
  final int sat;

  const K(this.si, this.sat);

  int get hashCode => Object.hashAll([si, sat]);

  bool operator ==(Object? other) =>
      other != null && other is K && other.si == si && other.sat == sat;
}

int waysMem(Map<K, int> w, String s, List<int> rs, K k, List<int> rSum) {
  int waysInternal(Map<K, int> w, String s, List<int> rs, K k, List<int> rSum) {
    int i = k.si;
    int sat = k.sat;
    int ways = 0;
    int j;
    if (i >= s.length) return sat == rs.length ? 1 : 0;
    if (rs.length == sat) return s.contains('#', i) ? 0 : 1;
    if (rSum[sat] > s.length - i) return 0;
    if (s[i] == '.') return waysMem(w, s, rs, K(i + 1, sat), rSum);
    if (s[i] == '?') ways = waysMem(w, s, rs, K(i + 1, sat), rSum);

    // try complete the string
    for (j = 0; (i + j) < s.length && s[i + j] != '.' && j < rs[sat]; j++);

    // not enough # and ?.
    if (j < rs[sat]) return ways;

    // check if we completed the last # string by the end of this string
    if (i + j == s.length)
      return (j == rs[sat] && (sat + 1 == rs.length) ? 1 : 0) + ways;

    switch (s[i + j]) {
      case '.': // # string complete
        return ways + waysMem(w, s, rs, K(i + j, sat + 1), rSum);
      case '?': // need to treat current ? as a .
        return ways + waysMem(w, s, rs, K(i + j + 1, sat + 1), rSum);
      // too long
      case '#':
      default:
    }
    return ways;
  }

  return w.putIfAbsent(k, () => waysInternal(w, s, rs, k, rSum));
}
