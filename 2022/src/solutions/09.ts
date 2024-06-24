import { readDayInput } from "../common/io";

type Point = {
  row: number;
  col: number;
};

type Position = {
  knots: Point[];
  visited: Point[];
};

enum Direction {
  UP = "U",
  DOWN = "D",
  LEFT = "L",
  RIGHT = "R",
}

function isAdjacent(head: Point, tail: Point) {
  return (
    Math.abs(head.row - tail.row) <= 1 && Math.abs(head.col - tail.col) <= 1
  );
}

function move(point: Point, direction: Direction) {
  switch (direction) {
    case Direction.UP:
      return {
        row: point.row - 1,
        col: point.col,
      } as Point;
    case Direction.DOWN:
      return {
        row: point.row + 1,
        col: point.col,
      } as Point;
    case Direction.LEFT:
      return {
        row: point.row,
        col: point.col - 1,
      } as Point;
    case Direction.RIGHT:
      return {
        row: point.row,
        col: point.col + 1,
      } as Point;
  }
}

function catchupTail(head: Point, tail: Point) {
  if (isAdjacent(head, tail)) return tail;

  if (head.row === tail.row) {
    return head.col < tail.col
      ? move(tail, Direction.LEFT)
      : move(tail, Direction.RIGHT);
  } else if (head.col === tail.col) {
    return head.row < tail.row
      ? move(tail, Direction.UP)
      : move(tail, Direction.DOWN);
  } else if (head.row < tail.row && head.col < tail.col) {
    return move(move(tail, Direction.UP), Direction.LEFT);
  } else if (head.row < tail.row && head.col > tail.col) {
    return move(move(tail, Direction.UP), Direction.RIGHT);
  } else if (head.row > tail.row && head.col < tail.col) {
    return move(move(tail, Direction.DOWN), Direction.LEFT);
  } else if (head.row > tail.row && head.col > tail.col) {
    return move(move(tail, Direction.DOWN), Direction.RIGHT);
  } else {
    throw new Error("Impossible case reached");
  }
}

function applyInstruction(position: Position, direction: Direction) {
  for (let i = 0; i < position.knots.length; i++) {
    if (i === 0) {
      position.knots[i] = move(position.knots[i], direction);
    }

    if (i < position.knots.length - 1) {
      position.knots[i + 1] = catchupTail(
        position.knots[i],
        position.knots[i + 1],
      );
    }
  }

  const newVisited = position.visited.find(
    (point) =>
      point.row === position.knots[position.knots.length - 1].row &&
      point.col === position.knots[position.knots.length - 1].col,
  )
    ? position.visited
    : [...position.visited, position.knots[position.knots.length - 1]];

  return {
    knots: position.knots,
    visited: newVisited,
  } as Position;
}

const instructions = readDayInput(9)
  .split("\n")
  .flatMap((line) => {
    const raw = line.split(" ");
    const distance = parseInt(raw[1]);
    const direction = <Direction>raw[0];

    return Array(distance)
      .fill(0)
      .map(() => direction);
  });

function solve(n: number) {
  const startingPosition = {
    knots: Array(n)
      .fill(0)
      .map((_) => ({ row: 0, col: 0 })),
    visited: [{ row: 0, col: 0 }],
  } as Position;

  return instructions.reduce(
    (position, direction) => applyInstruction(position, direction),
    startingPosition,
  ).visited.length;
}

console.log("Part I: ", solve(2));
console.log("Part II: ", solve(10));
