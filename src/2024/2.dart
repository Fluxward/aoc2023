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
            .sublist(1)
            .mapIndexed((i, e) => (l[i] - e).abs())
            .every((d) => d > 0 && d < 4));

bool isSafeWithSkip(List<int> l) =>
    isSafe(l) ||
    l.foldIndexed<bool>(false,
        (i, p, e) => p || isSafe([...l.whereNotIndexed((i0, e0) => i0 == i)]));
