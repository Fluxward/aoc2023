// bit bite counts
import 'package:collection/collection.dart';

import 'common.dart';

List<int> bBiC = List.unmodifiable([
  0, //0000
  1, //0001
  1, //0010
  2, //0011
  1, //0100
  2, //0101
  2, //0110
  3, //0111
  1, //1000
  2, //1001
  2, //1010
  3, //1011
  2, //1100
  3, //1101
  3, //1110
  4, //1111
]);

List<int> lowMasks =
    List.unmodifiable(List.generate(65, (i) => (1 << i) - 1, growable: false));

List<int> bBC = List.unmodifiable(
    List.generate(256, (i) => bBiC[i & 0xF] + bBiC[(i >> 4) & 0xF]));

extension PC on int {
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

class BitSet implements Set<int> {
  final List<int> _set;

  int _length = 0;

  BitSet(int size) : _set = List.filled((size / 64).ceil(), 0);

  void _panic() => throw Error();

  void _maybeRangePanic(int value) => _inRange(value) ? () : _panic();

  bool _inRange(int value) {
    return value >= 0 && value < (64 * _set.length);
  }

  @override
  bool add(int value) {
    _maybeRangePanic(value);

    if (contains(value)) {
      return false;
    }
    _length += 1;
    int n = value ~/ 64;
    int b = value % 64;

    _set[n] |= (1 << b);

    return true;
  }

  @override
  void addAll(Iterable<int> elements) {
    elements.forEach((element) {
      add(element);
    });
  }

  @override
  bool any(bool Function(int element) test) {
    // TODO: implement any
    throw UnimplementedError();
  }

  @override
  Set<R> cast<R>() {
    // TODO: implement cast
    throw UnimplementedError();
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  bool contains(Object? value) {
    return value != null &&
        value is int &&
        _inRange(value) &&
        (_set[value ~/ 64] & (1 << (value % 64)) > 0);
  }

  @override
  bool containsAll(Iterable<Object?> other) {
    return other.every((element) => _set.contains(element));
  }

  @override
  Set<int> difference(Set<Object?> other) {
    // TODO: implement difference
    throw UnimplementedError();
  }

  @override
  int elementAt(int index) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  @override
  bool every(bool Function(int element) test) {
    // TODO: implement every
    throw UnimplementedError();
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(int element) toElements) {
    // TODO: implement expand
    throw UnimplementedError();
  }

  @override
  // TODO: implement first
  int get first => throw UnimplementedError();

  @override
  int firstWhere(bool Function(int element) test, {int Function()? orElse}) {
    // TODO: implement firstWhere
    throw UnimplementedError();
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, int element) combine) {
    // TODO: implement fold
    throw UnimplementedError();
  }

  @override
  Iterable<int> followedBy(Iterable<int> other) {
    // TODO: implement followedBy
    throw UnimplementedError();
  }

  @override
  void forEach(void Function(int element) action) {
    // TODO: implement forEach
  }

  @override
  Set<int> intersection(Set<Object?> other) {
    // TODO: implement intersection
    throw UnimplementedError();
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => throw UnimplementedError();

  @override
  // TODO: implement isNotEmpty
  bool get isNotEmpty => throw UnimplementedError();

  @override
  // TODO: implement iterator
  Iterator<int> get iterator => throw UnimplementedError();

  @override
  String join([String separator = ""]) {
    // TODO: implement join
    throw UnimplementedError();
  }

  @override
  // TODO: implement last
  int get last => throw UnimplementedError();

  @override
  int lastWhere(bool Function(int element) test, {int Function()? orElse}) {
    // TODO: implement lastWhere
    throw UnimplementedError();
  }

  @override
  // TODO: implement length
  int get length => _length;

  @override
  int? lookup(Object? object) {
    // TODO: implement lookup
    throw UnimplementedError();
  }

  @override
  Iterable<T> map<T>(T Function(int e) toElement) {
    // TODO: implement map
    throw UnimplementedError();
  }

  @override
  int reduce(int Function(int value, int element) combine) {
    // TODO: implement reduce
    throw UnimplementedError();
  }

  @override
  bool remove(Object? value) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    // TODO: implement removeAll
  }

  @override
  void removeWhere(bool Function(int element) test) {
    // TODO: implement removeWhere
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    // TODO: implement retainAll
  }

  @override
  void retainWhere(bool Function(int element) test) {
    // TODO: implement retainWhere
  }

  @override
  // TODO: implement single
  int get single => throw UnimplementedError();

  @override
  int singleWhere(bool Function(int element) test, {int Function()? orElse}) {
    // TODO: implement singleWhere
    throw UnimplementedError();
  }

  @override
  Iterable<int> skip(int count) {
    // TODO: implement skip
    throw UnimplementedError();
  }

  @override
  Iterable<int> skipWhile(bool Function(int value) test) {
    // TODO: implement skipWhile
    throw UnimplementedError();
  }

  @override
  Iterable<int> take(int count) {
    // TODO: implement take
    throw UnimplementedError();
  }

  @override
  Iterable<int> takeWhile(bool Function(int value) test) {
    // TODO: implement takeWhile
    throw UnimplementedError();
  }

  @override
  List<int> toList({bool growable = true}) {
    // TODO: implement toList
    throw UnimplementedError();
  }

  @override
  Set<int> toSet() {
    // TODO: implement toSet
    throw UnimplementedError();
  }

  @override
  Set<int> union(Set<int> other) {
    // TODO: implement union
    throw UnimplementedError();
  }

