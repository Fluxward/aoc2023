import 'common.dart';

enum HandType {
  kind5(rank: 0),
  kind4(rank: -1),
  fullHouse(rank: -2),
  kind3(rank: -3),
  twoPair(rank: -4),
  onePair(rank: -5),
  highCard(rank: -6);

  final int rank;

  const HandType({required this.rank});
}

Map<String, int> cardVal = {
  "j": 1,
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
  "T": 10,
  "J": 11,
  "Q": 12,
  "K": 13,
  "A": 14,
};

class JHand implements Comparable {
  late final Hand jh;
  late final Hand ah;
  late final int rank;
  final int bid;

  JHand(String h, this.bid) : ah = Hand(h, bid) {
    Hand curMax = Hand(h, bid);
    int maxRank = -10;
    for (String s in cardVal.keys) {
      if (s == "J" || s == 'j') {
        continue;
      }
      String c = h.replaceAll('j', s);
      Hand temp = Hand(c, bid);
      if (temp.type.rank > maxRank) {
        curMax = temp;
        maxRank = temp.type.rank;
      }
    }
    jh = curMax;
    rank = maxRank;
  }

  @override
  int compareTo(other) {
    if (rank != other.rank) {
      return rank.compareTo(other.rank);
    }

    for (int i = 0; i < 5; i++) {
      if (ah.hand[i] != other.ah.hand[i]) {
        return ah.hand[i].compareTo(other.ah.hand[i]);
      }
    }

    return 0;
  }
}

class Hand implements Comparable {
  late final HandType type;
  final List<int> hand;
  late final List<int> sorted;
  final int bid;

  Hand(String h, this.bid)
      : this.hand = List.generate(5, (i) => cardVal[h[i]]!) {
    sorted = List.of(this.hand);
    sorted.sort();

    List<int> counts = List.filled(5, 0);
    int prev = -1;
    int cur = -1;
    for (int i = 0; i < 5; i++) {
      if (sorted[i] > prev) {
        prev = sorted[i];
        cur++;
      }
      counts[cur]++;
    }

    counts.sort();

    switch (counts[4]) {
      case 5:
        type = HandType.kind5;
      case 4:
        type = HandType.kind4;
      case 3:
        if (counts[3] == 2) {
          type = HandType.fullHouse;
        } else {
          type = HandType.kind3;
        }
      case 2:
        if (counts[3] == 2) {
          type = HandType.twoPair;
        } else {
          type = HandType.onePair;
        }
      case 1:
        type = HandType.highCard;
    }
  }

  @override
  int compareTo(other) {
    if (type != other.type) {
      return (type.rank.compareTo(other.type.rank));
    }

    for (int i = 0; i < 5; i++) {
      if (hand[i] != other.hand[i]) {
        return hand[i].compareTo(other.hand[i]);
      }
    }

    return 0;
  }
}

void d7(bool s) {
  !s ? a7() : b7();
}

void a7() {
  List<Hand> hands = getLines().map((e) {
    List<String> d = e.split(' ');
    return Hand(d[0], stoi(d[1])!);
  }).toList();

  hands.sort();

  int sum = 0;

  for (int i = 0; i < hands.length; i++) {
    sum += (i + 1) * hands[i].bid;
  }

  print(sum);
}

void b7() {
  List<JHand> hands = getLines().map((e) {
    List<String> d = e.split(' ');
    return JHand(d[0].replaceAll('J', 'j'), stoi(d[1])!);
  }).toList();

  hands.sort();

  int sum = 0;

  for (int i = 0; i < hands.length; i++) {
    sum += (i + 1) * hands[i].bid;
  }

  print(sum);
}
