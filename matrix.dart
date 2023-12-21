import 'common.dart';

class M<T> {
  List<List<T>> data = [];

  int get nr => data.length;
  int get nc => data.firstOrNull?.length ?? 0;

  M(List<List<T>> d) {
    assert(d.length > 0);
    int l = d[0].length;
    assert(d.every((element) => element.length == l));
    data = List.generate(d.length, (i) => List.generate(l, (j) => d[i][j]));
  }

  T at(P p) => data[p.r][p.c];

  List<T> operator [](int i) {
    return data[i];
  }

  bool inBounds(P p) =>
      p.r >= 0 && p.c >= 0 && p.r < data.length && p.c < data[0].length;
}
