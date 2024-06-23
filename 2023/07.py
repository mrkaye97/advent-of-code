from enum import Enum
from collections import Counter

with open("data/day7.txt", "r") as f:
    data = f.read().split("\n")


class HandType(str, Enum):
    FIVE_OF_A_KIND = 7
    FOUR_OF_A_KIND = 6
    FULL_HOUSE = 5
    THREE_OF_A_KIND = 4
    TWO_PAIR = 3
    ONE_PAIR = 2
    HIGH_CARD = 1


card_values = {
    "A": 14,
    "K": 13,
    "Q": 12,
    "J": 11,
    "T": 10,
    "9": 9,
    "8": 8,
    "7": 7,
    "6": 6,
    "5": 5,
    "4": 4,
    "3": 3,
    "2": 2,
    "1": 1,
}


class Hand:
    def __init__(self, cards: str, bid: str):
        self.cards = [card_values[c] for c in list(cards)]
        self.bid = int(bid)

    def get_type(self, hand) -> HandType:
        item_counts = Counter(hand.cards)

        if len(set(hand.cards)) == 1:
            return HandType.FIVE_OF_A_KIND
        elif any([v == 4 for v in item_counts.values()]):
            return HandType.FOUR_OF_A_KIND
        elif len(item_counts) == 2 and any([v == 3 for v in item_counts.values()]):
            return HandType.FULL_HOUSE
        elif any([v == 3 for v in item_counts.values()]):
            return HandType.THREE_OF_A_KIND
        elif sum([v == 2 for v in item_counts.values()]) == 2:
            return HandType.TWO_PAIR
        elif sum([v == 2 for v in item_counts.values()]) == 1:
            return HandType.ONE_PAIR
        else:
            return HandType.HIGH_CARD

    @property
    def type(self) -> HandType:
        return self.get_type(self)

    @property
    def type_after_swapping(self) -> HandType:
        item_counts = Counter(self.cards)

        if not any([k == 11 for k in item_counts.keys()]):
            return self.type

        ## At this point, there's at least one Joker present
        if len(item_counts) == 5:
            most_common_item = max(item_counts.keys())
            if most_common_item == 11:
                most_common_item = sorted(item_counts.keys(), reverse=True)[1]
        else:
            most_common_item = item_counts.most_common(1)[0][0]
            if (
                item_counts.most_common(1)[0][0] == 11
                and len(item_counts) > 1
                and item_counts.most_common(2)[1][0] > 1
            ):
                most_common_item = item_counts.most_common(2)[1][0]
            elif (
                most_common_item == 11
                and len(item_counts) > 1
                and max(item_counts.keys()) != 11
            ):
                most_common_item = max(item_counts.keys())
            elif most_common_item == 11 and len(item_counts) > 1:
                most_common_item = sorted(item_counts.keys(), reverse=True)[1]

        inv_card_values = {v: k for k, v in card_values.items()}

        new_hand = "".join(map(lambda x: inv_card_values[x], self.cards))
        new_hand = new_hand.replace("J", inv_card_values[most_common_item])
        r = self.get_type(Hand(cards=list(new_hand), bid=self.bid))
        return r

    def __lt__(self, other):
        if self.type_after_swapping.value != other.type_after_swapping.value:
            return self.type_after_swapping.value < other.type_after_swapping.value
        else:
            for pair in zip(self.cards, other.cards):
                if pair[0] != pair[1]:
                    lhs = 0 if pair[0] == 11 else pair[0]
                    rhs = 0 if pair[1] == 11 else pair[1]
                    return lhs < rhs

    def __repr__(self):
        return f"<Hand Object> Cards: {self.cards}; Bid: {self.bid}; Type: {self.type}"


hands = list(map(lambda x: Hand(*x.split()), data))

print("Part I Solution:", sum([h.bid * (ix + 1) for ix, h in enumerate(sorted(hands))]))
