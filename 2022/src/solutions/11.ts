import { readDayInput } from "../common/io";

type MonkeyBusiness = {
  id: number;
  worryLevels: number[];
  operation: (old: number) => number;
  testDivisor: number;
  decideDestinationMonkey: (x: number) => number;
  processed: number;
};

function add(x: number, y: number) {
  return x + y;
}

function multiply(x: number, y: number) {
  return x * y;
}

function parseOperation(raw: string) {
  const operator = raw.includes(" * ") ? multiply : add;
  const lhs = raw.split(" ")[0];
  const rhs = raw.split(" ")[2];

  if (lhs === "old" && rhs === "old") {
    return (old: number) => operator(old, old);
  } else if (lhs === "old") {
    const value = parseInt(rhs);
    return (old: number) => operator(old, value);
  } else if (rhs === "old") {
    const value = parseInt(lhs);
    return (old: number) => operator(value, old);
  } else {
    const value1 = parseInt(lhs);
    const value2 = parseInt(rhs);
    return () => operator(value1, value2);
  }
}

function parseInput(input: string, index: number) {
  const lines = input
    .split("\n")
    .map((line) => line.trim())
    .slice(1);

  const monkeyId = index;
  const worryLevels = lines[0]
    .replace("Starting items: ", "")
    .split(", ")
    .map((item) => parseInt(item));
  const operation = parseOperation(lines[1].replace("Operation: new = ", ""));
  const testDivisor = parseInt(lines[2].replace("Test: divisible by ", ""));
  const trueCase = parseInt(lines[3].replace("If true: throw to monkey ", ""));
  const falseCase = parseInt(
    lines[4].replace("If false: throw to monkey ", ""),
  );

  return {
    id: monkeyId,
    worryLevels,
    operation,
    decideDestinationMonkey: (x: number) =>
      x % testDivisor === 0 ? trueCase : falseCase,
    testDivisor: testDivisor,
    processed: 0,
  } as MonkeyBusiness;
}

function playGame(state: MonkeyBusiness[], shouldDivide: boolean) {
  const divisor = shouldDivide
    ? 3
    : state.map((m) => m.testDivisor).reduce((acc, val) => acc * val, 1);
  state.forEach((monkey) => {
    const worryLevels = monkey.worryLevels;
    worryLevels.map((level, ix) => {
      monkey.worryLevels[ix] = shouldDivide
        ? Math.floor(monkey.operation(level) / divisor)
        : monkey.operation(level) % divisor;
      const desinationMonkey = monkey.decideDestinationMonkey(
        monkey.worryLevels[ix],
      );
      state[desinationMonkey].worryLevels.push(monkey.worryLevels[ix]);
      monkey.worryLevels[ix] = -999;
      monkey.processed++;
    });
  });

  state.forEach((monkey) => {
    monkey.worryLevels = monkey.worryLevels.filter((level) => level !== -999);
  });

  return state;
}

// Part I
const state = readDayInput(11)
  .split("\n\n")
  .map(parseInput)
  .filter(Boolean) as MonkeyBusiness[];

Array(20)
  .fill(0)
  .forEach((_) => {
    playGame(state, true);
  });

console.log(
  "Part I: ",
  state
    .map((monkey) => monkey.processed)
    .sort((a, b) => b - a)
    .slice(0, 2)
    .reduce((acc, val) => acc * val, 1),
);

// Part II
const statePartII = readDayInput(11)
  .split("\n\n")
  .map(parseInput)
  .filter(Boolean) as MonkeyBusiness[];

Array(10_000)
  .fill(0)
  .forEach((_) => {
    playGame(statePartII, false);
  });

console.log(
  "Part II: ",
  statePartII
    .map((monkey) => monkey.processed)
    .sort((a, b) => b - a)
    .slice(0, 2)
    .reduce((acc, val) => acc * val, 1),
);
