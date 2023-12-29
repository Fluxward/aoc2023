import 'dart:io';

void d2(bool s) => s ? day2s() : day2();

void day2s() {
  int count = 0;
  for (String? line = stdin.readLineSync();
      line != null;
      line = stdin.readLineSync()) {
    Map<String, int> counts = {'d': 0, 'n': 0, 'e': 0};
    List<String> game = line.split(': ');

    List<String> trials = game[1].split("; ");
    for (String trial in trials) {
      List<String> cubes = trial.split(', ');
      for (String cube in cubes) {
        List<String> c = cube.split(' ');
        int n = int.parse(c[0]);
        if (counts[c[1][c[1].length - 1]]! < n) {
          counts[c[1][c[1].length - 1]] = n;
        }
      }
    }

    count += counts['d']! * counts['n']! * counts['e']!;
  }
  print(count);
}

void day2() {
  int count = 0;
  Map<String, int> counts = {'d': 12, 'n': 13, 'e': 14};
  for (String? line = stdin.readLineSync();
      line != null;
      line = stdin.readLineSync()) {
    List<String> game = line.split(': ');
    bool possible = true;

    List<String> trials = game[1].split("; ");
    for (String trial in trials) {
      List<String> cubes = trial.split(', ');
      for (String cube in cubes) {
        List<String> c = cube.split(' ');
        int n = int.parse(c[0]);
        if (counts[c[1][c[1].length - 1]]! < n) {
          possible = false;
          break;
        }
      }
      if (!possible) {
        break;
      }
    }

    if (possible) {
      count += int.parse(game[0].split(' ')[1]);
    }
  }
  print(count);
}
