from dataclasses import dataclass


@dataclass
class LotteryCard:
    id: int
    winning_numbers: set[int]
    my_numbers: set[int]

    @property
    def wins(self):
        return self.my_numbers.intersection(self.winning_numbers)

    @property
    def value(self):
        return 2 ** (len(self.wins) - 1) if self.wins else 0

    def __add__(self, other):
        return self.value + other

    def __radd__(self, other):
        return self + other


with open("data/day4.txt", "r") as f:
    data = f.read().split("\n")


def parse_card(s: str) -> LotteryCard:
    card_id, card_numbers = s.split(":")
    winning_numbers, my_numbers = card_numbers.strip().split(" | ")

    return LotteryCard(
        id=int(card_id.strip().split("Card ")[1].strip()),
        winning_numbers={
            int(n.strip()) for n in winning_numbers.strip().split(" ") if n
        },
        my_numbers={int(n.strip()) for n in my_numbers.strip().split(" ") if n},
    )


cards = list(map(parse_card, data))

print("Part I Solution:", sum(cards))


## Dynamic programming for II
memo = {}

for card in cards[::-1]:
    new_cards_won = cards[card.id : (card.id + len(card.wins))]
    children_values = sum([memo[c.id] for c in new_cards_won])
    memo[card.id] = len(new_cards_won) + children_values


print("Part II Solution:", len(cards) + sum(memo.values()))
