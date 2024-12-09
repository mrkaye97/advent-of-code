defmodule Common.Enum do
  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def get_value_from_2_by_2_matrix({row, col}, matrix) do
    matrix[{row, col}]
  end

  def swap(xs, a, b) do
    x = Enum.at(xs, a)
    y = Enum.at(xs, b)

    xs
    |> List.replace_at(a, y)
    |> List.replace_at(b, x)
  end
end
