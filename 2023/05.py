from itertools import groupby
from dataclasses import dataclass
from copy import deepcopy
import functools


@dataclass
class SeedMap:
    destination_range_start: int
    source_range_start: int
    range_length: int


def parse_input(d) -> dict[str, list[list[int]]]:
    seeds = [int(x.strip()) for x in d[0].split(": ")[1].split(" ")]

    result = [list(g) for k, g in groupby(d[1:], key=bool) if k]

    return {
        "seeds": seeds,
        "maps": {
            x[0][:-1]: [
                SeedMap(
                    destination_range_start=int(y.split(" ")[0]),
                    source_range_start=int(y.split(" ")[1]),
                    range_length=int(y.split(" ")[2]),
                )
                for y in x[1:]
            ]
            for x in result
        },
    }


def map_value(v: int, xs: list[SeedMap]) -> int:
    for m in xs:
        d = m.destination_range_start
        s = m.source_range_start
        l = m.range_length

        ## If the value is in the range established
        ## by the source start and range (i.e. end)
        if v >= s and v < s + l:
            ## then we want the corresponding
            return d + (v - s)

    return v


def determine_location(seed: int, maps: dict[str, list[SeedMap]]) -> int:
    value = deepcopy(seed)
    for m in maps.values():
        value = map_value(value, m)

    return value


def any_range_overlap(rng: tuple[int, int], mapping: SeedMap) -> bool:
    if rng[0] + rng[1] <= mapping.source_range_start:
        return False
    elif rng[0] >= (mapping.destination_range_start + mapping.range_length):
        return False
    else:
        return True


def determine_loc_for_range(
    rng: tuple[int, int], maps: dict[str, list[SeedMap]], depth: int
) -> int:
    if depth == 7:
        return rng[0]

    mapping: list[SeedMap] = list(maps.values())[depth]
    ## If the range has no overlap with any of the mapping ranges, use the identity map
    if not any([any_range_overlap(rng=rng, mapping=m) for m in mapping]) and depth != 7:
        return determine_loc_for_range(rng=rng, maps=maps, depth=depth + 1)

    for possibility in mapping:
        s = possibility.source_range_start
        d = possibility.destination_range_start
        l = possibility.range_length
        e = s + l

        ## If the current range is entirely contained
        ## within the "possibility" in the mapping
        if rng[0] >= s and rng[0] + rng[1] <= e:
            ## Base case -- if the depth is 6, we've reached the end (I think)
            ## And in this case, we need to check if the range is contained in one of the options
            ## and if it is, return the value
            if depth == 7:
                return rng[0]
            ## In this case, we haven't reached the last map yet,
            ## so we need to map the values from the current "level"
            ## to the next "level"
            ## This is the hard part, it seems
            else:
                new_range = rng[0] + (d - s), rng[1]
                return determine_loc_for_range(
                    rng=new_range, maps=maps, depth=depth + 1
                )

    ## By this point, all we're left with are
    ## ranges that are not contained in a single mapping range
    ## meaning they span multiple possibilities
    ## For these, we need to split them by the cutoffs assigned by
    ## the possibilities and recurse
    for possibility in mapping:
        s = possibility.source_range_start
        l = possibility.range_length
        e = s + l

        ## if the range starts inside of the possiblity range
        if rng[0] >= s and rng[0] < (s + l):
            ## we know that this range isn't contained in the possibility,
            ## so we need to split it
            lower = rng[0], e - rng[0]
            upper = e, rng[0] + rng[1] - e

            return min(
                determine_loc_for_range(rng=lower, maps=maps, depth=depth),
                determine_loc_for_range(rng=upper, maps=maps, depth=depth),
            )

        if rng[0] < s and rng[0] + rng[1] > s:
            lower = rng[0], s - rng[0]
            upper = s, (rng[0] + rng[1]) - s

            return min(
                determine_loc_for_range(rng=lower, maps=maps, depth=depth) or 100,
                determine_loc_for_range(rng=upper, maps=maps, depth=depth) or 100,
            )


if __name__ == "__main__":
    with open("data/day5.txt", "r") as f:
        data = f.read().split("\n")

    parsed = parse_input(data)

    curried = functools.partial(determine_location, maps=parsed["maps"])

    print("Part I Solution:", min(map(curried, parsed["seeds"])))

    seed_pairs = list(zip(*(iter(parsed["seeds"]),) * 2))

    print(
        "Part II Solution:",
        min(
            [
                determine_loc_for_range(s, maps=parsed["maps"], depth=0)
                for s in seed_pairs
            ]
        ),
    )
