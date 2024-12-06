defmodule Common.Enum do
  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def get_value_from_2_by_2_matrix({row, col}, matrix) do
    matrix[{row, col}]
  end
end
