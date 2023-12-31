// bit bite counts
import 'dart:math';

import 'package:collection/collection.dart';

import 'common.dart';

final List<int> bBiC =
    List.unmodifiable([0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4]);

final List<int> lowMasks =
    List.unmodifiable(List.generate(65, (i) => (1 << i) - 1, growable: false));

final List<int> bBC = List.unmodifiable(
    List.generate(256, (i) => bBiC[i & 0xF] + bBiC[(i >> 4) & 0xF]));

extension BitOperations on int {
  int get popcount =>
      bBC[this & 0xff] +
      bBC[(this >> 8) & 0xff] +
      bBC[(this >> 16) & 0xff] +
      bBC[(this >> 24) & 0xff] +
      bBC[(this >> 32) & 0xff] +
      bBC[(this >> 40) & 0xff] +
      bBC[(this >> 48) & 0xff] +
      bBC[(this >> 56) & 0xff];

  String get toBString {
    StringBuffer sb = StringBuffer();

    for (int i = 0; i < 64; i++) {
      sb.write((this >> (63 - i)) & 1 == 1 ? '1' : '0');
    }
    return sb.toString();
  }
}

int window(int a, int b, int offset) {
  if (offset < 0 || offset > 63) throw Error();
  int hb = offset;
  int lb = 64 - hb;

  return (a >> hb) & lowMasks[lb] | (b << lb) & ~lowMasks[lb];
}

({int lo, int hi}) split(int a, int nLowBits) {
  int hb = 64 - nLowBits;

  return (lo: (a << hb) & ~lowMasks[hb], hi: (a >> nLowBits) & lowMasks[hb]);
}

int replaceBits(int d, int s, int m) => (d & ~m) | s & m;

class BitArray {
  final int length;
  List<int> data;

  BitArray(this.length) : data = List.filled((length + 63) ~/ 64, 0);

  bool operator [](int i) => data[i ~/ 64] & (1 << (i % 64)) != 0;

  void operator []=(int i, bool v) {
    int bit = i % 64;
    int e = i ~/ 64;

    data[e] = (data[e] & ~(1 << bit)) | ((v ? 1 : 0) << bit);
  }

  int get hashCode => Object.hashAll([length, data]);

  bool operator ==(other) =>
      other is BitArray &&
      other.length == length &&
      data.foldIndexed<bool>(true, (i, p, e) => p && other[i] == e);

  BitArray slice(int len, int start, int inc) {
    if (inc == 1) return fastSlice(len, start);
    BitArray l = BitArray(len);
    for (int i = 0; i < len; i++) {
      l[i] = this[start + (i * inc)];
    }
    return l;
  }

  BitArray fastSlice(int len, int start) {
    BitArray a = BitArray(len);
    fastCopyInto(a, len, start);
    return a;
  }

  int getIntAt(int bit) {
    if (bit < 0) return 0;
    int c = bit ~/ 64;

    return window((c < data.length) ? data[c] : 0,
        (c + 1 < data.length) ? data[c + 1] : 0, bit % 64);
  }

  /// copies len bits from this array starting from start into dest starting from the tcs'th int
  void fastCopyInto(BitArray dest, int len, int start, [int tcs = 0]) {
    if (len < 0) throw Error();
    if (len == 0) return;
    if (len < 64) {
      copySubInt(dest, len, start, tcs * 64);
      return;
    }

    dest.data[tcs] = getIntAt(start);
    fastCopyInto(dest, len - 64, start + 64, tcs + 1);
  }

  void fastCopyWithOffset(BitArray to, int len, int fS, int tS) {
    if (len < 64) {
      copySubInt(to, len, fS, tS);
      return;
    }

    if (tS % 64 == 0) {
      fastCopyInto(to, len, fS, tS ~/ 64);
      return;
    }

    int firstSourceChunk = getIntAt(fS);

    int loBits = tS % 64;
    int hiBits = 64 - loBits;
    int toChunks = tS ~/ 64;

    ({int lo, int hi}) s = split(firstSourceChunk, hiBits);

    to.data[toChunks] =
        replaceBits(to.data[toChunks], s.lo, lowMasks[hiBits] << loBits);

    fastCopyInto(to, len - hiBits, fS + hiBits, 1 + (tS - loBits) ~/ 64);
  }

