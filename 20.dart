import 'dart:collection';

import 'common.dart';

d20(bool b) {
  initModules();

  Stopwatch sw = Stopwatch()..start();
  for (int i = 0; i < 1000000000000000000 && !(b && done); i++) {
    if (i % 100000 == 0) {
      print(sw.elapsed);
    }
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
        //print("${t.$3} -${t.$1 ? 'high' : 'low'}-> $s");
        mods[s]!.recv(t.$1, t.$3);
        if (b && done) {
          print(sw.elapsed);
          return;
        }
      }
    }
  }
  print("$lPulses, $hPulses, ${lPulses * hPulses}");
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

  Ffm(super.id);

  void recv(bool high, String _) {
    super.recv(high, _);
    if (high) return;
    on = high ? on : !on;
    send(on);
  }
}

class Com extends Mod {
  Map<String, bool> vals = {};
  int nH = 0;

  Com(super.id);

  void recv(bool high, String senderId) {
    super.recv(high, senderId);
    bool p = vals[senderId]!;

    vals[senderId] = high;

    if (p != high) {
      nH = high ? nH + 1 : nH - 1;
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
        untyped.add(Utm(s));
      }
    }
  }
  untyped.forEach((element) => mods[element.id] = element);
}
