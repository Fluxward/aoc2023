class M<T> {
  List<List<T>> data = [];

  M(List<List<T>> d) {
    assert(d.length > 0);
    int l = d[0].length;
    assert(d.every((element) => element.length == l));
    data = List.generate(d.length, (i) => List.generate(l, (j) => d[i][j]));
  }
}
