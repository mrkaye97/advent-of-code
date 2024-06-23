import networkx as nx
import matplotlib.pyplot as plt

with open("data/day10.txt", "r") as f:
    data = f.read().split("\n")

data = [list(d) for d in data]

bends = {
    "|": ("n", "s"),
    "-": ("e", "w"),
    "L": ("n", "e"),
    "J": ("n", "w"),
    "7": ("s", "w"),
    "F": ("s", "e"),
    ".": (None, None),
    "S": (None, None),
}

g = nx.Graph()


def generate_node_name(row, column):
    return f"{row}-{column}"


def find_next_index(x, row, column, data) -> tuple[int, int]:
    match x:
        case "n":
            return (
                row - 1,
                column
                if row > 0 and data[row - 1][column] in ["7", "|", "F", "S"]
                else None,
                None,
            )
        case "s":
            return (
                row + 1,
                column
                if row < len(data) - 1 and data[row + 1][column] in ["L", "|", "J", "S"]
                else None,
                None,
            )
        case "e":
            return (
                row,
                column + 1
                if column < len(data[row]) - 1
                and data[row][column + 1] in ["7", "-", "J", "S"]
                else None,
                None,
            )
        case "w":
            return (
                row,
                column - 1
                if column > 0 and data[row][column - 1] in ["L", "-", "F", "S"]
                else None,
            )
        case _:
            return None, None


def find_next_indices(data, row, column) -> tuple[int, int]:
    b1, b2 = bends[data[row][column]]

    return [find_next_index(x, row=row, column=column, data=data) for x in [b1, b2]]


for row in range(len(data)):
    for column in range(len(data[row])):
        g.add_node(generate_node_name(row, column))

for row in range(len(data)):
    for column in range(len(data[row])):
        next_indices = find_next_indices(data=data, row=row, column=column)
        for ix in next_indices:
            if ix[0] is not None and ix[1] is not None:
                l = generate_node_name(row, column)
                r = generate_node_name(ix[0], ix[1])

                g.add_edge(l, r)


def find_start_node(data) -> tuple[int, int]:
    for row in range(len(data)):
        for column in range(len(data[row])):
            if data[row][column] == "S":
                return generate_node_name(row, column)


s = find_start_node(data)

cycle = nx.find_cycle(g, s)

print("Part I Solution:", len(cycle) // 2)

for row in range(len(data)):
    data[row] = ["."] + data[row] + ["."]

data = [["."] * len(data[0])] + data + [["."] * len(data[0])]

for row in range(len(data)):
    data[row] = ["."] + data[row] + ["."]

data = [["."] * len(data[0])] + data + [["."] * len(data[0])]

for row in range(len(data)):
    x = [[data[row][ix], "."] for ix in range(len(data[row]))]
    data[row] = [item for sublist in x for item in sublist]


def get_neighbors(
    row: int, column: int, data: list[list[str]], walls: set[tuple[int, int]]
) -> list[tuple[int, int]]:
    neighbors = []

    if row > 0 and generate_node_name(row - 1, column) not in walls:
        neighbors.append((row - 1, column))

    if row < len(data) - 1 and generate_node_name(row + 1, column) not in walls:
        neighbors.append((row + 1, column))

    if column > 0 and generate_node_name(row, column - 1) not in walls:
        neighbors.append((row, column - 1))

    if column < len(data[row]) - 1 and generate_node_name(row, column + 1) not in walls:
        neighbors.append((row, column + 1))

    return neighbors


def dfs(
    start: tuple[int, int],
    end: tuple[int, int],
    data: list[list[str]],
    walls: set[tuple[int, int]],
) -> bool:
    if generate_node_name(start[0], start[1]) in walls:
        return True

    visited = {start}
    stack = [start]

    while stack:
        curr = stack.pop()

        if curr == end:
            return True

        neighbors = get_neighbors(curr[0], curr[1], data, walls)
        for neighbor in neighbors:
            if neighbor not in visited:
                visited.add(neighbor)
                stack.append(neighbor)

    return False


walls = set()
for edge in cycle:
    walls.add(edge[0])
    walls.add(edge[1])

walls = {
    generate_node_name(int(n.split("-")[0]) + 2, int(n.split("-")[1]) + 2)
    for n in walls
}


results = [
    (row, column)
    for row in range(len(data))
    for column in range(len(data[row]))
    if not dfs((row, column), (1, 1), data, walls)
]

print(len(results))

# count = 0
# for row in range(len(data)):
#     column = 0
#     is_open = False
#     first_node = min([ix for ix, _ in enumerate(data[row]) if generate_node_name(row, ix) in nodes_in_cycle] or [999])
#     last_node = max([ix for ix, _ in enumerate(data[row]) if generate_node_name(row, ix) in nodes_in_cycle] or [-1])

#     print("First:", first_node, "Last:", last_node)
#     print(len(data[row]))
#     while column < len(data[row]):
#         is_in_cycle = generate_node_name(row, column) in nodes_in_cycle
#         print(column, is_open, is_in_cycle, first_node, last_node)

#         ## If the accumulator is open and the current thing is not part of the cycle
#         ## then we should add one to the count
#         if is_open and not is_in_cycle and column > first_node and column < last_node:
#             count += 1

#         ## If it's a wall and it's part of the cycle, then toggle open
#         if is_in_cycle:
#             is_open = not is_open

#         column += 1
#     print(row, count)


# print(count)
