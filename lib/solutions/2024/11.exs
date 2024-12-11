defmodule Solution do
  import Common.Input
  import Common.Output

  defp split_number_in_half(number) do
    stringified = Integer.to_string(number)

    midpoint = div(String.length(stringified), 2)
    {left, right} = String.split_at(stringified, midpoint)

    [String.to_integer(left), String.to_integer(right)]
  end

  defp apply_rule(number) do
    cond do
      number == 0 -> 1
      rem(length(Integer.digits(number)), 2) == 0 -> split_number_in_half(number)
      true -> number * 2024
    end
  end

  defp solve(boxed_number, n) do
    Enum.reduce(1..n, boxed_number, fn _, acc ->
      List.flatten(Enum.map(acc, &apply_rule/1))
    end)
    |> Enum.count()
  end

  defp part_1(input) do
    input
    |> Enum.map(fn number ->
      solve([number], 25)
    end)
    |> Enum.sum()
  end

  defp part_2(input) do
    input
    |> Enum.map(fn number ->
      solve([number], 75)
    end)
    |> Enum.sum()
  end

  def main do
    data =
      "data/2024/11.txt"
      |> File.read!()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
