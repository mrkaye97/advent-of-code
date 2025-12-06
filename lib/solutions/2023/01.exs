defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    input
  end

  defp replace_spelled_out_digits(row) do
    new =
      Regex.replace(
        ~r/(one|two|three|four|five|six|seven|eight|nine)/,
        row,
        fn x ->
          case x do
            # trick to allow for overlapping numbers
            # e.g. if a line is onefooeightwo
            # it should result in 12,
            # which we can get if we parse it to 1fooe8tt2o
            # since "eight" and "two" overlap, but two needs to come last
            "one" -> "o1e"
            "two" -> "t2o"
            "three" -> "t3e"
            "four" -> "f4r"
            "five" -> "f5e"
            "six" -> "s6x"
            "seven" -> "s7n"
            "eight" -> "e8t"
            "nine" -> "n9e"
          end
        end,
        global: false
      )

    cond do
      new == row -> row
      true -> replace_spelled_out_digits(new)
    end
  end

  defp part_1(input) do
    input
    |> Enum.map(&String.graphemes/1)
    |> Enum.sum_by(fn row ->
      digits = row |> Enum.filter(fn char -> Regex.match?(~r/^\d/, char) end)

      String.to_integer(Enum.at(digits, 0) <> Enum.at(digits, -1))
    end)
  end

  defp part_2(input) do
    input
    |> Enum.map(&replace_spelled_out_digits/1)
    |> part_1()
  end

  def main do
    data = read_input(2023, 01) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
