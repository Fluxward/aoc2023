import 'dart:math';

import 'common.dart';

void d5(bool subset) {
  List<String> lines = getLines();
  subset ? day5b(lines) : day5a(lines);
}

class RangeMapEntry {
  int fromStart;
  int fromEnd;
  int toStart;
  int toEnd;
  int length;

  RangeMapEntry(this.fromStart, this.toStart, this.length)
      : fromEnd = fromStart + length - 1,
        toEnd = toStart + length - 1 {}

  bool fromContains(int index) {
    return index >= fromStart && index < (fromStart + length);
  }

  int reIndex(int old) {
    return (old - fromStart) + toStart;
  }

  (int, int) reIndexRange(int s, int e) {
    return (reIndex(s), reIndex(e));
  }

  String toString() => "$fromStart, $toStart, $length";

  (int, int) get from => (fromStart, fromEnd);
  (int, int) get to => (toStart, toEnd);
}

List<List<RangeMapEntry>> getRanges(List<String> lines) {
  List<List<RangeMapEntry>> entries = List.empty(growable: true);
  int curEntry = -1;
  for (int i = 2; i < lines.length; i++) {
    if (lines[i].contains(':')) {
      curEntry++;
      entries.add(List.empty(growable: true));
    } else if (lines[i].isNotEmpty) {
      List<int> r = stois(lines[i], sep: ' ');
      entries[curEntry].add(RangeMapEntry(r[1], r[0], r[2]));
    }
  }

  entries.forEach(
      (element) => element.sort((a, b) => a.fromStart.compareTo(b.fromStart)));
  return entries;
}

(int, int)? hasIntersection((int, int) a, (int, int) b) {
  if (a.$1 > b.$1) {
    (a, b) = (b, a);
  }
  if (a.$2 < b.$1 || a.$1 > b.$2) {
    return null;
  }

  return (max(a.$1, b.$1), min(a.$2, b.$2));
}

void day5a(List<String> lines) {
  List<int> seeds = stois(lines[0].split(': ')[1], sep: ' ');

  List<List<RangeMapEntry>> ranges = getRanges(lines);

  List<int> prev = List.from(seeds);
  print(prev);
  for (int i = 0; i < ranges.length; i++) {
    List<int> cur = List.empty(growable: true);
    for (int j in prev) {
      bool found = false;
      for (RangeMapEntry r in ranges[i]) {
        if (r.fromContains(j)) {
          cur.add(r.reIndex(j));
          found = true;
        }
      }
      if (!found) {
        cur.add(j);
      }
    }

    prev = cur;
    print(prev);
  }
  prev.sort();
  print(prev[0]);
}

void day5b(List<String> lines) {
  List<int> seeds = stois(lines[0].split(': ')[1], sep: ' ');
  List<(int, int)> seedRanges = List.generate(seeds.length >> 1,
      (i) => (seeds[2 * i], seeds[2 * i] + seeds[2 * i + 1] - 1));

  seedRanges.sort((a, b) => a.$1.compareTo(b.$1));

  List<List<RangeMapEntry>> ranges = getRanges(lines);

  List<(int, int)> prev = List.from(seedRanges);
  for (int i = 0; i < ranges.length; i++) {
    List<(int, int)> cur = List.empty(growable: true);
    for (int j = 0; j < prev.length; j++) {
      List<(int, int)> mappedRanges = List.empty(growable: true);
      for (int k = 0; k < ranges[i].length; k++) {
        (int, int)? ixn = hasIntersection(prev[j], ranges[i][k].from);
        if (ixn != null) {
          mappedRanges.add(ixn);
          cur.add(ranges[i][k].reIndexRange(ixn.$1, ixn.$2));
        }
      }
      if (mappedRanges.isEmpty) {
        cur.add(prev[j]);
      } else {
        mappedRanges.sort((a, b) => a.$1.compareTo(b.$1));
        int s = prev[j].$1;
        int end = prev[j].$2;
        for (int k = 0; k < mappedRanges.length; k++) {
          (int, int) range = mappedRanges[k];
          if (s < range.$1) {
            cur.add((s, min(range.$1 - 1, end)));
          }

          s = min(range.$2 + 1, end);

          if (s == end) {
            break;
          }

          if (k == mappedRanges.length - 1) {
            cur.add((s, end));
          }
        }
      }
    }
    cur.sort((a, b) => a.$1.compareTo(b.$1));
    prev = cur;
  }
  print(prev[0]);
}
