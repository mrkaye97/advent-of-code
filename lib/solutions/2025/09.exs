defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    input
    |> Enum.map(fn x -> String.split(x, ",") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn [x, y] -> {x, y} end)
  end

  defp part_1(input) do
    Enum.reduce(input, 0, fn {x1, y1}, acc ->
      Enum.reduce(input, acc, fn {x2, y2}, acc ->
        cond do
          x1 < x2 and y1 < y2 -> max((abs(x2 - x1) + 1) * (abs(y2 - y1) + 1), acc)
          true -> acc
        end
      end)
    end)
  end

  defp part_2(input) do
    input
  end

  def main do
    data = read_input(2025, 09) |> parse_input()

    run_solution(1, &part_1/1, data)
    # run_solution(2, &part_2/1, data)
  end
end

Solution.main()
