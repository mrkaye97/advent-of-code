defmodule Solution do
  import Common.Input
  import Common.Output
  import Common.Enum

  defp parse_input(input) do
    input
    |> Enum.map(fn ln ->
      ln |> String.graphemes() |> Enum.map(fn x -> String.to_integer(x) end)
    end)
  end

  defp compute_joltage(input, n) do
    Enum.sum_by(input, fn bank ->
      Enum.reduce(n..1//-1, {"", bank}, fn ix, {acc, b} ->
        candidates = Enum.slice(b, 0..(length(b) - ix))

        {
          acc <> Integer.to_string(Enum.max(candidates)),
          Enum.slice(b, (argmax(candidates) + 1)..length(b))
        }
      end)
      |> elem(0)
      |> String.to_integer()
    end)
  end

  defp part_1(input) do
    compute_joltage(input, 2)
  end

  defp part_2(input) do
    compute_joltage(input, 12)
  end

  def main do
    data = read_input(2025, 03) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
