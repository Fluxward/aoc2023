import '../common.dart';

d14(bool s) {
  setDebug(false);
  s ? b14() : a14();
}

a14() {
  List<String> l = getLines();

  int load = 0;
  int length = l.length;
  for (int i = 0; i < l[0].length; i++) {
    int r = 0;
    int c = 0;

    for (int j = 0; j < length; j++) {
      switch (l[j][i]) {
        case 'O':
          load += (length - c - r);
          r++;
        case '#':
          r = 0;
          c = j + 1;
      }
    }
  }

  dpr(load);
}

// north west south east
b14() {
  List<String> l = getLines();

  final int nr = l.length;
  final int nc = l[0].length;

  // cubes by row
  List<List<int>> cbr = List.generate(nr, (index) => []);
  for (int r = 0; r < nr; r++) {
    // add zero cubes on either side
    cbr[r].add(-1);
    for (int c = 0; c < nc; c++) {
      if (l[r][c] == '#') {
        cbr[r].add(c);
      }
    }
    cbr[r].add(nc);
  }

  //cubes by column
  List<List<int>> cbc = List.generate(nc, (index) => []);
  for (int c = 0; c < nc; c++) {
    // add zero cubes on either side
    cbc[c].add(-1);
    for (int r = 0; r < nr; r++) {
      if (l[r][c] == '#') {
        cbc[c].add(r);
      }
    }
    cbc[c].add(nr);
  }

  //List of rocks
  Ps rs = [];
  for (int r = 0; r < nr; r++) {
    for (int c = 0; c < nc; c++) {
      if (l[r][c] == 'O') {
        rs.add(P(r, c));
      }
    }
  }

  Map<int, (int, int)> seen = Map();
  List<int> order = [];
  for (int i = 0; i < 999999999; i++) {
    cycle(rs, cbr, cbc);
    int hash = Object.hashAll(rs);
    if (seen.containsKey(hash)) {
      int target = 999999999;
      int first = seen[hash]!.$1;
      print("$first, $i");

      int cycleLength = i - first;

      int steps = (target - first) % cycleLength;
      int key = order[steps + first];
      print(seen[key]);
      return;
    }
    int load = 0;
    for (P r in rs) {
      load += nr - r.r;
    }
    seen[hash] = (i, load);
    order.add(hash);
  }

  int load = 0;
  for (P r in rs) {
    load += nr - r.r;
  }

  Ps cs = [];
  for (int r = 0; r < nr; r++) {
    for (int c = 1; c < cbr[r].length - 1; c++) {
      //dpr(P(r, cbr[r][c]));
      cs.add(P(r, cbr[r][c]));
    }
  }
  rs.rcsort();
  cs.rcsort();
  int cR = 0;
  int cC = 0;
  for (int r = 0; r < nr; r++) {
    StringBuffer sb = StringBuffer();
    for (int c = 0; c < nc; c++) {
      if (cR < rs.length && rs[cR].r == r && rs[cR].c == c) {
        cR++;
        sb.write('O');
      } else if (cC < cs.length && cs[cC].r == r && cs[cC].c == c) {
        cC++;
        sb.write('#');
      } else {
        sb.write('.');
      }
    }
    print(sb);
  }
  print(load);
}

void cycle(Ps rs, List<List<int>> cbr, List<List<int>> cbc) {
  rs.crsort(); // ascending cols, rows
  tiltNorth(rs, cbc);
  dpr(rs);
  rs.rcsort(false);
  tiltWest(rs, cbr);
  dpr(rs);
  rs.crsort(false); // descending cols, rows
  tiltSouth(rs, cbc);
  dpr(rs);
  rs.rcsort();
  tiltEast(rs, cbr);
  dpr(rs);
}

void tiltNorth(Ps rs, List<List<int>> cbc) {
  int cR = 0;
  dpr(rs);
  dpr("tilting north");
  for (int c = 0; c < cbc.length && cR < rs.length; c++) {
    int ci = 0;
    int curRocks = 1;
    while (cR < rs.length && rs[cR].c == c && ci < cbc[c].length - 1) {
      int nextCube = cbc[c][ci + 1];
      if (rs[cR].r > nextCube) {
        curRocks = 1;
        ci++;
      } else {
        rs[cR] = P(curRocks + cbc[c][ci], c);
        curRocks++;
        cR++;
      }
    }
  }
}

void tiltEast(Ps rs, List<List<int>> cbr) {
  int cR = 0;

  dpr(rs);
  dpr("tilting east");
  for (int r = 0; r < cbr.length && cR < rs.length; r++) {
    int ci = 0;
    int curRocks = 1;
    while (cR < rs.length && rs[cR].r == r && ci < cbr[r].length - 1) {
      int nextCube = cbr[r][ci + 1];
      if (rs[cR].c > nextCube) {
        curRocks = 1;
        ci++;
      } else {
        rs[cR] = P(r, nextCube - curRocks);
        curRocks++;
        cR++;
      }
    }
  }
}

void tiltSouth(Ps rs, List<List<int>> cbc) {
  int cR = 0;
  dpr(rs);
  dpr("tilting south");
  for (int c = cbc.length - 1; c >= 0 && cR < rs.length; c--) {
    int ci = cbc[c].length - 1;
    int curRocks = 1;
    while (cR < rs.length && rs[cR].c == c && ci > 0) {
      int nextCube = cbc[c][ci - 1];
      if (rs[cR].r < nextCube) {
        curRocks = 1;
        ci--;
      } else {
        rs[cR] = P(cbc[c][ci] - curRocks, c);
        curRocks++;
        cR++;
      }
    }
  }
}

void tiltWest(Ps rs, List<List<int>> cbr) {
  int cR = 0;
  dpr(rs);
  dpr("tilting west");
  for (int r = cbr.length - 1; r >= 0 && cR < rs.length; r--) {
    dpr(cbr[r]);
    int ci = cbr[r].length - 1;
    int curRocks = 1;
    while (cR < rs.length && rs[cR].r == r && ci > 0) {
      int nextCube = cbr[r][ci - 1];
      dpr(nextCube);
      if (rs[cR].c < nextCube) {
        curRocks = 1;
        ci--;
      } else {
        dpr(rs[cR]);
        rs[cR] = P(r, nextCube + curRocks);
        dpr(rs[cR]);
        curRocks++;
        cR++;
      }
    }
  }
}
