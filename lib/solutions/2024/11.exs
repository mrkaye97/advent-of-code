defmodule Solution do
  import Common.Output
  use Memoize

  defp split_number_in_half(number) do
    stringified = Integer.to_string(number)

    midpoint = div(String.length(stringified), 2)
    {left, right} = String.split_at(stringified, midpoint)

    [String.to_integer(left), String.to_integer(right)]
  end

  defp apply_rule(number) do
    cond do
      number == 0 -> [1]
      rem(length(Integer.digits(number)), 2) == 0 -> split_number_in_half(number)
      true -> [number * 2024]
    end
  end

  defp solve(occurrences, n) do
    Enum.reduce(1..n, occurrences, fn _, acc ->
      acc
      |> Enum.flat_map(fn {value, count} ->
        new = apply_rule(value)

        if Enum.count(new) == 1 do
          [{Enum.at(new, 0), count}]
        else
          new
          |> Enum.map(fn new_value ->
            {new_value, count}
          end)
        end
      end)
      |> Enum.reduce(%{}, fn {value, count}, acc ->
        Map.update(acc, value, count, &(&1 + count))
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  defp part_1(input) do
    solve(input, 25)
  end

  defp part_2(input) do
    solve(input, 75)
  end

  def main do
    data =
      "data/2024/11.txt"
      |> File.read!()
      |> String.split(" ")
      |> Enum.map(&{String.to_integer(&1), 1})
      |> Map.new()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
