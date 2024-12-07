import '../common.dart';

void d7(bool sub) => print(getLines()
    .map((l) => l.split(RegExp(r':? ')).map(int.parse).toList())
    .fold<int>(
        0, (p, ops) => test(ops, ops[0], ops[1], 2, sub) ? ops[0] + p : p));

bool test(List<int> l, int cal, int cur, int i, bool sub) =>
    cur == cal && i == l.length ||
    (i < l.length && cur <= cal) &&
        (test(l, cal, cur + l[i], i + 1, sub) ||
            test(l, cal, cur * l[i], i + 1, sub) ||
            (sub && test(l, cal, cur.concat(l[i]), i + 1, sub)));
