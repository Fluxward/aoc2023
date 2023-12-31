import 'dart:math';

import '../src/bitstuff.dart';

Stopwatch seedWatch = Stopwatch()..start();
int seed = 12;
Random r = Random(seed);
void main() {
  testBitArrayFastSlice();
  int pass = 0;
  int n = 64;
  for (int i = 0; i < n; i++) {
    bool fail = testFastCopy();
    //print(fail ? 'fail' : 'pass');
    pass += fail ? 0 : 1;
  }
  print("$pass passed");
  testFastCopyWithOffset();
}

void testBitArrayFastSlice() {
  int length = 1123747;
  BitArray a = BitArray(length);

  for (int i = 0; i < length; i++) {
    a[i] = r.nextBool();
  }

  int start = 483285;
  int len = 23425;
  BitArray b = a.fastSlice(len, start);

  for (int i = 0; i < b.length; i++) {
    if (a[start + i] != b[i]) {
      print("failed at $i");
    }
    assert(a[start + i] == b[i]);
  }
}

bool testFastCopy() {
  int length = 10000 + r.nextInt(10000);
  BitArray a = BitArray(length);
  BitArray b = BitArray(length);
  BitArray c = BitArray(length);

  for (int i = 0; i < length; i++) {
    a[i] = r.nextBool();
    b[i] = r.nextBool();
  }

  int len = r.nextInt(5000);
  int start = r.nextInt(5000);
  for (int i = 0; i < c.data.length; i++) {
    c.data[i] = b.data[i];
  }
  a.fastCopyInto(b, len, start);

  bool fail = false;
  for (int i = 0; i < length; i++) {
    if (i < len) {
      fail |= b[i] != a[i + start];
    } else {
      fail |= b[i] != c[i];
    }
    if (fail) {
      print("failed: $start, $i, $len");
      return fail;
    }
  }
  return fail;
}

void testFastCopyWithOffset() {
  int length = 1123747;
  BitArray a = BitArray(length);

  for (int i = 0; i < length; i++) {
    a[i] = (i % 16 == 15) ? false : r.nextBool();
  }

  int len = 234250;

  BitArray b = BitArray(len);

  int fS = 16;
  int tS = 48;
  int tL = 63 * 63;
  a.fastCopyWithOffset(b, tL, fS, tS);

  bool fail = false;
  for (int i = 0; i < len; i++) {
    if (i >= tS && i < (tS + tL)) {
      fail |= b[i] != a[fS + i - tS];
    } else {
      fail |= b[i];
    }
    if (fail) {
      print("failed at $i, ${i % 64}");
      print(b.data[i ~/ 64].toRadixString(16));
      return;
    }
  }
  if (!fail) print("pass");
}
