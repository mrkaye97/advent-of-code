from math import prod, sqrt, floor, ceil
from functools import reduce

with open("data/day6.txt", "r") as f:
    data = f.read().split("\n")

data = list(zip(*map(lambda x: x.split(":")[1].split(), data)))


def determine_num_winning_charge_times(race: tuple[str, str]) -> int:
    race_duration = int(race[0])
    race_record_distance = int(race[1])

    low = floor(
        (
            -1 * race_duration
            + sqrt(race_duration**2 - 4 * (-1) * (-1 * race_record_distance))
        )
        / (-2)
    )
    high = ceil(
        (
            -1 * race_duration
            - sqrt(race_duration**2 - 4 * (-1) * (-1 * race_record_distance))
        )
        / (-2)
    )

    return high - low - 1


print("Part I Solution:", prod(map(determine_num_winning_charge_times, data)))
print(
    "Part II Solution:",
    determine_num_winning_charge_times(
        reduce(lambda l, r: (l[0] + r[0], l[1] + r[1]), data)
    ),
)