  @override
  Iterable<int> where(bool Function(int element) test) {
    // TODO: implement where
    throw UnimplementedError();
  }

  @override
  Iterable<T> whereType<T>() {
    // TODO: implement whereType
    throw UnimplementedError();
  }

  int get hashCode => Object.hashAll(_set);

  bool operator ==(Object other) {
    if (!(other is BitSet)) {
      return false;
    }

    bool eq = true;
    for (int i = 0; i < _set.length; i++) {
      eq &= other._set[i] == _set[i];
    }
    return eq;
  }

  BitSet.of(BitSet other) : _set = List<int>.of(other._set);
}

class BitArray {
  final int length;
  // dart ints are little endian.
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

  /// copies len bits from this array starting from start into dest starting from the tcs'th int
  void fastCopyInto(BitArray dest, int len, int start, [int tcs = 0]) {
    int i = 0;

    int sc = start ~/ 64;
    int hiBits = start % 64;
    int loBits = 64 - hiBits;

    int total = 0;

    int lo;
    int hi;
    for (; total < len; i++) {
      int rem = len - total;
      int og = dest.data[tcs + i];
      if (rem <= loBits) {
        lo = (data[sc + i] >> hiBits) & lowMasks[rem];
        hi = og & ~lowMasks[rem];
        total = len;
      } else {
        lo = (data[sc + i] >> hiBits) & lowMasks[loBits];
        total += loBits;
        rem = len - total;
        if (rem <= hiBits) {
          hi = (data[sc + i + 1] & lowMasks[rem]) << (loBits);
          hi |= og & ~lowMasks[rem + loBits];
        } else {
          hi = (data[sc + i + 1] & lowMasks[hiBits]) << (loBits);
        }

        total += hiBits;
      }
      dest.data[tcs + i] = lo | hi;
    }
  }

  void fastCopyWithOffset(BitArray to, int len, int fS, int tS) {
    if (tS % 64 == 0) {
      fastCopyInto(to, len, fS, tS ~/ 64);
      return;
    }

    // naive imp
    //for (int i = 0; i < len; i++) to[tS + i] = this[fS + i];

    // intwise imp
    /*
    int nChunks = (len + 63) ~/ 64;
    int lenOffset = len % 64;
    int i;
    for (i = 0; i < nChunks - 1; i++) {
      for (int b = 0; b < 64; b++) {
        to[tS + (i * 64) + b] = this[fS + (i * 64) + b];
      }
    }
    for (int b = 0; b < (lenOffset == 0 ? 64 : lenOffset); b++) {
      to[tS + (i * 64) + b] = this[fS + (i * 64) + b];
    }
    */

    int tso = tS % 64;
    int fso = fS % 64;
    int tsc = tS ~/ 64;
    int fsc = fS ~/ 64;
    // easy case.
    if (tso == fso) {
      // first chunk is segmented. keep the lower bits of to, get the high bits of from
      to.data[tsc] =
          (to.data[tsc] & lowMasks[tso]) | (this.data[fsc] & ~lowMasks[tso]);

      // copy the rest with the other methods.
      fastCopyInto(to, len - 64 + tso, fS + 64 - tso, tsc + 1);
      return;
    } else if (tso < fso) {
      // want to copy XXx to YYY
      // from = [XX  ][   x][    ]
      // to =   [YYY ][    ][    ]
      int fs0 = fso - tso; // 16
      // first chunk is 64 - tso long.
      // want a) the highest (64 - fso) bits of the first from chunk
      // and  b) the lowest (64 - tso - (64 - fso)) = fso - tso bits of the second from chunk
      int t0 = (to.data[tsc] & lowMasks[tso]) |
          (((this.data[fsc] & ~lowMasks[fso])) >> fs0) |
          ((this.data[fsc + 1] & lowMasks[fs0]) << (64 - fs0));
      to.data[tsc] = t0;

      fastCopyInto(to, len - (64 - tso), fS + (64 - tso), 1 + (tS - tso) ~/ 64);
    } else {
      // want to copy XXx to YYY, preserve ZZ
      // from = [XXX ][    ][    ]
      // to =   [YYZZ][   y][    ]
      // first chunk is 64 - tso long.
      int t0 = (to.data[tsc] & lowMasks[tso]) |
          (this.data[fsc] << (tso - fso) & ~lowMasks[tso]);
      to.data[tsc] = t0;

      fastCopyInto(to, len - (64 - tso), fS + (64 - tso), 1 + (tS - tso) ~/ 64);
    }
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

class BitMatrix {
  final int nr;
  final int nc;

  final BitArray _data;
  final BitArray _dataT;

  bool _lazyTransposed = false;

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

    BitMatrix sub = BitMatrix(nRows, nCols);

    for (int i = 0; i < nRows; i++) {
      for (int j = 0; j < nCols; j++) {
        sub[P(i, j)] = this[start + P(i, j)];
      }
    }
    return sub;
  }

  /// start is inclusive, end is exclusive
  BitMatrix subRows(int start, int end) {
    int len = (end - start) * nc;
    BitArray d = _data.slice(len, start * nc, 1);
    BitMatrix bm = BitMatrix(end - start, nc);
    bm._lazyTransposed = false;
    d.fastCopyInto(bm._data, len, 0);
    return bm;
  }

  void copyRowFromArray(int r, BitArray a) {
    a.fastCopyWithOffset(_data, nc, 0, r * nc);
    _lazyTransposed = false;
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
    if (_lazyTransposed == true) return;
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
