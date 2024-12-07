defmodule Solution do
  import Common.Input
  import Common.Output

  @operations ["+", "*"]
  @with_concatenation @operations ++ ["||"]

  defp parse_input(input) do
    input
    |> Enum.map(fn line ->
      [total, parts] =
        line
        |> String.split(": ")

      %{
        parts:
          parts
          |> String.split(" ")
          |> Enum.map(&String.to_integer/1),
        total: String.to_integer(total)
      }
    end)
  end

  defp perform_operation(a, b, operator) do
    case operator do
      "+" -> a + b
      "*" -> a * b
      "||" -> (Integer.to_string(a) <> Integer.to_string(b)) |> String.to_integer()
    end
  end

  defp evaluate(parts, allow_concatenation) do
    if length(parts) == 1 do
      Enum.at(parts, 0)
    else
      first = Enum.at(parts, 0)
      second = Enum.at(parts, 1)
      tail = Enum.drop(parts, 2)

      ops =
        if allow_concatenation do
          @with_concatenation
        else
          @operations
        end

      ops
      |> Enum.map(fn op ->
        result = perform_operation(first, second, op)

        if length(tail) == 0 do
          result
        else
          evaluate([result | tail], allow_concatenation)
        end
      end)
      |> List.flatten()
    end
  end

  defp solve(input, allow_concatenation) do
    input
    |> Enum.filter(fn line ->
      line[:parts]
      |> evaluate(allow_concatenation)
      |> List.flatten()
      |> Enum.any?(fn result ->
        result == line[:total]
      end)
    end)
    |> Enum.map(fn line ->
      line[:total]
    end)
    |> Enum.sum()
  end

  defp part_1(input) do
    solve(input, false)
  end

  defp part_2(input) do
    solve(input, true)
  end

  def main do
    data = read_input(2024, 07) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
