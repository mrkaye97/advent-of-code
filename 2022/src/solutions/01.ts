import { readDayInput } from "../common/io";

const data = readDayInput(1);

const elfTotals = data.split("\n\n").map((elf) =>
  elf
    .split("\n")
    .map((x) => parseInt(x))
    .reduce((acc, curr) => acc + curr, 0),
);

console.log("Part I: ", Math.max(...elfTotals));
console.log(
  "Part II: ",
  elfTotals
    .sort((a, b) => b - a)
    .slice(0, 3)
    .reduce((acc, curr) => acc + curr, 0),
);