  void copySubInt(BitArray to, int len, int fS, int tS) {
    int source = getIntAt(fS) | lowMasks[len];
    int hb = tS % 64;
    int ch = tS ~/ 64;
    if (hb == 0) {
      to.data[ch] = replaceBits(to.data[ch], source, lowMasks[len]);
      return;
    }
    int lb = 64 - hb;

    ({int lo, int hi}) s = split(source, lb);

    to.data[ch] = replaceBits(
        to.data[ch], s.lo, (len >= lb ? lowMasks[lb] : lowMasks[len]) << hb);

    if (ch + 1 > to.data.length || len <= lb) return;

    to.data[ch + 1] = replaceBits(to.data[ch + 1], s.hi, lowMasks[len - lb]);
  }

  BitArray copyFrom(int len, int nChunks, int startChunk) {
    BitArray a = BitArray(len);
    for (int i = 0; i < nChunks; i++) {
      a.data[i] = this.data[i + startChunk];
    }
    return a;
  }

  int get numTrue => data.fold<int>(0, (p, e) => p + e.popcount);

  bool get isEmpty => data.fold<bool>(true, (p, e) => p && e == 0);

  bool get isNotEmpty => !isEmpty;

  String toString() {
    return numTrue.toString();
  }
}

BitArray windowBitCompare(
    BitArray a, BitArray b, int Function(int a, int b) operator,
    {int as = 0, int bs = 0, int? aL, int? bL}) {
  int len = min(aL ?? (a.length - as), bL ?? (b.length - bs));
  BitArray cmp = BitArray(len);
  int nCh = (len + 63) ~/ 64;

  int bits = 0;
  for (int i = 0; i < nCh; i++) {
    cmp.data[i] = operator(a.getIntAt(as + bits), b.getIntAt(bs + bits));
    bits += 64;
    if (bits > len) {
      int rem = bits - len;
      cmp.data[i] &= lowMasks[64 - rem];
    }
  }
  return cmp;
}

class BitMatrix {
  final int nr;
  final int nc;

  final BitArray _data;
  final BitArray _dataT;

  bool _transposeReady = false;

  BitMatrix(this.nr, this.nc)
      : _data = BitArray(nr * nc),
        _dataT = BitArray(nr * nc);

  BitMatrix subMatrix(P start, P end) {
    if (start.r >= end.r ||
        start.c >= end.c ||
        !inBounds(start) ||
        !inBounds(end - P(1, 1))) throw Error();

    int nRows = end.r - start.r;
    int nCols = end.c - start.c;

    if (nCols == nc) return subRows(start.r, end.r);

    BitMatrix sub = BitMatrix(nRows, nCols);
    sub._transposeReady = false;

    for (int i = 0; i < nRows; i++) {
      _data.fastCopyWithOffset(
          sub._data, nCols, nc * (start.r + i) + start.c, i * nRows);
    }
    return sub;
  }

  /// start is inclusive, end is exclusive
  BitMatrix subRows(int start, int end) {
    int len = (end - start) * nc;
    BitMatrix bm = BitMatrix(end - start, nc);
    _data.fastCopyInto(bm._data, len, start * nc);
    bm._transposeReady = false;
    return bm;
  }

  void copyRowFromArray(int r, BitArray a) {
    a.fastCopyWithOffset(_data, nc, 0, r * nc);
    _transposeReady = false;
  }

  bool operator [](P p) => _data[p.r * nc + p.c];

  void operator []=(P p, bool v) {
    _data[p.r * nc + p.c] = (v);
    _dataT[p.c * nr + p.r] = (v);
  }

  int get hashCode => Object.hashAll([nr, nc, _data]);

  bool operator ==(other) =>
      other is BitMatrix &&
      other.nr == nr &&
      other.nc == nc &&
      other._data == _data;

  BitArray side(dir d) => d == dir.d
      ? this.d
      : d == dir.u
          ? this.u
          : d == dir.l
              ? this.l
              : this.r;

  BitArray get l => vSlice(0);
  BitArray get r => vSlice(nc - 1);
  BitArray get u => hSlice(0);
  BitArray get d => hSlice(nr - 1);

  BitArray vSlice(int c) {
    doTranspose();
    return _dataT.slice(nr, nr * c, 1);
  }

  BitArray hSlice(int r) => _data.slice(nc, nc * r, 1);

  bool inBounds(P p) => p.r >= 0 && p.r < nr && p.c >= 0 && p.c < nc;

  int get numTrue => _data.numTrue;

  void doTranspose() {
    if (_transposeReady == true) return;
    for (int r = 0; r < nr; r++) {
      for (int c = 0; c < nc; c++) {
        _dataT[c * nr + r] = _data[r * nc + c];
      }
    }
  }

  String toString() {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < nr; i++) {
      for (int j = 0; j < nc; j++) {
        sb.write(this[P(i, j)] ? 'X' : '.');
      }
      sb.write('\n');
    }
    return sb.toString();
  }
}
