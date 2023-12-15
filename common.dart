import 'dart:io';
import 'dart:math';

typedef P = Point<int>;
typedef Ps = List<P>;

extension RCUtil on P {
  int get r => this.x;
  int get c => this.y;
}

extension RCLUtil on Ps {
  void rsort([bool ascending = true]) {
    if (ascending) {
      sort((a, b) => rComp(a, b));
    } else {
      sort(((a, b) => -rComp(a, b)));
    }
  }

  void rcsort([bool ascending = true]) {
    if (ascending) {
      sort((a, b) => rcComp(a, b));
    } else {
      sort(((a, b) => -rcComp(a, b)));
    }
  }

  void csort([bool ascending = true]) {
    if (ascending) {
      sort((a, b) => cComp(a, b));
    } else {
      sort(((a, b) => -cComp(a, b)));
    }
  }

  void crsort([bool ascending = true]) {
    if (ascending) {
      sort((a, b) => crComp(a, b));
    } else {
      sort(((a, b) => -crComp(a, b)));
    }
  }

  int rComp(P a, P b) {
    return a.r - b.r;
  }

  int rcComp(P a, P b) {
    int r = a.r - b.r;
    return r == 0 ? a.c - b.c : r;
  }

  int cComp(P a, P b) {
    return a.c - b.c;
  }

  int crComp(P a, P b) {
    int c = a.c - b.c;
    return c == 0 ? a.r - b.r : c;
  }
}

extension SUtil on String {
  int firstWhere(bool Function(int) test) {
    int i = 0;
    for (; i < this.length; i++) {
      if (test(i)) {
        return i;
      }
    }
    return -1;
  }
}

Map<String, int> _digits =
    Map.fromEntries([for (int i = 0; i < 10; i++) MapEntry(i.toString(), i)]);

int? isDigit(String s) {
  assert(s.length == 1);
  return _digits[s];
}

int? stoi(String s) {
  int? acc;
  for (int i = 0; i < s.length; i++) {
    int? d = isDigit(s[i]);
    if (d == null) {
      break;
    }

    acc = acc != null ? 10 * acc + d : d;
  }
  return acc;
}

List<int> stois(String s, {String sep = ' '}) {
  return List.from(s.split(sep).map((e) => int.tryParse(e)).nonNulls);
}

List<String> getLines() => [
      for (String? line = stdin.readLineSync();
          line != null;
          line = stdin.readLineSync())
        line
    ];

bool inBounds(int r, int c, List<String> l) {
  return !(r < 0 || r >= l.length || c < 0 || c >= l[r].length);
}

bool _debug = true;
void setDebug(bool d) => _debug = d;

void dpr(Object? object) {
  if (!_debug) {
    return;
  }
  print(object);
}
