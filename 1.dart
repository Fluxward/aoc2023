import 'dart:io';

void day1s() {
  Map<String, int> digits =
      Map.fromEntries([for (int i = 0; i < 10; i++) MapEntry(i.toString(), i)]);

  int? check3(String line, int index) {
    if (line.length < index + 3) {
      return null;
    }

    String sub = line.substring(index, index + 3);
    return sub == "one"
        ? 1
        : sub == "two"
            ? 2
            : sub == "six"
                ? 6
                : null;
  }

  int? check4(String line, int index) {
    if (line.length < index + 4) {
      return null;
    }

    String sub = line.substring(index, index + 4);
    return sub == "four"
        ? 4
        : sub == "five"
            ? 5
            : sub == "nine"
                ? 9
                : sub == "zero"
                    ? 0
                    : null;
  }

  int? check5(String line, int index) {
    if (line.length < index + 5) {
      return null;
    }

    String sub = line.substring(index, index + 5);
    return sub == "three"
        ? 3
        : sub == "seven"
            ? 7
            : sub == "eight"
                ? 8
                : null;
  }

  int? digitAt(String line, int index) {
    if (digits.containsKey(line[index])) {
      return digits[line[index]];
    }

    return check3(line, index) ?? check4(line, index) ?? check5(line, index);
  }

  int count = 0;
  for (String? line = stdin.readLineSync();
      line != null;
      line = stdin.readLineSync()) {
    int first = -1;
    int last = -1;

    List<String> chars = line.split('');
    for (int i = 0; i < chars.length; i++) {
      int? digit = digitAt(line, i);
      if (digit == null) {
        continue;
      }

      last = digit;
      if (first < 0) {
        first = last;
      }
    }
    count += 10 * first + last;
  }
  print(count);
}

void day1() {
  Map<String, int> digits =
      Map.fromEntries([for (int i = 0; i < 10; i++) MapEntry(i.toString(), i)]);
  int count = 0;
  for (String? line = stdin.readLineSync();
      line != null;
      line = stdin.readLineSync()) {
    int first = -1;
    int last = -1;

    List<String> chars = line.split('');
    for (int i = 0; i < chars.length; i++) {
      if (!digits.containsKey(chars[i])) {
        continue;
      }

      last = digits[chars[i]]!;
      if (first < 0) {
        first = last;
      }
    }
    count += 10 * first + last;
  }
  print(count);
}
