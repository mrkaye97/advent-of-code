from numpy import diff

with open("data/day9.txt", "r") as f:
    data = f.read().split("\n")


histories = [[int(x) for x in d.split(" ")] for d in data]


def create_stack(history: list[int]) -> list[list[int]]:
    stack = []
    stack.append(history)

    while not all([x == 0 for x in history]):
        history = list(diff(history))
        stack.append(history)

    return stack


def unwind_stack(stack: list[int], is_left: bool) -> int:
    curr = 0
    stack.pop()

    while stack:
        line = stack.pop()
        curr = line[0] - curr if is_left else curr + line[-1]

    return curr


def determine_value(history: list[int], is_left: bool) -> int:
    return unwind_stack(create_stack(history=history), is_left=is_left)


print("Part I Solution:", sum(map(lambda x: determine_value(x, False), histories)))
print("Part II Solution:", sum(map(lambda x: determine_value(x, True), histories)))
