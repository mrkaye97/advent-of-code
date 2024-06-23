import { unique } from "../common/array";
import { readDayInput } from "../common/io";

const data = readDayInput(6).split("");

function findMarker(chars: string[], n: number) {
  return (
    chars.findIndex((_, ix) => {
      if (ix < n - 1) return false;

      const values = data.slice(ix - (n - 1), ix + 1);

      return unique(values).length == values.length;
    }) + 1
  );
}

console.log("Part I: ", findMarker(data, 4));
console.log("Part II: ", findMarker(data, 14));
