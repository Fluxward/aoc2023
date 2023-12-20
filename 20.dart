import 'dart:collection';

import 'common.dart';

d20(bool b) {
  initModules();
  while (buttonPresses++ < 10000) {
    bt.recv(false, bt.id); // add a button press to the queue

    while (q.isNotEmpty) {
      var t = q.removeFirst();
      t.$1 ? hPulses += t.$2.length : lPulses += t.$2.length;
      t.$2.forEach((s) => mods[s]!.recv(t.$1, t.$3));
    }
    if (buttonPresses == 1000 && !b) {
      print("$lPulses, $hPulses, ${lPulses * hPulses}");
      return;
    }
  }

  Com ft = mods['ft'] as Com;
  print(ft.cycles.values.fold<int>(1, (p, e) => p = lcm(p, e[0])));
}

void initModules() {
  List<String> ls = getLines();

  for (List<String> d in ls.map((e) => e.replaceAll(' ', '').split('->'))) {
    String pName = d[0].substring(1);
    Mod cur = d[0] == bc.id
        ? bc
        : mods[pName] = d[0][0] == "%" ? Ffm(pName) : Com(pName);
    cur.out.addAll(d[1].split(','));
  }

  List<Mod> untyped = [];
  mods.values.forEach((m) => m.out.forEach((s) {
        if (mods[s] == null) untyped.add(Utm(s));
        if (mods[s] is Com) (mods[s]! as Com).vals[m.id] = false;
      }));
  untyped.forEach((element) => mods[element.id] = element);
  mods.values.forEach((e) => e.out.forEach((k) => mods[k]?.ins.add(e.id)));
}

Queue<(bool, List<String>, String)> q = Queue();
Bcm bc = Bcm("broadcaster");
Btm bt = Btm("button");
Map<String, Mod> mods = {bc.id: bc, bt.id: bt};

int buttonPresses = 0;
int hPulses = 0;
int lPulses = 0;

abstract class Mod {
  final String id;
  final Set<String> ins = {};
  final List<String> out = [];

  Mod(this.id);

  void recv(bool high, String senderId);

  void send(bool high) => q.add((high, out, id));
}

class Utm extends Mod {
  Utm(super.id);

  void recv(bool high, String senderId) {}
}

class Ffm extends Mod {
  bool on = false;
  List<int> cycles = [];

  Ffm(super.id);

  void recv(bool high, String _) => !high ? send(on = high ? on : !on) : ();
}

class Com extends Mod {
  Map<String, bool> vals = {};
  int nH = 0;
  Map<String, List<int>> cycles = {};

  Com(super.id);

  void recv(bool high, String senderId) {
    if (vals[senderId] != (vals[senderId] = high)) {
      nH = high ? nH + 1 : nH - 1;
      cycles.putIfAbsent(senderId, () => <int>[]).add(buttonPresses);
    }
    send(nH != vals.length);
  }
}

class Bcm extends Mod {
  Bcm(super.id);

  void recv(bool high, String _) => send(high);
}

class Btm extends Mod {
  Btm(super.id) {
    out.add(bc.id);
  }

  void recv(bool high, String _) => send(false);
}
