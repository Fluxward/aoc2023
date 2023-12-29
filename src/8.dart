import 'common.dart';

void d8(bool s) {
  List<String> lines = getLines();
  Map<String, ({String l, String r})> nodes = Map.fromIterable(
      List.generate(lines.length - 2, (index) {
        return lines[index + 2]
            .replaceAll('=', ',')
            .replaceAll(RegExp(r'[ ()]'), '')
            .split(',');
      }),
      key: (n) => n[0],
      value: (n) => (l: n[1], r: n[2]));

  s ? b8(lines[0], nodes) : a8(lines[0], nodes);
}

// straightforward implementation of the searching algorithm specified
void a8(String turns, Map<String, ({String l, String r})> nodes) {
  String cur = 'AAA';
  int count = 0;
  int index = 0;

  while (cur != 'ZZZ') {
    cur = turns[index] == "L" ? nodes[cur]!.l : nodes[cur]!.r;
    index = (index + 1) % turns.length;
    count++;
  }

  print(count);
}

// Find how many steps to reach an endpoint for each start, then find the LCM of
// all those counts.
void b8(String turns, Map<String, ({String l, String r})> nodes) {
  List<String> starts = nodes.keys.where((n) => n[2] == 'A').toList();
  List<String> c = List.of(starts);
  List<int> cycles = List.filled(starts.length, 0);

  for (int i = 0; i < starts.length; i++) {
    int index = 0;
    int count = 0;
    while (c[i][2] != 'Z') {
      c[i] = turns[index] == "L" ? nodes[c[i]]!.l : nodes[c[i]]!.r;
      index = (index + 1) % turns.length;
      count++;
    }
    cycles[i] = count;
  }
  print(cycles);
  print(cycles.fold<int>(1, (p, e) => lcm(p, e)));
}
