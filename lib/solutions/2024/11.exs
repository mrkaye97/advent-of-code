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

  defp blink(line) do
    line
    |> Enum.map(&apply_rule/1)
    |> List.flatten()
  end

  defp solve(input, n) do
    Enum.reduce_while(1..n, input, fn ix, acc ->
      IO.inspect(ix)
      {:cont, blink(acc)}
    end)
    |> Enum.count()
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
      |> Enum.map(&String.to_integer/1)

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
