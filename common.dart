import 'dart:io';

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

List<int> stoisPositive(String s, {String sep = ' '}) {
  return List.from(s.split(sep).map((e) => stoi(e)).nonNulls);
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
