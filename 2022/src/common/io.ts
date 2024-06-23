import { readFile } from "node:fs/promises";

export function readDayInput(day: number): string {
  const dayString = day.toString().padStart(2, "0");
  return readFile(`data/${dayString}.txt`, "utf8");
}
