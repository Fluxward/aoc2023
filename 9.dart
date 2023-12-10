import 'common.dart';

d9(bool s) {
  print(getLines().fold<int>(0, (p, e) {
    int pre(List<int> h, bool s) {
      return h.every((e) => e == 0)
          ? 0
          : (pre(List.generate(h.length - 1, (i) => h[i + 1] - h[i]), s)) *
                  (s ? -1 : 1) +
              (s ? h.first : h.last);
    }

    return p + pre(stois(e), s);
  }));
}
