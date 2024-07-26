defmodule State do
  defstruct [:gamma, :epsilon]
end

defmodule Day3 do
  def read do
    "data/03.txt"
    |> File.read!()
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(fn value ->
      value
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def part1(input) do
    input
    |> transpose()
    |> Enum.map(&Enum.frequencies(&1))
    |> Enum.map(fn %{0 => a, 1 => b} ->
      gamma = if a > b, do: 0, else: 1
      epsilon = if a > b, do: 1, else: 0

      %State{gamma: gamma, epsilon: epsilon}
    end)
    |> Enum.reduce(%State{gamma: "", epsilon: ""}, fn state, acc ->
      %State{
        gamma: acc.gamma <> Integer.to_string(state.gamma),
        epsilon: acc.epsilon <> Integer.to_string(state.epsilon)
      }
    end)
    |> then(fn %{gamma: a, epsilon: b} ->
      elem(Integer.parse(a, 2), 0) * elem(Integer.parse(b, 2), 0)
    end)
    |> IO.inspect()
  end

  def part2(input) do
    input
    |> IO.inspect()
  end

  def main do
    data = read()

    part1(data)
  end
end

Day3.main()
