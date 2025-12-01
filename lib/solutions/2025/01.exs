defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    input
    |> Enum.map(fn x ->
      dir = String.at(x, 0)
      num = String.to_integer(String.slice(x, 1..-1//1))

      %{
        "dir" => dir,
        "num" => num
      }
    end)
  end

  defp part_1(input) do
    result =
      input
      |> Enum.reduce({50, 0}, fn x, {dial, counter} ->
        dir = x["dir"]
        num = x["num"]

        curr =
          case dir do
            "L" ->
              diff = dial - num

              tmp =
                case diff do
                  x when x > 0 -> diff
                  x when x < 0 -> 100 - abs(rem(dial - num, 100))
                  _ -> 0
                end

              case tmp do
                100 -> 0
                _ -> tmp
              end

            "R" ->
              rem(dial + num, 100)
          end

        flag =
          case curr do
            0 -> 1
            _ -> 0
          end

        {curr, counter + flag}
      end)

    {_, x} = result

    x
  end

  defp part_2(input) do
    result =
      input
      |> Enum.reduce({50, 0}, fn x, {dial, counter} ->
        dir = x["dir"]
        num = x["num"]

        {flag, dial} =
          case dir do
            "L" ->
              diff = dial - num

              cond do
                diff > 0 -> {0, diff}
                dial == 0 and diff < 0 -> {div(abs(diff), 100), 100 - abs(rem(diff, 100))}
                diff < 0 -> {div(abs(diff), 100) + 1, rem(100 - abs(rem(diff, 100)), 100)}
                diff == 0 and num == 0 -> {0, dial}
                diff == 0 and num != 0 -> {1, diff}
                true -> {0, 0}
              end

            "R" ->
              sum = dial + num

              case sum do
                x when x >= 100 -> {div(x, 100), rem(x, 100)}
                x when x < 100 -> {0, x}
              end
          end

        {dial, counter + flag}
      end)

    {_, x} = result

    x
  end

  def main do
    data = read_input(2025, 01) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
