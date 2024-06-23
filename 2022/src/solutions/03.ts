import { unique } from "../common/array";
import { readDayInput } from "../common/io";

function computeItemPriority(item: string) {
  const lowercaseLetters = String.fromCharCode(
    ...[...Array("z".charCodeAt(0) - "a".charCodeAt(0) + 1).keys()].map(
      (i) => i + "a".charCodeAt(0),
    ),
  );
  const uppercaseLetters = String.fromCharCode(
    ...[...Array("Z".charCodeAt(0) - "A".charCodeAt(0) + 1).keys()].map(
      (i) => i + "A".charCodeAt(0),
    ),
  );
  const letters = lowercaseLetters + uppercaseLetters;

  return letters.indexOf(item) + 1;
}

function partitionRucksack(items: string[]) {
  const num = items.length;
  const partition = Math.floor(num / 2);

  return [items.slice(0, partition), items.slice(partition)];
}

function intersection<Type>(left: Type[], right: Type[]): Type[] {
  const intersect = left.filter((value) => right.includes(value));
  return unique(intersect);
}

const data = readDayInput(3)
  .split("\n")
  .map((line) => line.split(""));

const partitions = data.map(partitionRucksack);

console.log(
  "Part I: ",
  partitions
    .flatMap((partition) => intersection(partition[0], partition[1]))
    .map(computeItemPriority)
    .reduce((acc, curr) => acc + curr, 0),
);

const size = 3;
const groups: string[][][] = data.reduce((acc: string[][][], _, index) => {
  if (index % size === 0) {
    acc.push(data.slice(index, index + size));
  }
  return acc;
}, []);

console.log(
  "Part II: ",
  groups
    .flatMap((g) => {
      const [x, y, z] = g;

      return intersection(intersection(x, y), z);
    })
    .map(computeItemPriority)
    .reduce((acc, curr) => acc + curr, 0),
);
