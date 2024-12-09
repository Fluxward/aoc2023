import 'package:collection/collection.dart';

import '../common.dart';

Map<int, int> freq = {};
void d1(bool s) {
  var input = IterableZip(getLines().map((l) => l.split('   ').map(int.parse)));
  if (s)
    print(input.first
        .map((e) => freq.putIfAbsent(
            e, () => e * input.last.where((e2) => e2 == e).length))
        .reduce((v, e) => v + e));
  else
    print(IterableZip(input.map((l) => l.sorted((a, b) => a - b)))
        .map((e) => (e.first - e.last).abs())
        .reduce((v, e) => v + e));
}
