import 'common.dart';
import 'geom.dart';

d18(bool s) {
  Stopwatch stopwatch = Stopwatch()..start();
  Ps perim = [];

  List<String> lines = getLines();
  getPerim(perim, lines, s);
  print("perimeter: ${stopwatch.elapsed}");
  print(iarea(perim).abs() + perimPad(perim));
  print("are: ${stopwatch.elapsed}");
}

(dir, int) parse(String l, bool s) {
  List<String> d = l.split(' ');
  if (s) {
    String hex = d[2].substring(2, d[2].length - 1);

    dir di;
    switch (hex[hex.length - 1]) {
      case '0':
        di = dir.r;
      case '1':
        di = dir.d;
      case '2':
        di = dir.l;
      default: // this will never happen, probably
        di = dir.u;
    }

    return (di, (int.parse(hex.substring(0, hex.length - 1), radix: 16)));
  }
  dir di;

  switch (d[0]) {
    case 'R':
      di = dir.r;
    case 'L':
      di = dir.l;
    case 'D':
      di = dir.d;
    case 'U':
    default: // this will never happen, probably
      di = dir.u;
  }

  return (di, (int.parse(d[1])));
}

void getPerim(Ps perim, List<String> lines, bool subset) {
  P cur = P(1, 1);
  for (String l in lines) {
    (dir, int) d = parse(l, subset);

    cur += (d.$1.p) * d.$2;
    perim.add(cur);
  }
}

int perimPad(Ps perim) {
  int quarters = 0;
  int n = perim.length;
  for (int i = 0; i < n; i++) {
    P a = perim[(n + i - 1) % n];
    P b = perim[i];

    int cur = ccw(a, b, perim[(i + 1) % n]);

    P d = b - a;
    quarters += d.x == 0 ? 2 * (d.y.abs() - 1) : 2 * (d.x.abs() - 1);
    quarters += cur < 0 ? 3 : 1;
  }

  return quarters ~/ 4;
}
