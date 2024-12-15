
import '../alg.dart';
import '../common.dart';

final BigInt ca = BigInt.from(3);
final BigInt cb = BigInt.from(1);

bool doSub = false;
class Input {
  final BigInt x;
  final BigInt y;
  final BigInt ax;
  final BigInt ay;
  final BigInt bx;
  final BigInt by;

  Input(BigInt tx, BigInt ty, this.ax, this.ay, this.bx, this.by) : this.x = tx + BigInt.from(doSub ? 10000000000000 : 0), this.y = ty + BigInt.from(doSub ? 10000000000000 : 0);

  Input.fromList(List<BigInt> x) : this(x[0], x[1], x[2], x[3], x[4], x[5]);

  void printB() => print(x + y + ax + bx + ay + by);

  BigInt? solve() {
    BIM2 m = BIM2(ax, bx, ay, by);

    BIM2? di = m.detInverse;
    if (di == null) return null;

    BigInt a = (di.a * x + di.b * y);
    BigInt b = (di.c * x + di.d * y);

    if (di.det == BigInt.zero) {
      print("possible linear combo found!");
      if (BIM2(x, ax, y, ay).det != 0) return null; 
      print("possible linear combo found!");
      return null;
    }
    
    if (a % m.det != BigInt.zero || b % m.det != BigInt.zero) {
      //print("case has no sol.");
      return null;
    }

    BigInt nca = a ~/ m.det;
    BigInt ncb = b ~/ m.det;

    return nca * ca + ncb * cb;
  }
}


List<Input> parse() {
  List<String> input = getLines();
  int size = (input.length + 1) ~/ 4;
  print(size);

  List<Input> out = [];
  for (int i = 0; i < size; i++) {
    out.add(Input.fromList(RegExp(r'(\d+)')
        .allMatches([input[4 * i + 2], input[4 * i], input[4 * i + 1]].join())
        .map((m) => m.group(1)!)
        .map(BigInt.parse)
        .toList()));
  }

  return out;
}



d13(bool sub) {
  doSub = sub;
  print(parse().map((i) => i.solve()).nonNulls.reduce((a, b) => a + b));
}

