import '../common.dart';

bool subset = false;
d13(bool s) {
  subset = s;
  List<String> lines = getLines();

  int total = 0;
  for (int i = 0; i < lines.length; i++) {
    int j;
    for (j = i; j < lines.length && lines[j].isNotEmpty; j++);

    List<String> sl = lines.sublist(i, j);
    total += checkVertical(sl) ?? 100 * checkHorizontal(sl);

    i = j;
  }

  print(total);
}

int checkHorizontal(List<String> lines) {
  List<int> h = List.generate(
      lines.length,
      (i) => lines[i]
          .split('')
          .fold<int>(0, (p, e) => (p << 1) + (e == '#' ? 1 : 0)));

  return findMirror(h)!;
}

int? checkVertical(List<String> lines) {
  List<int> h = List.generate(lines[0].length,
      (i) => lines.fold<int>(0, (p, e) => (p << 1) + (e[i] == '#' ? 1 : 0)));

  return findMirror(h);
}

int? findMirror(List<int> h) {
  if (subset) return findMirrorSmudged(h);
  // gaps between cols, starting from 0
  for (int i = 0; i < h.length - 1; i++) {
    bool valid = true;
    for (int j = 0; (i + j + 1) < h.length && (i - j) >= 0; j++) {
      if (h[i + j + 1] != h[i - j]) {
        valid = false;
        break;
      }
    }
    if (valid) {
      return i + 1;
    }
  }

  return null;
}

int? findMirrorSmudged(List<int> h) {
  // gaps between cols, starting from 0
  for (int i = 0; i < h.length - 1; i++) {
    bool valid = true;
    bool smudgeFound = false;
    for (int j = 0; (i + j + 1) < h.length && (i - j) >= 0; j++) {
      int a = h[i + j + 1];
      int b = h[i - j];

      if (a != b) {
        if (!isSmudge(a, b) || smudgeFound) {
          valid = false;
          break;
        }

        smudgeFound = true;
      }
    }
    if (valid && smudgeFound) {
      return i + 1;
    }
  }

  return null;
}

bool isSmudge(int a, int b) {
  int x = a ^ b;

  return (x & (x - 1)) == 0;
}
