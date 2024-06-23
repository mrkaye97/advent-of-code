from typing import Optional, List
import re

with open("data/day1.txt", "r") as f:
    data = f.read().split("\n")


def find_digit(s: str) -> str:
    for char in s:
        if char in map(lambda x: str(x), range(10)):
            return char

    return ""


result = sum(map(lambda line: int(find_digit(line) + find_digit(line[::-1])), data))

print("Part I Answer:", result)

digits = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
}


def try_finding_right_index(s: str, substring: str) -> Optional[int]:
    try:
        return s.rindex(substring)
    except ValueError:
        return None


def try_finding_left_index(s: str, substring: str) -> Optional[int]:
    match = s.find(substring)

    return match if match > -1 else None


def argmax(x: List[int]) -> int:
    _max = 0
    _argmax = 0

    for ix, value in enumerate(x):
        if value and value > _max:
            _argmax = ix
            _max = value

    return _argmax


def find_digit_index(s: str, regex: str) -> Optional[int]:
    digit_index = re.search(regex, s)

    return digit_index.start() if digit_index else None


def transform_spelled_out_digits(s: str) -> str:
    last_digit_index = find_digit_index(s, r"(\d)(?!.*\d)")

    print(last_digit_index)

    right_indices = list(
        filter(
            lambda x: x["index"] is not None,
            map(
                lambda x: {
                    "index": try_finding_right_index(s, x),
                    "digit_key": x,
                    "digit_value": str(digits[x]),
                },
                digits.keys(),
            ),
        )
    )

    right_side_to_replace = (
        sorted(right_indices, key=lambda x: x["index"], reverse=True)[0]
        if right_indices
        else None
    )

    if right_side_to_replace and right_side_to_replace["index"] > (
        last_digit_index or -1
    ):
        s = (
            s[: right_side_to_replace["index"]]
            + right_side_to_replace["digit_value"]
            + s[
                right_side_to_replace["index"]
                + len(right_side_to_replace["digit_key"]) :
            ]
        )
    else:
        right_side_to_replace = None

    first_digit_index = find_digit_index(s, r"\d")

    left_indices = list(
        filter(
            lambda x: x["index"] is not None,
            map(
                lambda x: {
                    "index": try_finding_left_index(s, x),
                    "digit_key": x,
                    "digit_value": str(digits[x]),
                },
                digits.keys(),
            ),
        )
    )

    left_side_to_replace = (
        sorted(left_indices, key=lambda x: x["index"])[0] if left_indices else None
    )

    if left_side_to_replace == right_side_to_replace:
        left_side_to_replace = None

    if left_side_to_replace and left_side_to_replace["index"] < (
        first_digit_index or 999_999
    ):
        s = (
            s[: left_side_to_replace["index"]]
            + left_side_to_replace["digit_value"]
            + s[
                left_side_to_replace["index"] + len(left_side_to_replace["digit_key"]) :
            ]
        )

    return s


transformed = map(transform_spelled_out_digits, data)

result_2 = sum(
    map(lambda line: int(find_digit(line) + find_digit(line[::-1])), transformed)
)

print("Part II Answer:", result_2)
