defmodule Instruction do
  defstruct [:direction, :magnitude]
end

defmodule Position do
  defstruct [:x, :y, :aim]
end

defmodule Day2 do
  def read do
    "data/02.txt"
    |> File.read!()
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(fn value ->
      value
      |> String.split(~r{\s}, trim: true)
    end)
    |> Enum.map(fn [direction, magnitude] ->
      %Instruction{direction: direction, magnitude: String.to_integer(magnitude)}
    end)
  end

  def positionValue(position) do
    position.x * position.y
  end

  def part1(input) do
    start = %Position{x: 0, y: 0, aim: 0}

    input
    |> Enum.reduce(start, fn instruction, acc ->
      case instruction.direction do
        "forward" -> %Position{x: acc.x + instruction.magnitude, y: acc.y, aim: acc.aim}
        "down" -> %Position{x: acc.x, y: acc.y + instruction.magnitude, aim: acc.aim}
        "up" -> %Position{x: acc.x, y: acc.y - instruction.magnitude, aim: acc.aim}
        _ -> acc
      end
    end)
    |> positionValue()
    |> IO.inspect()
  end

  def part2(input) do
    start = %Position{x: 0, y: 0, aim: 0}

    input
    |> Enum.reduce(start, fn instruction, acc ->
      case instruction.direction do
        "forward" ->
          %Position{
            x: acc.x + instruction.magnitude,
            y: acc.y + acc.aim * instruction.magnitude,
            aim: acc.aim
          }

        "down" ->
          %Position{x: acc.x, y: acc.y, aim: acc.aim + instruction.magnitude}

        "up" ->
          %Position{x: acc.x, y: acc.y, aim: acc.aim - instruction.magnitude}

        _ ->
          acc
      end
    end)
    |> positionValue()
    |> IO.inspect()
  end

  def main do
    data = read()

    part1(data)
    part2(data)
  end
end

Day2.main()
