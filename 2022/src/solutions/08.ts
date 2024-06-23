import { readDayInput } from "../common/io";

const data = readDayInput(8)
  .split("\n")
  .map((line) => line.split("").map((char) => parseInt(char)));
const dimensions = [data.length, data[0].length];

const numOuterTrees = (dimensions[0] - 1) * 4;

function range(start: number, stop: number) {
  return Array.from(
    { length: stop - (start + 1) + 1 },
    (_, index) => start + index,
  );
}

function isVisible(grid: number[][], row: number, col: number): boolean {
  if (
    row === 0 ||
    row === grid.length - 1 ||
    col === 0 ||
    col === grid[0].length - 1
  ) {
    return true;
  }

  const northBarrier = range(0, row);
  const southBarrier = range(row + 1, grid.length);
  const westBarrier = range(0, col);
  const eastBarrier = range(col + 1, grid[0].length);

  const isVisibleFromNorth = northBarrier
    .map((r) => grid[r][col] < grid[row][col])
    .every(Boolean);
  const isVisibleFromSouth = southBarrier
    .map((r) => grid[r][col] < grid[row][col])
    .every(Boolean);
  const isVisibleFromWest = westBarrier
    .map((c) => grid[row][c] < grid[row][col])
    .every(Boolean);
  const isVisibleFromEast = eastBarrier
    .map((c) => grid[row][c] < grid[row][col])
    .every(Boolean);

  return (
    isVisibleFromNorth ||
    isVisibleFromSouth ||
    isVisibleFromWest ||
    isVisibleFromEast
  );
}

function viewingDistance(grid: number[][], row: number, col: number): number {
  if (
    row === 0 ||
    row === grid.length - 1 ||
    col === 0 ||
    col === grid[0].length - 1
  ) {
    return 0;
  }

  const northCandidates = range(0, row);
  const southCandidates = range(row + 1, grid.length);
  const westCandidates = range(0, col);
  const eastCandidates = range(col + 1, grid[0].length);

  const northBarrier =
    northCandidates.find((cnd) => grid[row][col] <= grid[cnd][col]) || 0;
  const southBarrier =
    southCandidates.find((cnd) => grid[row][col] <= grid[cnd][col]) ||
    grid.length - 1;
  const eastBarrier =
    eastCandidates.find((cnd) => grid[row][col] <= grid[row][cnd]) ||
    grid.length - 1;
  const westBarrier =
    westCandidates.find((cnd) => grid[row][col] <= grid[row][cnd]) || 0;

  return (
    (row - northBarrier) *
    (southBarrier - row) *
    (eastBarrier - col) *
    (col - westBarrier)
  );
}

console.log(
  "Part I: ",
  data
    .flatMap((r, row) => r.map((c, col) => isVisible(data, row, col)))
    .filter(Boolean).length,
);

console.log(
  "Part II: ",
  Math.max(
    ...data.flatMap((r, row) =>
      r.map((c, col) => viewingDistance(data, row, col)),
    ),
  ),
);
