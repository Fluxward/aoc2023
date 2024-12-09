import 'package:collection/collection.dart';

import '../common.dart';

void d2(bool s) => print(getLines()
    .map((l) => [...l.split(" ").map(int.parse)])
    .where(s ? isSafeWithSkip : isSafe)
    .length);

int comp(int a, int b) => a - b;

bool isConsistent(List<int> l) => l.isSorted(comp) || l.reversed.isSorted(comp);

bool isSafe(List<int> l) =>
    isConsistent(l) &&
    (l.length < 2 ||
        l
            .skip(1)
            .mapIndexed((i, e) => (l[i] - e).abs())
            .every((d) => d > 0 && d < 4));

bool isSafeWithSkip(List<int> l) =>
    isSafe(l) ||
    l
        .mapIndexed((i, e) => isSafe([...l.whereIndexed((i0, e0) => i0 == i)]))
        .any((e) => e);
