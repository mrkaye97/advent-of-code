from math import lcm

with open("data/day8.txt", "r") as f:
    data = f.read().split("\n")

instructions = list(data[0].strip())

mapping = {
    x[0]: {
        "L": x[1].split(",")[0][1:].strip(),
        "R": x[1].split(",")[1][:-1].strip(),
    }
    for x in [y.split(" = ") for y in data[1:] if y]
}


def compute_steps_through_graph(current_position: str):
    steps = 0
    while current_position != "ZZZ":
        instruction = instructions[steps % len(instructions)]
        current_position = mapping[current_position][instruction]
        steps += 1

    return steps


print("Part I Solution:", compute_steps_through_graph(current_position="AAA"))


def compute_steps_through_graph_2(current_position: str):
    steps = 0
    while current_position[-1] != "Z":
        instruction = instructions[steps % len(instructions)]
        current_position = mapping[current_position][instruction]
        steps += 1

    return steps


starting_positions = [x for x in mapping.keys() if x[-1] == "A"]

print(
    "Part II Solution:",
    lcm(*[compute_steps_through_graph_2(x) for x in starting_positions]),
)
