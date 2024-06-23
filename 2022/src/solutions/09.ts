import { readDayInput } from "../common/io";

type Point = {
  row: number;
  col: number;
};

type Position = {
  head: Point;
  tail: Point;
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

function catchupTail(head: Point, tail: Point, directionMoved: Direction) {
  const adjacent = isAdjacent(head, tail);

  if (adjacent) return tail;

  switch (directionMoved) {
    case Direction.UP:
      if (head.col < tail.col) {
        return move(move(tail, Direction.LEFT), Direction.UP);
      } else if (head.col > tail.col) {
        return move(move(tail, Direction.RIGHT), Direction.UP);
      } else {
        return move(tail, Direction.UP);
      }
    case Direction.DOWN:
      if (head.col < tail.col) {
        return move(move(tail, Direction.LEFT), Direction.DOWN);
      } else if (head.col > tail.col) {
        return move(move(tail, Direction.RIGHT), Direction.DOWN);
      } else {
        return move(tail, Direction.DOWN);
      }
    case Direction.LEFT:
      if (head.row < tail.row) {
        return move(move(tail, Direction.UP), Direction.LEFT);
      } else if (head.row > tail.row) {
        return move(move(tail, Direction.DOWN), Direction.LEFT);
      } else {
        return move(tail, Direction.LEFT);
      }
    case Direction.RIGHT:
      if (head.row < tail.row) {
        return move(move(tail, Direction.UP), Direction.RIGHT);
      } else if (head.row > tail.row) {
        return move(move(tail, Direction.DOWN), Direction.RIGHT);
      } else {
        return move(tail, Direction.RIGHT);
      }
  }
}

function applyInstruction(position: Position, direction: Direction) {
  const newHead = move(position.head, direction);
  const newTail = catchupTail(newHead, position.tail, direction);
  const newVisited = position.visited.find(
    (point) => point.row === newTail.row && point.col === newTail.col,
  )
    ? position.visited
    : [...position.visited, newTail];

  return {
    head: newHead,
    tail: newTail,
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

const startingPosition = {
  head: { row: 0, col: 0 },
  tail: { row: 0, col: 0 },
  visited: [{ row: 0, col: 0 }],
} as Position;

console.log(
  "Part I: ",
  instructions.reduce(
    (position, direction) => applyInstruction(position, direction),
    startingPosition,
  ).visited.length,
);
