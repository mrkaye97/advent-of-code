defmodule Solution do
  import Common.Enum
  import Common.Input
  import Common.Output

  def read do
    read_input(2024, 1)
    |> Enum.map(fn x ->
      String.split(x, ~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end)
    |> transpose()
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

    pretty_print(1, &part_1/1, data)
    pretty_print(2, &part_2/1, data)
  end
end

Solution.main()
