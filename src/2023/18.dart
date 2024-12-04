import '../common.dart';
import '../geom.dart';

d18(bool s) {
  Stopwatch stopwatch = Stopwatch()..start();
  Ps perim = [];

  List<String> lines = getLines();
  getPerim(perim, lines, s);
  print("perimeter: ${stopwatch.elapsed}");
  print(iarea(perim).abs() + perimPad(perim));
  print("area: ${stopwatch.elapsed}");
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
      default:
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
    default:
      di = dir.u;
  }

  return (di, (int.parse(d[1])));
}

void getPerim(Ps perim, List<String> lines, bool subset) {
  P cur = P(0, 0);
  for (String l in lines) {
    (dir, int) d = parse(l, subset);
    cur += (d.$1.p) * d.$2;
    perim.add(cur);
  }
}

int perimPad(Ps perim) {
  int extra = 0;
  int n = perim.length;
  for (int i = 0; i < n; i++) {
    P a = perim[(n + i - 1) % n];
    P b = perim[i];
    P c = b - a;
    extra += c.x == 0 ? 2 * (c.y.abs() - 1) : 2 * (c.x.abs() - 1);
  }
  return (extra + 12 + 2 * (perim.length - 4)) ~/ 4;
}
