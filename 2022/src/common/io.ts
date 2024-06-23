import { readFileSync } from "fs";

export function readDayInput(day: number): string {
  const dayString = day.toString().padStart(2, "0");
  return readFileSync(`data/${dayString}.txt`, "utf8");
}
