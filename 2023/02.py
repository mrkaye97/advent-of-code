from dataclasses import dataclass
from enum import Enum
from typing import List

with open("data/day2.txt", "r") as f:
    data = f.read().split("\n")


class Color(Enum):
    BLUE = "blue"
    GREEN = "green"
    RED = "red"


color_limits = {
    Color.BLUE: 14,
    Color.RED: 12,
    Color.GREEN: 13,
}


@dataclass
class Draw:
    blue: int
    green: int
    red: int


@dataclass
class Game:
    id: int
    draws: List[Draw]


def get_color_count(draw: str, color: Color) -> int:
    for color_count in draw.split(","):
        if color.value in color_count.strip():
            return int(color_count.strip().split(" ")[0].strip())


def parse_draw(draw: str) -> Draw:
    return Draw(
        blue=get_color_count(draw, Color.BLUE),
        green=get_color_count(draw, Color.GREEN),
        red=get_color_count(draw, Color.RED),
    )


def parse_game(record: str) -> Game:
    name_id, records = record.split(":")
    id = name_id.split(" ")[1]
    draws = [d.strip() for d in records.split(";")]

    return Game(id=int(id), draws=[parse_draw(d) for d in draws])


games = [parse_game(record) for record in data]


def is_game_valid(game: Game) -> bool:
    for draw in game.draws:
        if (
            ((draw.blue or 0) > color_limits[Color.BLUE])
            or ((draw.green or 0) > color_limits[Color.GREEN])
            or ((draw.red or 0) > color_limits[Color.RED])
        ):
            return False

    return True


print("Part I Answer:", sum([g.id for g in games if is_game_valid(g)]))


def compute_power(game: Game) -> int:
    max_green = max([draw.green or 0 for draw in game.draws])
    max_red = max([draw.red or 0 for draw in game.draws])
    max_blue = max([draw.blue or 0 for draw in game.draws])

    return max_green * max_red * max_blue


print("Part II Answer:", sum([compute_power(game) for game in games]))
