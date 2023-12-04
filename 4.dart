import 'common.dart';

void day4(bool sub) {
  List<String> lines = getLines();
  sub ? day4b(lines) : day4a(lines);
}

({List<int> wn, List<int> n}) getNumbers(String line) {
  List<String> lr = line.split(" | ");

  return (wn: (stois(lr[0].split(': ')[1])), n: (stois(lr[1])));
}

void day4a(List<String> lines) {
  print(lines.fold<int>(0, (acc, line) {
    int m = matches(line);
    return acc + (m != 0 ? (1 << (m - 1)) : 0);
  }));
}

void day4b(List<String> lines) {
  List<int> totalMatches = lines.map((e) => matches(e)).toList();

  // total copies won, including copies won from copies.
  List<int> cachedWins = List.filled(totalMatches.length, -1);
  int totalWins(int i) {
    // return cached result if it exists
    if (cachedWins[i] > 0) {
      return cachedWins[i];
    }

    int count = totalMatches[i];
    // count the copies won from the subsequent copied cards
    for (int j = 1; j <= totalMatches[i]; j++) {
      count += totalWins(i + j);
    }

    // cache the result
    cachedWins[i] = count;
    return count;
  }

  int totalCards = totalMatches.length; // count all the originals
  // count all the wins
  for (int i = 0; i < totalMatches.length; i++) {
    totalCards += totalWins(i);
  }
  print(totalCards);
}

int matches(String line) {
  ({List<int> wn, List<int> n}) card = getNumbers(line);
  Set<int> wn = Set.from(card.wn);

  return card.n.fold<int>(0, (prev, e) => prev + (wn.contains(e) ? 1 : 0));
}
