defmodule Day1 do
  def read do
    "data/01.txt"
    |> File.read!()
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      index > 0 and Enum.at(input, index - 1) < value
    end)
    |> Enum.count(& &1)
    |> IO.inspect()
  end

  def part2(input) do
    summed =
      input
      |> Enum.with_index()
      |> Enum.map(fn {value, index} ->
        if index < 2 do
          -999
        else
          Enum.at(input, index - 2) + Enum.at(input, index - 1) + value
        end
      end)
      |> Enum.filter(&(&1 != -999))

    summed
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      index > 0 and value > Enum.at(summed, index - 1)
    end)
    |> Enum.count(& &1)
    |> IO.inspect()
  end

  def main do
    data = read()

    part1(data)
    part2(data)
  end
end

Day1.main()
