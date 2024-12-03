defmodule Solution do
  def read do
    "data/2024/01.txt"
    |> File.read!()
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(fn x ->
      String.split(x, ~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end)
    |> transpose()
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def part_1(input) do
    input
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip_reduce(
      0,
      fn [a, b], acc -> acc + abs(a - b) end
    )
  end

  def part_2(input) do
    frequencies = input |> Enum.at(1) |> Enum.frequencies()

    input
    |> Enum.at(0)
    |> Enum.reduce(0, fn x, acc -> acc + x * Map.get(frequencies, x, 0) end)
  end

  def main do
    data = read()

    IO.puts(part_1(data))
    IO.puts(part_2(data))
  end
end

Solution.main()
