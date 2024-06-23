from copy import deepcopy

with open("data/day14.txt", "r") as f:
    data = f.read().split("\n")

columns = []

for column in range(len(data[0])):
    columns += [[data[row][column] for row in range(len(data))]]

def adjust_column_north(col: list[str]):
    for position in range(1, len(col)):
        prev = deepcopy(position) - 1
        while prev >= 0 and col[prev + 1] == "O" and col[prev] == ".":
            curr = prev + 1
            col[curr - 1] = "O"
            col[curr] = "."

            prev -= 1

    return col

def determine_load(grid: list[list[str]]) -> int:
    total = 0
    for column in range(len(grid)):
        for row in range(len(grid[column])):
            if grid[column][row] == "O":
                total += (len(grid) - row)
                print(row, column, total)

    return total


print(columns[7])
print(adjust_column_north(columns[7]))
new = [adjust_column_north(c) for c in columns]


print(new)

print(determine_load(new))