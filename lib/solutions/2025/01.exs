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
      |> Enum.reduce({50, 0}, fn x, {pos, counter} ->
        dir = x["dir"]
        mag = x["num"]
        new_pos = if dir == "L", do: pos - mag, else: pos + mag

        {new_clicks, pos} =
          cond do
            (new_pos < 100 and dir == "R") or (new_pos > 0 and dir == "L") or
                (new_pos == 0 and mag == 0) ->
              {0, new_pos}

            new_pos >= 100 ->
              {div(new_pos, 100), rem(new_pos, 100)}

            pos == 0 and new_pos < 0 ->
              {div(abs(new_pos), 100), 100 - abs(rem(new_pos, 100))}

            new_pos < 0 ->
              {div(abs(new_pos), 100) + 1, rem(100 - abs(rem(new_pos, 100)), 100)}

            new_pos == 0 and mag != 0 ->
              {1, new_pos}

            true ->
              {0, 0}
          end

        {pos, counter + new_clicks}
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
