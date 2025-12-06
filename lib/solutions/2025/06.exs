defmodule Solution do
  import Common.Input
  import Common.Output
  import Common.Enum

  defp parse_input(input) do
    input
  end

  defp compute(operands, operations) do
    Enum.zip(operands, operations)
    |> Enum.sum_by(fn {operands, operation} ->
      case operation do
        "*" -> Enum.product(operands)
        "+" -> Enum.sum(operands)
      end
    end)
  end

  defp part_1(input) do
    rows = Enum.map(input, &String.split/1)
    operations = Enum.at(rows, -1)

    operands =
      rows
      |> Enum.slice(0..-2//1)
      |> Enum.map(fn row ->
        Enum.map(row, &String.to_integer/1)
      end)
      |> transpose()

    compute(operands, operations)
  end

  def split_at_positions(string, positions) do
    positions = [0 | positions] ++ [String.length(string)]

    positions
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [start, stop] ->
      actual_start = if start == 0, do: 0, else: start + 1
      String.slice(string, actual_start, stop - actual_start)
    end)
  end

  defp part_2(input) do
    operations = Enum.at(input, -1) |> String.split()

    operands = Enum.slice(input, 0..-2//1)

    grid_width =
      operands
      |> Enum.map(fn row ->
        String.length(row)
      end)
      |> Enum.max()

    operands =
      operands
      |> Enum.map(fn row ->
        String.pad_trailing(row, grid_width)
      end)

    column_breaks =
      0..grid_width
      |> Enum.filter(fn ix ->
        Enum.all?(operands, fn op ->
          String.at(op, ix) == " "
        end)
      end)

    operands =
      operands
      |> Enum.map(fn op ->
        op
        |> split_at_positions(column_breaks)
        |> Enum.map(fn x -> String.replace(x, " ", "-") end)
      end)
      |> transpose()
      |> Enum.map(fn col ->
        col
        |> Enum.map(&String.graphemes/1)
        |> transpose()
        |> Enum.map(fn col ->
          Enum.map(col, fn num -> String.replace(num, "-", "") end)
          |> Enum.join()
          |> String.to_integer()
        end)
      end)

    compute(operands, operations)
  end

  def main do
    data = read_input(2025, 06) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
