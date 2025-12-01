defmodule Solution do
  import Common.Input
  import Common.Output
  import Common.Misc

  defp parse_input(input) do
    input
    |> Enum.map(fn x ->
      dir = String.at(x, 0)
      num = String.to_integer(String.slice(x, 1..-1//1))

      case dir do
        "L" -> -1 * num
        "R" -> num
      end
    end)
  end

  defp reposition_dial(dial, move) do
    rem(100 + rem(dial + move, 100), 100)
  end

  defp compute_clicks(dial, move) do
    new = dial + move

    cond do
      new == 0 and dial != 0 -> 1
      new > 0 or (dial == 0 and new < 0) -> div(abs(new), 100)
      new < 0 -> div(abs(new), 100) + 1
    end
  end

  defp part_1(input) do
    input
    |> Enum.reduce([50, 0], fn move, [dial, counter] ->
      dial = reposition_dial(dial, move)

      [dial, counter + boolean_to_integer(rem(dial, 100) == 0)]
    end)
    |> Enum.at(1)
  end

  defp part_2(input) do
    input
    |> Enum.reduce([50, 0], fn move, [dial, counter] ->
      [reposition_dial(dial, move), counter + compute_clicks(dial, move)]
    end)
    |> Enum.at(1)
  end

  def main do
    data = read_input(2025, 01) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
