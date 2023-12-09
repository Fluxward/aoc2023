import 'common.dart';

d9(bool s) {
  List<String> lines = getLines();
  List<List<int>> hist = lines.map((e) => stois(e)).toList();

  s ? b9(hist) : a9(hist);
}

a9(List<List<int>> hist) {
  print(hist.fold<int>(
      0, (previousValue, element) => previousValue + predict(diffs(element))));
}

b9(List<List<int>> hist) {
  print(hist.fold<int>(0,
      (previousValue, element) => previousValue + backPredict(diffs(element))));
}

int predict(List<List<int>> diffs) {
  return diffs.reversed.fold(0, (p, e) => p + e.last);
}

int backPredict(List<List<int>> diffs) {
  return diffs.reversed.fold(0, (p, e) => e.first - p);
}

List<List<int>> diffs(List<int> hist) {
  List<List<int>> ret = [];
  ret.add(hist);
  bool done = false;

  List<int> cur = hist;
  while (!done) {
    cur = getDiffs(cur);
    ret.add(cur);
    if (cur.every((element) => element == 0)) {
      done = true;
    }
  }

  return ret;
}

List<int> getDiffs(List<int> hist) {
  return List.generate(hist.length - 1, (i) => hist[i + 1] - hist[i]);
}
