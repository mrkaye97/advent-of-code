import { readDayInput } from "../common/io";
import { Stack } from "../common/stack";

type Instruction = {
  n: number;
  from: number;
  to: number;
};

function parseStartingPositions(input: string): Stack<string>[] {
  const foo = input
    ?.split("\n")
    .slice(0, -1)
    .map((x) => x.replaceAll("[", " ").replaceAll("]", " "));

  const maxLineLength = Math.max(...foo?.map((x) => x.length));

  const cratePositions = foo.map((x) =>
    x
      .padEnd(maxLineLength, " ")
      .split("")
      .filter((_, ix) => ix % 2 == 1)
      .filter((_, ix) => ix % 2 == 0),
  );

  const parsed = cratePositions[0].map((_, colIndex) =>
    cratePositions
      .map((row) => row[colIndex])
      .reverse()
      .filter((x) => x !== " "),
  );

  return parsed.map((x) => {
    const stack = new Stack<string>();
    x.forEach((y) => stack.push(y));
    return stack;
  });
}

function applyInstruction(
  positions: Stack<string>[],
  instruction: Instruction,
  useStack: boolean,
): Stack<string>[] {
  const { n, from, to } = instruction;
  const fromStack = positions[from];
  const toStack = positions[to];

  if (useStack) {
    var crates = new Stack<string>();

    for (let i = 0; i < n; i++) {
      const crate = fromStack.pop();
      if (crate) {
        crates.push(crate);
      }
    }

    for (let i = 0; i < n; i++) {
      const crate = crates.pop();
      if (crate) {
        toStack.push(crate);
      }
    }
  } else {
    for (let i = 0; i < n; i++) {
      const crate = fromStack.pop();
      if (crate) {
        toStack.push(crate);
      }
    }
  }

  return positions;
}

const data = readDayInput(5);
const [rawStartingPositions, rawInstructions] = data.split("\n\n");

const instructions = rawInstructions.split("\n").map((line) => {
  const [_, n, __, from, ___, to] = line.split(" ");
  return {
    n: parseInt(n),
    from: parseInt(from) - 1,
    to: parseInt(to) - 1,
  } as Instruction;
});

const startingPosition = parseStartingPositions(rawStartingPositions);

console.log(
  "Part I: ",
  instructions
    .reduce(
      (positions, instruction) =>
        applyInstruction(positions, instruction, false),
      startingPosition,
    )
    .map((x) => x.pop())
    .join(""),
);

const startingPosition2 = parseStartingPositions(rawStartingPositions);

console.log(
  "Part II: ",
  instructions
    .reduce(
      (positions, instruction) =>
        applyInstruction(positions, instruction, true),
      startingPosition2,
    )
    .map((x) => x.pop())
    .join(""),
);
