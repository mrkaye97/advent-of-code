from copy import deepcopy

with open("data/day12.txt", "r") as f:
    data = [(list(x.split(" ")[0]), [int(y) for y in x.split(" ")[1] if y != ","]) for x in f.read().split("\n")]

data = [
    ([x for x in "".join(data[row][0]).split(".") if x],
    data[row][1])
    for row in range(len(data))
]

def any_unknowns_present(row: list[list[str]]) -> bool:
    for grp in row:
        for item in grp:
            if item == "?":
                return True

    return False

def is_valid_line(row: list[list[str]], groups: list[int]) -> bool:
    print("Checking validity", row)
    return [len(x) for x in row] == groups

def compute_combinations(row: list[list[str]], groups: list[int]) -> int:
    if not any_unknowns_present(row) and is_valid_line(row, groups):
        return 1

    if not any_unknowns_present(row) and not is_valid_line(row, groups):
        return 0

    ## At this point, there's a ? somewhere
    ## find it and recurse
    total = 0
    for row_ix in range(len(row)):
        for ix in range(len(row[row_ix])):
            if row[row_ix][ix] == "?":
                new_substr = row[row_ix][:ix] + "#" + row[row_ix][ix + 1:]
                new_row = row[:row_ix] + [new_substr] + row[row_ix + 1 :]
                print("Loop", row, row_ix, ix, new_substr, new_row)
                total += compute_combinations(new_row, groups)

    return total


print(compute_combinations(data[0][0], data[0][1]))