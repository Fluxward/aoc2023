import 'common.dart';

d11(bool s) {
  setDebug(false);
  int mult = s ? 1000000 : 2;
  List<P> n = parse(getLines(), mult);

  int sum = 0;
  for (int i = 0; i < n.length; i++) {
    for (int j = i + 1; j < n.length; j++) {
      sum += m(n[i], n[j]);
    }
  }
  print(sum);
}

int m(P a, P b) => (a.r - b.r).abs() + (a.c - b.c).abs();

List<P> parse(List<String> input, int mult) {
  List<P> galaxies = [];
  List<int> cols = [];

  int rowOffset = 0;
  mult--; // decrement since the indices already include an offset for each row

  for (int i = 0; i < input.length; i++) {
    bool found = false;
    for (int j = 0; j < input[0].length; j++) {
      if (input[i][j] == '#') {
        found = true;
        galaxies.add(P(i + (rowOffset * mult), j));
      }
    }
    if (!found) {
      rowOffset++;
    }
  }

  for (int c = 0; c < input[0].length; c++) {
    if (input.every((element) => element[c] == '.')) {
      cols.add(c);
    }
  }

  galaxies.sort((a, b) => a.c - b.c);

  int i = 0;
  while (galaxies[i].c < cols[0]) {
    i++;
  }
  for (int c = 0; c < cols.length; c++) {
    while (i < galaxies.length &&
        !(c < cols.length - 1 && galaxies[i].c > cols[c + 1])) {
      galaxies[i] += P(0, (c + 1) * mult);
      i++;
    }
  }
  return galaxies;
}
