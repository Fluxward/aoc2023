import 'dart:io';

import '../common.dart';

void d3(bool s) => s ? day3s() : day3();
void day3s() {
  List<String> lines = [
    for (String? line = stdin.readLineSync();
        line != null;
        line = stdin.readLineSync())
      line
  ];

  // lazy processing + memoization
  List<Map<int, int?>> digs = [for (int i = 0; i < lines.length; i++) Map()];
  int? isDigitMem(int r, int c) {
    if (r < 0 || r > lines.length || c < 0 || c > lines[0].length) return null;
    return digs[r].putIfAbsent(c, () => isDigit(lines[r][c]));
  }

  int stoi(int row, int col) {
    int acc = 0;
    for (int i = col; i < lines[0].length; i++) {
      int? d = isDigitMem(row, i);
      if (d != null) {
        acc = (acc * 10) + d;
      } else {
        break;
      }
    }
    return acc;
  }

  int? stoiSearch(int row, int col) {
    assert(row >= 0 && col >= 0 && row < lines.length && col < lines[0].length);
    if (isDigitMem(row, col) == null) {
      return null;
    }
    int i = col - 1;
    while (i >= 0) {
      if (isDigitMem(row, i) == null) {
        return stoi(row, i + 1);
      }
      i--;
    }
    return stoi(row, 0);
  }

  List<Map<int, int?>> s2i = [for (int i = 0; i < lines.length; i++) Map()];
  int? stoiSearchMem(int row, int col) {
    if (row < 0 || row >= lines.length) return null;
    if (col < 0 || col >= lines[0].length) return null;
    return s2i[row].putIfAbsent(col, () => stoiSearch(row, col));
  }

  int count = 0;
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[0].length; j++) {
      if (lines[i][j] != "*") {
        continue;
      }

      List<int> gearVals = List.empty(growable: true);
      for (int x = -1; x <= 1; x++) {
        int? left = stoiSearchMem(i + x, j - 1);
        int? mid = stoiSearchMem(i + x, j);
        int? right = stoiSearchMem(i + x, j + 1);

        if (isDigitMem(i + x, j) == null) {
          if (left != null) {
            gearVals.add(left);
          }

          if (right != null) {
            gearVals.add(right);
          }
        } else if (left != null) {
          gearVals.add(left);
        } else if (mid != null) {
          gearVals.add(mid);
        } else if (right != null) {
          gearVals.add(right);
        }
      }

      if (gearVals.length == 2) {
        count += gearVals[0] * gearVals[1];
      }
    }
  }

  print(count);
}

void day3() {
  List<String> lines = [
    for (String? line = stdin.readLineSync();
        line != null;
        line = stdin.readLineSync())
      line
  ];

  List<Map<int, int?>> digs = [for (int i = 0; i < lines.length; i++) Map()];
  int? isDigitMem(int r, int c) {
    return digs[r].putIfAbsent(c, () => isDigit(lines[r][c]));
  }

  // null if no int
  // first int is the value
  // second int is the length
  List<int> stoi(int row, int col) {
    int acc = 0;
    int length = 0;
    for (int i = col; i < lines[0].length; i++) {
      int? d = isDigitMem(row, i);
      if (d != null) {
        acc = (acc * 10) + d;
        length++;
      } else {
        break;
      }
    }
    return [acc, length];
  }

  List<Map<int, bool>> syms = [for (int i = 0; i < lines.length; i++) Map()];
  bool isSymbol(int r, int c) {
    return syms[r].putIfAbsent(c, () {
      String s = lines[r][c];
      bool isS = s != "." && isDigit(s) == null;
      syms[r][c] = isS;
      return isS;
    });
  }

  bool isValidInt(int row, int col, int length) {
    // check upper row including diagonals
    if (row > 0) {
      for (int i = (col > 0 ? col - 1 : col);
          i < lines[0].length && i < col + length + 1;
          i++) {
        if (isSymbol(row - 1, i)) {
          return true;
        }
      }
    }

    // check left char
    if (col > 0 && isSymbol(row, col - 1)) {
      return true;
    }

    // check right char
    if (col + length < lines[0].length && isSymbol(row, col + length)) {
      return true;
    }

    // check lower row
    if (row + 1 < lines.length) {
      for (int i = (col > 0 ? col - 1 : col);
          i < lines[0].length && i < col + length + 1;
          i++) {
        if (isSymbol(row + 1, i)) {
          return true;
        }
      }
    }

    return false;
  }

  int sum = 0;
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[0].length;) {
      int? curD = isDigitMem(i, j);
      if (curD == null) {
        j++;
        continue;
      }

      List<int> curInt = stoi(i, j);

      //print(curInt[0]);

      if (isValidInt(i, j, curInt[1])) {
        sum += curInt[0];
      }
      j += curInt[1];
    }
  }
  print(sum);
}
