import '../common.dart';
import 'package:collection/collection.dart';

Map<int, List<Set<int>>> ordering = {};
int nline = 0;

void d5(bool subset) {
  List<String> lines = getLines();
  for (String line = lines.first; line.contains('|'); line = lines[++nline]) {
    List<int> rule = line.split('|').map((e) => int.parse(e)).toList();

    ordering.putIfAbsent(rule[0], () => [{}, {}]);
    ordering.putIfAbsent(rule[1], () => [{}, {}]);

    ordering[rule[0]]![0].add(rule[1]);
    ordering[rule[1]]![1].add(rule[0]);
  }

  subset ? day5b(lines) : day5a(lines);
}

int comp(int a, int b) {
  if (a == b) return 0;
  if (ordering[a]![0].contains(b)) return -1;
  return 1;
}

void day5a(List<String> lines) {
  int count = 0;
  for (nline++; nline < lines.length; nline++) {
    List<int> pages = lines[nline].split(",").map((e) => int.parse(e)).toList();
    if (pages.isSorted(comp)) {
      count += pages[pages.length >> 1];
    }
  }
  print(count);
}

void day5b(List<String> lines) {
  int count = 0;
  for (nline++; nline < lines.length; nline++) {
    List<int> pages = lines[nline].split(",").map((e) => int.parse(e)).toList();
    if (!pages.isSorted(comp)) {
      pages.sort(comp);
      count += pages[pages.length >> 1];
    }
  }
  print(count);
}


