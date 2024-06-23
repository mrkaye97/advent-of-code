import { readDayInput } from "../common/io";

enum Move {
  Rock,
  Paper,
  Scissors,
}

enum Outcome {
  Win,
  Draw,
  Loss,
}

const moveValue = {
  [Move.Rock]: 1,
  [Move.Paper]: 2,
  [Move.Scissors]: 3,
};

function findWinningMove(opponent: Move) {
  switch (opponent) {
    case Move.Rock:
      return Move.Paper;
    case Move.Paper:
      return Move.Scissors;
    case Move.Scissors:
      return Move.Rock;
  }
}

function findNecessaryMove(opponent: Move, outcome: Outcome) {
  if (outcome === Outcome.Draw) return opponent;
  if (outcome === Outcome.Win) return findWinningMove(opponent);

  return findWinningMove(findWinningMove(opponent));
}

function codeToMoveWithUncertainty(code: string) {
  switch (code) {
    case "A":
    case "X":
      return Move.Rock;
    case "B":
    case "Y":
      return Move.Paper;
    case "C":
    case "Z":
      return Move.Scissors;
    default:
      throw new Error(`Invalid move code: ${code}`);
  }
}

function computeWinValue(round: Round) {
  if (round.player === findWinningMove(round.opponent)) {
    return 6;
  } else if (round.player === round.opponent) {
    return 3;
  } else {
    return 0;
  }
}

function computeScore(round: RoundWithPlayer) {
  return moveValue[round.player] + computeWinValue(round);
}

type RoundWithPlayer = {
  player: Move;
  opponent: Move;
  outcome?: never;
};

type RoundWithOutcome = {
  player?: never;
  opponent: Move;
  outcome: Outcome;
};

type Round = RoundWithPlayer | RoundWithOutcome;

const partOneData = readDayInput(2)
  .split("\n")
  .map((line) => {
    const [opponentCode, playerCode] = line.split(" ");
    return {
      player: codeToMoveWithUncertainty(playerCode),
      opponent: codeToMoveWithUncertainty(opponentCode),
    } as RoundWithPlayer;
  });

console.log(
  "Part I: ",
  partOneData.map(computeScore).reduce((acc, score) => acc + score, 0),
);

const partTwoData = readDayInput(2)
  .split("\n")
  .map((line) => {
    const [opponentCode, outcome] = line.split(" ");
    return {
      opponent: codeToMoveWithUncertainty(opponentCode),
      outcome:
        outcome === "X"
          ? Outcome.Loss
          : outcome === "Y"
            ? Outcome.Draw
            : Outcome.Win,
    } as RoundWithOutcome;
  })
  .map((round) => ({
    player: findNecessaryMove(round.opponent, round.outcome),
    opponent: round.opponent,
  }));

console.log(
  "Part I: ",
  partTwoData.map(computeScore).reduce((acc, score) => acc + score, 0),
);
