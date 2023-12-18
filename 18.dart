import 'common.dart';

d18(bool s) {
  Stopwatch stopwatch = Stopwatch()..start();
  P cur = P(0, 0);
  Ps perim = [cur];

  List<String> lines = getLines();
  if (s) {
    subPerim(perim, lines);
  } else {
    mainPerim(perim, lines);
  }

  perim.rcsort();
  // inc, exc
  Map<int, (Set<int>, int, int)> segs = {};

  print("perim: ${stopwatch.elapsed}");
  for (int i = 0; i < perim.length;) {
    int r = perim[i].r;
    int s = i;
    Set<int> se = {};
    while (i < perim.length && perim[i].r == r) {
      se.add(perim[i].c);
      i++;
    }
    segs[r] = (se, s, i);
  }
  print("sets: ${stopwatch.elapsed}");

  int count = 0;
  for (int i in segs.keys) {
    dpr("cur seg: $i, ${segs[i]!.$1}");
    bool inside = false;
    bool? edgeAbove;
    P? prev = null;
    Set<int>? above = segs[i - 1]?.$1;
    (Set<int>, int, int) d = segs[i]!;
    Set<int>? below = segs[i + 1]?.$1;
    for (int j = d.$2; j < d.$3 - 1; j++) {
      P cur = perim[j];
      P next = perim[j + 1];

      bool dugUp = above?.contains(cur.c) ?? false;
      bool dugDown = below?.contains(cur.c) ?? false;

      if (dugUp && dugDown) {
        dpr("hi1");
        inside = !inside; // line crossing
      } else if (prev == null || prev.c + 1 < cur.c) {
        // entering perimeter from corner
        dpr("hi2");
        edgeAbove = dugUp;
      } else if (cur.c + 1 < next.c) {
        // exiting perimeter from a corner
        dpr("hi3");
        assert(edgeAbove != null);

        inside =
            (edgeAbove! && dugDown) || (!edgeAbove && dugUp) ? !inside : inside;
      }

      if (inside) {
        int c = next.c - cur.c - 1;
        dpr("counting: $cur to $next: $c cbm");
        count += c;
      }

      prev = cur;
    }
  }
  print("done: ${stopwatch.elapsed}");
  print(count + perim.length);
}

void mainPerim(Ps perim, List<String> lines) {
  P cur = P(0, 0);
  for (String l in lines) {
    List<String> d = l.split(' ');

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

    int steps = int.parse(d[1]);

    for (int i = 0; i < steps; i++) {
      cur += di.p;
      if (cur == P(0, 0)) break;
      perim.add(cur);
    }
  }
}

void subPerim(Ps perim, List<String> lines) {
  setDebug(false);
  P cur = P(0, 0);
  for (String l in lines) {
    String d = l.split(' ')[2];

    String hex = d.substring(2, d.length - 1);

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

    int steps = int.parse(hex.substring(0, hex.length - 1), radix: 16);

    for (int i = 0; i < steps; i++) {
      cur += di.p;
      if (cur == P(0, 0)) break;
      perim.add(cur);
    }
  }
}
