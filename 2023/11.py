with open("data/day11.txt", "r") as f:
    data = [list(x) for x in f.read().split("\n")]

galaxy_locations = [
    (row, column)
    for row in range(len(data))
    for column in range(len(data[row]))
    if data[row][column] == "#"
]

empty_rows = [
    row for row in range(len(data)) if row not in [g[0] for g in galaxy_locations]
]

empty_columns = [
    column
    for column in range(len(data[0]))
    if column not in [g[1] for g in galaxy_locations]
]


def compute_bastardized_manhattan_distance(
    g1: tuple[int, int],
    g2: tuple[int, int],
    empty_rows: list[int],
    empty_columns: list[int],
    offset: int,
) -> int:
    base = abs((g2[0] - g1[0])) + abs((g2[1] - g1[1]))

    for r in empty_rows:
        if (r > g1[0] and r < g2[0]) or (r > g2[0] and r < g1[0]):
            base += offset

    for c in empty_columns:
        if (c > g1[1] and c < g2[1]) or (c > g2[1] and c < g1[1]):
            base += offset

    return base


print(
    "Part I Solution:",
    sum(
        [
            compute_bastardized_manhattan_distance(g1, g2, empty_rows, empty_columns, 1)
            for g1 in galaxy_locations
            for g2 in galaxy_locations
            if g1 < g2
        ]
    ),
)

print(
    "Part II Solution:",
    sum(
        [
            compute_bastardized_manhattan_distance(
                g1, g2, empty_rows, empty_columns, 999_999
            )
            for g1 in galaxy_locations
            for g2 in galaxy_locations
            if g1 < g2
        ]
    ),
)
