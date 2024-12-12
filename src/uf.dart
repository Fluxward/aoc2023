class UnionFind {
  final int size;
  final List<int> p;
  final List<int> c;

  UnionFind(this.size)
      : p = List.generate(size, (i) => i),
        c = List.filled(size, 1);

  void union(int a, int b) {
    int pa = find(a);
    int pb = find(b);

    if (pa == pb) return;

    if (c[pa] < c[pb]) {
      p[pa] = pb;
      c[pb] += c[pa];
    } else {
      p[pb] = pa;
      c[pa] += c[pb];
    }
  }

  int find(int x) {
    if (p[x] == x) return x;

    p[x] = find(p[x]);
    return p[x];
  }
}