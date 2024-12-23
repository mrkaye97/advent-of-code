defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    rules =
      input
      |> Enum.filter(fn x -> String.contains?(x, "|") end)
      |> Enum.map(fn x -> String.split(x, "|") |> Enum.map(&String.to_integer/1) end)

    orders =
      input
      |> Enum.reject(fn x -> String.contains?(x, "|") end)
      |> Enum.map(fn x -> x |> String.split(",") |> Enum.map(&String.to_integer/1) end)

    %{
      :rules => rules,
      :orders => orders
    }
  end

  defp part_1(input) do
    input[:orders]
    |> Enum.reduce(0, fn x, acc ->
      sorted = Enum.sort(x, &sorter(input[:rules], &1, &2))

      if sorted == x, do: acc + Enum.at(x, div(length(x), 2)), else: acc
    end)
  end

  defp part_2(input) do
    input[:orders]
    |> Enum.reduce(0, fn x, acc ->
      sorted = Enum.sort(x, &sorter(input[:rules], &1, &2))

      if sorted != x, do: acc + Enum.at(sorted, div(length(sorted), 2)), else: acc
    end)
  end

  def sorter(rules, l, r) do
    [smaller, _] =
      rules
      |> Enum.filter(fn [a, b] ->
        (l == a and r == b) or (l == b and r == a)
      end)
      |> Enum.at(0, [nil, nil])

    cond do
      smaller == nil -> true
      smaller == l -> true
      smaller == r -> false
    end
  end

  def main do
    data = read_input(2024, 05) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
