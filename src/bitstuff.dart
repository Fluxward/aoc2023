// bit bite counts
import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';

import '19.dart';

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

  int ceilDiv(int div) {
    return (this + div - 1) ~/ div;
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
    _fastCopyInto(dest, len, start, tcs);
  }

  /// copies len bits from this array starting from start into dest starting from the tcs'th int
  void _fastCopyInto(BitArray dest, int len, int start, int tcs) {
    if (len < 0) throw Error();
    if (len == 0) return;
    if (len < 64) {
      copySubIntInto(dest, len, start, tcs * 64);
      return;
    }

    dest.data[tcs] = getIntAt(start);
    _fastCopyInto(dest, len - 64, start + 64, tcs + 1);
  }

  void fastCopyWithOffset(BitArray to, int len, int fS, int tS) {
    if (len < 64) {
      copySubIntInto(to, len, fS, tS);
      return;
    }

    if (tS % 64 == 0) {
      fastCopyInto(to, len, fS, tS ~/ 64);
      return;
    }

    int firstSourceChunk = getIntAt(fS);

    int hb = tS % 64;
    int lb = 64 - hb;
    int ch = tS ~/ 64;

    ({int lo, int hi}) s = split(firstSourceChunk, lb);

    to.data[ch] = replaceBits(to.data[ch], s.lo, lowMasks[lb] << hb);

    fastCopyInto(to, len - lb, fS + lb, ch + 1);
  }

  void copySubIntInto(BitArray to, int len, int fS, int tS) {
    int source = getIntAt(fS) & lowMasks[len];

    to.copySubIntFrom(source, len, tS);
  }

  void copySubIntFrom(int source, int len, int start) {
    int hb = start % 64;
    int ch = start ~/ 64;
    if (hb == 0) {
      data[ch] = replaceBits(data[ch], source, lowMasks[len]);
      return;
    }
    int lb = 64 - hb;

    ({int lo, int hi}) s = split(source, lb);

    data[ch] = replaceBits(
        data[ch], s.lo, (len >= lb ? lowMasks[lb] : lowMasks[len]) << hb);

    if (ch + 1 > data.length || len <= lb) return;

    data[ch + 1] = replaceBits(data[ch + 1], s.hi, lowMasks[len - lb]);
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
    StringBuffer bString = StringBuffer();
    for (int i = 0; i < length; i++) {
      bString.write(this[i] ? '1' : '0');
    }
    return bString.toString();
  }
}

BitArray bitCompare(BitArray a, BitArray b, int Function(int a, int b) operator,
    {int? nbits}) {
  int len = min(a.length, b.length);
  if (nbits != null) {
    len = min(len, nbits);
  }

  BitArray cmp = BitArray(len);
  int nCh = (len + 63) ~/ 64;
  int bits = 0;
  for (int i = 0; i < nCh; i++) {
    cmp.data[i] = operator(a.data[i], b.data[i]);
    bits += 64;
    if (bits > len) {
      int rem = bits - len;
      cmp.data[i] &= lowMasks[64 - rem];
    }
  }
  return cmp;
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

/// A 2D array of bits.
/// The rows are aligned to the size of an int.
class AlignedBitMatrix {
  final List<BitArray> rows;

  final int nr;
  final int nc;

  AlignedBitMatrix(this.nr, this.nc)
      : rows =
            List<BitArray>.generate(nr, (_) => BitArray(nc), growable: false);

  int countTrue(
      {int startRow = 0, int startCol = 0, int? endRow, int? endCol}) {
    int er = endRow ?? nr;
    int ec = endCol ?? nc;

    int res = 0;
    for (int r = startRow; r < er; r++) {
      res += rows[r].slice(ec - startCol, startCol, 1).numTrue;
    }

    return res;
  }

  BitArray operator [](int i) => rows[i];

  int get hashCode => Object.hashAll([nr, nc, rows]);

  bool operator ==(other) =>
      other is AlignedBitMatrix &&
      other.nr == nr &&
      other.nc == nc &&
      rows.firstWhereIndexedOrNull((i, e) => e != other.rows[i]) == null;
}
