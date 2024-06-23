import copy
from typing import Any, Callable, Optional, List, Tuple

from dataclasses import dataclass

from itertools import product
from functools import reduce


def flat_map(f: Callable[[Any], Any], xs: List[Any]) -> List[Any]:
    return reduce(lambda a, b: a + b, map(f, xs))


with open("data/day3.txt", "r") as f:
    data = f.read().split("\n")

numbers = [str(x) for x in range(10)]


@dataclass
class Coordinates:
    row: int
    column: int


def capture_number_from_starting_position(
    row: List[str], starting_position: int
) -> Optional[Tuple[int, int, int]]:
    ## ..314...
    ## start: 4
    ## return: (3, 5, 314)
    ## in format (start, end, value)

    if row[starting_position] not in numbers:
        return None

    captured = ""
    left_index = copy.deepcopy(starting_position)
    while True:
        left_index -= 1
        if left_index < 0:
            break

        if row[left_index] not in numbers:
            break

        if row[left_index] in numbers:
            captured = row[left_index] + captured

    captured += row[starting_position]
    right_index = copy.deepcopy(starting_position)
    while True:
        right_index += 1
        if right_index >= len(row):
            break

        if row[right_index] not in numbers:
            break

        if row[right_index] in numbers:
            captured += row[right_index]

    return (int(left_index), int(right_index), int(captured))


def determine_rows_to_check(data: List[List[str]], current_row: int) -> List[int]:
    if current_row == 0:
        return [current_row, current_row + 1]
    elif current_row == len(data):
        return [current_row - 1, current_row]
    else:
        return [current_row - 1, current_row, current_row + 1]


def determine_cols_to_check(row: List[str], current_col: int) -> List[int]:
    if current_col == 0:
        return [current_col, current_col + 1]
    elif current_col == len(row) - 1:
        return [current_col - 1, current_col]
    else:
        return [current_col - 1, current_col, current_col + 1]


def find_adjacent_numbers(data: List[List[str]], coords: Coordinates) -> List[int]:
    rows_to_check = determine_rows_to_check(data=data, current_row=coords.row)
    cols_to_check = determine_cols_to_check(
        row=data[coords.row], current_col=coords.column
    )

    result = [
        capture_number_from_starting_position(data[r], c)
        for r in rows_to_check
        for c in cols_to_check
    ]

    return list({r for r in result if r})


grid = list(
    map(
        lambda point: Coordinates(row=point[0], column=point[1]),
        product(range(len(data)), range(len(data[0]))),
    )
)


symbols = filter(
    lambda coords: data[coords.row][coords.column] not in numbers + ["."], grid
)

part_1 = flat_map(
    lambda coords: find_adjacent_numbers(data=data, coords=coords), symbols
)

print("Part I Solution:", sum(map(lambda record: int(record[2]), part_1)))

gears = filter(lambda coords: data[coords.row][coords.column] == "*", grid)

part_2 = filter(
    lambda x: len(x) == 2,
    map(lambda coords: find_adjacent_numbers(data=data, coords=coords), gears),
)

print("Part II Solution:", sum(map(lambda record: record[0][2] * record[1][2], part_2)))
