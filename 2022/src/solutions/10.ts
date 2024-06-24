import { readDayInput } from "../common/io";

enum Operation {
  Noop = "noop",
  AddX = "addx",
}

type NoopInstruction = {
  operation: Operation.Noop;
  value: null;
  cycles: number;
};

type AddXInstruction = {
  operation: Operation.AddX;
  value: number;
  cycles: number;
};

type State = {
  cycle: number;
  value: number;
};

type Instruction = NoopInstruction | AddXInstruction;

function mapReduce<T, U>(
  arr: T[],
  callback: (accumulator: U, currentValue: T, index: number, array: T[]) => U,
  initialValue: U,
): U[] {
  const result: U[] = [];
  let accumulator = initialValue;

  for (let i = 0; i < arr.length; i++) {
    accumulator = callback(accumulator, arr[i], i, arr);
    result.push(accumulator);
  }

  return result;
}

const data = readDayInput(10)
  .split("\n")
  .map((line) => {
    if (line.startsWith("noop")) {
      return {
        operation: Operation.Noop,
        value: null,
        cycles: 1,
      } as Instruction;
    }

    const [_, value] = line.split(" ");
    return {
      operation: Operation.AddX,
      value: parseInt(value),
      cycles: 2,
    } as Instruction;
  });

const result = mapReduce(
  data,
  (acc: State, instruction: Instruction) => {
    if (instruction.operation === Operation.Noop) {
      return {
        cycle: acc.cycle + 1,
        value: acc.value,
      };
    }

    return {
      cycle: acc.cycle + 2,
      value: acc.value + (instruction as AddXInstruction).value,
    };
  },
  {
    cycle: 0,
    value: 1,
  },
);

function findValueByCycle(state: State[], cycle: number) {
  const ix = state.findIndex((c) => c.cycle >= cycle);

  if (ix < 0) {
    throw new Error("Cycle not found");
  }

  return {
    cycle: cycle,
    value: state[ix - 1].value,
  };
}

function computeSignalStrength(cycle: State) {
  return cycle.cycle * cycle.value;
}

const cycles = [20, 60, 100, 140, 180, 220];

console.log(
  "Part I: ",
  cycles
    .map((cycle) => findValueByCycle(result, cycle))
    .map(computeSignalStrength)
    .reduce((acc, val) => acc + val, 0),
);

const totalCycles = Math.max(...result.map((r) => r.cycle));
const firstCycleCompletion = Math.min(...result.map((r) => r.cycle));

const image = Array(totalCycles)
  .fill(0)
  .map((_, ix) => {
    const currentCycle = ix + 1;
    const spritePosition =
      currentCycle <= firstCycleCompletion
        ? 1
        : findValueByCycle(result, currentCycle).value;
    const isLit =
      ix % 40 >= spritePosition - 1 && ix % 40 <= spritePosition + 1;

    return isLit ? "#" : ".";
  });

const size = 40;
const groups: string[][] = image.reduce((acc: string[][], _, index) => {
  if (index % size === 0) {
    acc.push(image.slice(index, index + size));
  }
  return acc;
}, []);

console.log("Part II: \n", groups.map((g) => g.join("")).join("\n"));
