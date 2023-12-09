import 'common.dart';

d9(bool s) {
  (List<List<int>> hist) {
    print(hist.fold<int>(
        0,
        (p, e) =>
            p +
            diffs(e).reversed.fold(0, (p, e) => s ? e.first - p : p + e.last)));
  }(getLines().map((e) => stois(e)).toList());
}

List<List<int>> diffs(List<int> hist) {
  List<List<int>> ret = [];

  do {
    ret.add(hist);
    hist = List.generate(hist.length - 1, (i) => hist[i + 1] - hist[i]);
  } while (!hist.every((element) => element == 0));

  return ret;
}
