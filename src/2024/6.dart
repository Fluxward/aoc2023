import '../common.dart';
import '../geom.dart';

void d6(bool subset) {
  List<String> lines = getLines();
  subset ? day6b(lines) : day6a(lines);
}

void day6a(List<String> lines) {
  List<List<bool>> grid = [...lines.map((e) => [...e.split('').map((c) => c == '#')])];
  
  P start = P(lines.indexWhere((e) => e.contains('^')), lines.fold(0, (p, e) => e.contains('^') ? e.indexOf('^') : p));

  Set<P> visited = {};
  Set<GridVec> explored = {};

  GridVec cur = GridVec(start, dir.u);

  while (true) {
    visited.add(cur.pos);
    explored.add(cur);

    GridVec next = cur.walk;
    if (!inBoundsString(next.pos.r, next.pos.c, lines)) {
      break;
    }
    while (grid[next.pos.r][next.pos.c]) {
      cur = GridVec(cur.pos, cur.d.rt);
      next = cur.walk;
    }
    cur = next;
  }

  print(visited.length);
}

bool hasLoop(List<List<bool>> grid, GridVec start) {
  Set<GridVec> explored = {};

  GridVec cur = start;

  while (true) {
    if (!explored.add(cur)) {
      return true;
    }
    explored.add(cur);

    GridVec next = cur.walk;
    if (!inBounds(next.pos.r, next.pos.c, grid)) {
      return false;
    }
    while (grid[next.pos.r][next.pos.c]) {
      cur = GridVec(cur.pos, cur.d.rt);
      next = cur.walk;
      if (!inBounds(next.pos.r, next.pos.c, grid)) {
        return false;
      }
    }
    cur = next;
  }
}

void day6b(List<String> lines) {
  List<List<bool>> grid = [...lines.map((e) => [...e.split('').map((c) => c == '#')])];
  
  P start = P(lines.indexWhere((e) => e.contains('^')), lines.fold(0, (p, e) => e.contains('^') ? e.indexOf('^') : p));

  GridVec cur = GridVec(start, dir.u);

  int count = 0;
  int empty = 0;
  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid.length; j++) {
      if (grid[i][j]) {
        empty++;
        continue;}
      grid[i][j] = true;
      if (hasLoop(grid, cur)) {
        //print("found at row $i, col $j");
        count++;
      }

      grid[i][j] = false;
    }
  }

  print("possibilities: $count, empty spaces = $empty, total size = ${grid.length * grid[0].length}");
}

