defmodule Day1 do
  def read do
    "data/01.txt"
    |> File.read!()
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(fn x ->
      String.split(x, ~r/\s+/)
      |> Enum.map(fn x -> String.to_integer(x) end)
    end)
    |> transpose()
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def part1(input) do
    input
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part2(input) do
    first = Enum.at(input, 0)
    second = input |> Enum.at(1) |> Enum.frequencies()

    first
    |> Enum.map(fn x -> x * Map.get(second, x, 0) end)
    |> Enum.sum()
    |> IO.puts()
  end

  def main do
    data = read()

    part1(data)
    part2(data)
  end
end

Day1.main()
