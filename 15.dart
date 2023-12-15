import 'dart:collection';
import 'dart:convert';

import 'common.dart';

d15(bool s) {
  List<String> input = getLines()[0].split(',');
  if (!s) {
    print(input.fold<int>(0, (p, e) => p + hash(e)));
    return;
  }

  List<LinkedHashMap<String, int>> bs =
      List.generate(256, (_) => LinkedHashMap());

  for (String s in input) {
    if (s[s.length - 1] == '-') {
      String ss = s.substring(0, s.length - 1);
      bs[hash(ss)].remove(ss);
    } else {
      String ss = s.substring(0, s.length - 2);
      bs[hash(ss)][ss] = int.parse(s[s.length - 1]);
    }
  }

  print(
      List.generate(256, (n) => bs[n].fl(n + 1)).fold<int>(0, (p, e) => p + e));
}

extension FL on LinkedHashMap<String, int> {
  int fl(int n) =>
      List.generate(length, (i) => (i + 1) * n * values.elementAt(i))
          .fold(0, (p, e) => p + e);
}

AsciiCodec codec = AsciiCodec();

int hash(String s) =>
    codec.encode(s).fold<int>(0, (p, e) => ((p + e) * 17) % 256);
