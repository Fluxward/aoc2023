import '../common.dart';

void d5(bool subset) {
  List<String> lines = getLines();
  subset ? day5b(lines) : day5a(lines);
}

void day5a(List<String> lines) {
  Map<int, List<Set<int>>> ordering = {};
  int nline = 0;
  for (String line = lines.first; line.contains('|'); line = lines[++nline]) {
    List<int> rule = line.split('|').map((e) => int.parse(e)).toList();

    ordering.putIfAbsent(rule[0], () => [{}, {}]);
    ordering.putIfAbsent(rule[1], () => [{}, {}]);

    ordering[rule[0]]![0].add(rule[1]);
    ordering[rule[1]]![1].add(rule[0]);
  }

  int count = 0;
  for (; nline < lines.length; nline++) {
    List<int> pages = 
  }
  print(ordering);

}

void day5b(List<String> lines) {

}
