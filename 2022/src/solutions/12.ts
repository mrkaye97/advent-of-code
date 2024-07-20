import { Graph } from "../common/graph";
import { readDayInput } from "../common/io";

type Point = {
  isStart: boolean;
  isEnd: boolean;
  key: string;
  elevation: number;
  row: number;
  col: number;
};

function findNeighbors(grid: Point[][], point: Point) {
  const neighbors = [];
  if (point.row > 0) {
    neighbors.push(grid[point.row - 1][point.col]);
  }
  if (point.row < grid.length - 1) {
    neighbors.push(grid[point.row + 1][point.col]);
  }
  if (point.col > 0) {
    neighbors.push(grid[point.row][point.col - 1]);
  }
  if (point.col < grid[0].length - 1) {
    neighbors.push(grid[point.row][point.col + 1]);
  }
  return neighbors;
}

const grid: Point[][] = readDayInput(12)
  .split("\n")
  .map((line, row) =>
    line.split("").map((char, col) => {
      const isStart = char === "S";
      const isEnd = char === "E";
      const key = char === "S" ? "a" : char === "E" ? "z" : char;
      return {
        isStart,
        isEnd,
        key,
        elevation: key.charCodeAt(0),
        row,
        col,
      };
    }),
  );

function comparator(a: Point, b: Point) {
  if (a.col === b.col && a.row === b.row) return 0;
  return a.row === b.row ? a.col - b.col : a.row - b.row;
}

const graph = new Graph<Point>(comparator);

grid.forEach((row) => {
  row.forEach((point) => {
    const neighbors = findNeighbors(grid, point).filter(
      (neighbor) => Math.abs(neighbor.elevation - point.elevation) <= 1,
    );

    neighbors.forEach((neighbor) => {
      graph.addEdge(point, neighbor);
    });
  });
});

const startNode = grid.flat().find((point) => point.isStart);
const endNode = grid.flat().find((point) => point.isEnd);

if (!startNode || !endNode) {
  throw new Error("Start or end node not found");
}

try {
  const path = graph.shortestPath(startNode, endNode);
  console.log("Part I: ", path.length - 1);
} catch (e) {
  console.error(e);
}
