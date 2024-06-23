import { readDayInput } from "../common/io";

type Range = {
  start: number;
  end: number;
};

type RangePair = [Range, Range];

const data = readDayInput(4)
  .split("\n")
  .map((line) =>
    line.split(",").map((e) => {
      const rg = e.split("-");

      return {
        start: parseInt(rg[0]),
        end: parseInt(rg[1]),
      } as Range;
    }),
  )
  .map((e) => [e[0], e[1]] as RangePair);

function between(x: number, lower: number, upper: number) {
  return x >= lower && x <= upper;
}

function testContainment(pair: RangePair) {
  const [a, b] = pair;

  return (
    (a.start <= b.start && a.end >= b.end) ||
    (b.start <= a.start && b.end >= a.end)
  );
}

function testOverlap(pair: RangePair) {
  const [a, b] = pair;

  return (
    between(a.start, b.start, b.end) ||
    between(a.end, b.start, b.end) ||
    between(b.start, a.start, a.end) ||
    between(b.end, a.start, a.end)
  );
}

console.log("Part I: ", data.filter(testContainment).length);
console.log("Part II: ", data.filter(testOverlap).length);
