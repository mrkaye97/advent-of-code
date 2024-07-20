import { equal, zip } from "../common/array";
import { readDayInput } from "../common/io";

interface NestedArray<T> extends Array<T | NestedArray<T>> {}

type NestedNumberArray = NestedArray<number>;
type NestedNumbers = number | NestedNumberArray;

type Packet = {
  lhs: NestedNumbers;
  rhs: NestedNumbers;
};

const data: Packet[] = readDayInput(13)
  .split("\n\n")
  .map((pair) => {
    const [lhs, rhs] = pair.split("\n");

    return {
      lhs: eval(lhs),
      rhs: eval(rhs),
    };
  });

type ComparisonResult = "correct" | "incorrect" | "inconclusive";

function compare(lhs: NestedNumbers, rhs: NestedNumbers): ComparisonResult {
  const lhsIsInt = typeof lhs === "number";
  const rhsIsInt = typeof rhs === "number";

  if (!lhs && rhs) {
    return "correct";
  } else if (lhs && !rhs) {
    return "incorrect";
  } else if (lhsIsInt && rhsIsInt) {
    if (lhs < rhs) {
      return "correct";
    } else if (lhs > rhs) {
      return "incorrect";
    } else {
      return "inconclusive";
    }
  } else if (lhsIsInt) {
    return compare([lhs], rhs);
  } else if (rhsIsInt) {
    return compare(lhs, [rhs]);
  } else {
    const pairwiseComparisons = zip(lhs, rhs).map((pair) => {
      return compare(pair[0], pair[1]);
    });

    return (
      pairwiseComparisons.find((result) => result !== "inconclusive") ||
      "inconclusive"
    );
  }
}

console.log(
  "Part I:",
  data
    .map((input, ix) =>
      compare(input.lhs, input.rhs) === "correct" ? ix + 1 : 0,
    )
    .reduce((acc, val) => acc + val, 0),
);

const partTwoData: NestedNumbers[] = readDayInput(13)
  .replaceAll("\n\n", "\n")
  .concat("\n[[6]]\n[[2]]")
  .split("\n")
  .map((line) => eval(line));
const sorted = partTwoData
  .sort((a, b) => (compare(a, b) === "correct" ? -1 : 1))
  .map((packet) => JSON.stringify(packet));

const firstDividerPacketIndex =
  sorted.findIndex((packet) => packet === "[[2]]") + 1;
const secondDividerPacketIndex =
  sorted.findIndex((packet) => packet === "[[6]]") + 1;

console.log("Part II:", firstDividerPacketIndex * secondDividerPacketIndex);
