import 'dart:collection';

import 'common.dart';

d20(bool b) {
  initModules();
  setDebug(false);

  Stopwatch sw = Stopwatch()..start();
  for (int i = 0; i < 10000 && !(b && done); i++) {
    buttonPresses++;
    bt.recv(false, bt.id); // add a button press to the queue

    while (q.isNotEmpty && !(b && done)) {
      (bool, List<String>, String) t = q.removeFirst();

      if (t.$1) {
        hPulses += t.$2.length;
      } else {
        lPulses += t.$2.length;
      }

      for (String s in t.$2) {
        dpr("${t.$3} -${t.$1 ? 'high' : 'low'}-> $s");
        mods[s]!.recv(t.$1, t.$3);
        if (b && done) {
          print(sw.elapsed);
          return;
        }
      }
    }
    if (i == 1000 && !b) {
      print("$lPulses, $hPulses, ${lPulses * hPulses}");
    }
  }

  Com ft = mods['ft'] as Com;
  print(ft.cycles.values.fold<int>(1, (p, e) => p = lcm(p, e[0])));
}

Queue<(bool, List<String>, String)> q = Queue();
Bcm bc = Bcm("broadcaster");
Btm bt = Btm("button module");
Map<String, Mod> mods = {bc.id: bc, bt.id: bt};

int buttonPresses = 0;
bool done = false;
int hPulses = 0;
int lPulses = 0;

abstract class Mod {
  String id;
  String? pref;
  Set<String> ins = {};
  List<String> out = [];

  Mod(this.id);

  void recv(bool high, String senderId) {
    if (id == 'rx') {
      if (!high) {
        print("min bp: $buttonPresses");
        done = true;
      }
    }
  }

  void send(bool high) {
    q.add((high, out, id));
  }
}

class Utm extends Mod {
  Utm(super.id);
}

class Ffm extends Mod {
  bool on = false;
  List<int> cycles = [];

  Ffm(super.id) {
    this.pref = "FF";
  }

  void recv(bool high, String _) {
    super.recv(high, _);
    if (high) return;
    bool p = on;
    on = high ? on : !on;
    if (p != on) {
      cycles.add(buttonPresses);
    }
    send(on);
  }
}

class Com extends Mod {
  Map<String, bool> vals = {};
  int nH = 0;
  Map<String, List<int>> cycles = {};

  Com(super.id) {
    this.pref = "CN";
  }

  void recv(bool high, String senderId) {
    super.recv(high, senderId);
    bool p = vals[senderId]!;

    vals[senderId] = high;
    if (p != high) {
      nH = high ? nH + 1 : nH - 1;
      List<int> l = cycles.putIfAbsent(senderId, () => <int>[]);
      l.add(buttonPresses);
    }

    send(nH != vals.length);
  }
}

class Bcm extends Mod {
  Bcm(super.id);

  @override
  void recv(bool high, String _) {
    send(high);
  }
}

class Btm extends Mod {
  Btm(super.id) {
    out = [bc.id];
  }

  @override
  void recv(bool high, String _) {
    send(false);
  }
}

void initModules() {
  List<String> ls = getLines();

  for (String l in ls) {
    List<String> d = l.replaceAll(' ', '').split('->');
    List<String> out = d[1].split(',');

    String pName = d[0].substring(1);
    Mod cur;
    switch (d[0][0]) {
      case '%':
        cur = Ffm(pName);
        mods[pName] = cur;
      case '&':
        cur = Com(pName);
        mods[pName] = cur;
      default:
        cur = bc;
    }

    cur.out = out;
  }

  List<Mod> untyped = [];
  for (Mod m in mods.values) {
    for (String s in m.out) {
      Mod? c = mods[s];

      if (c is Com) {
        c.vals[m.id] = false;
      } else if (c == null) {
        c = Utm(s);
        untyped.add(c);
        continue;
      }
    }
  }
  untyped.forEach((element) => mods[element.id] = element);
  mods.values.forEach((e) {
    e.out.forEach((k) {
      mods[k]?.ins.add(e.id);
    });
  });
}
