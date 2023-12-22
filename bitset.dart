// bit bite counts
List<int> bBiC = [
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
];

List<int> bBC = List.generate(256, (i) => bBiC[i & 0xF] + bBiC[(i >> 4) & 0xF]);

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
