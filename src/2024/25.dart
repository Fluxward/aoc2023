import 'package:aoc/common.dart';
import 'package:collection/collection.dart';

class ElTree {
  final Map<int, ElTree> next = {};
  ElTree();
  void insert(List<int> el, int d) => d < el.length
      ? next.putIfAbsent(el[d], () => ElTree()).insert(el, d + 1)
      : ();
  int search(List<int> el, int d) => d < el.length
      ? next.entries
          .where((me) => me.key <= 7 - el[d])
          .map((me) => me.value.search(el, d + 1))
          .fold(0, (a, b) => a + b)
      : 1;
}

void d25(bool sub) {
  ElTree elt = ElTree();
  List<List<int>> keys = [];
  List<String> input = getLines();
  for (int i = 0; i < input.length; i++) {
    bool lock = input[i] == "#####";
    List<int> c = [0, 0, 0, 0, 0];
    while (i < input.length && input[i].isNotEmpty) {
      input[i++]
          .split("")
          .forEachIndexed((ind, e) => c[ind] += e == '#' ? 1 : 0);
    }
    if (lock) {
      elt.insert(c, 0);
    } else {
      keys.add(c);
    }
  }
  print(keys.map((k) => elt.search(k, 0)).reduce((a, b) => a + b));
}
