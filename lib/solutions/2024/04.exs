defmodule Solution do
  import Common.Input
  import Common.Output

  @xmas "XMAS"

  defp parse_input(input) do
    input
    |> Enum.map(&String.graphemes/1)
  end

  def right(grid, row, col) do
    if col < length(grid) - 3 do
      result =
        grid
        |> Enum.at(row)
        |> Enum.slice(col..(col + 3))
        |> Enum.join("")

      result == @xmas
    else
      false
    end
  end

  def left(grid, row, col) do
    if col > 2 do
      result =
        grid
        |> Enum.at(row)
        |> Enum.slice((col - 3)..col)
        |> Enum.reverse()
        |> Enum.join("")

      result == @xmas
    else
      false
    end
  end

  def up(grid, row, col) do
    if row > 2 do
      result =
        grid
        |> Enum.map(fn r -> Enum.at(r, col) end)
        |> List.flatten()
        |> Enum.slice((row - 3)..row)
        |> Enum.reverse()
        |> Enum.join("")

      result == @xmas
    else
      false
    end
  end

  def down(grid, row, col) do
    if row < length(grid) - 3 do
      result =
        grid
        |> Enum.map(fn r -> Enum.at(r, col) end)
        |> List.flatten()
        |> Enum.slice(row..(row + 3))
        |> Enum.join("")

      result == @xmas
    else
      false
    end
  end

  def down_right(grid, row, col) do
    if row < length(grid) - 3 and col < length(grid) - 3 do
      first = grid |> Enum.at(row) |> Enum.at(col)
      second = grid |> Enum.at(row + 1) |> Enum.at(col + 1)
      third = grid |> Enum.at(row + 2) |> Enum.at(col + 2)
      fourth = grid |> Enum.at(row + 3) |> Enum.at(col + 3)

      @xmas == first <> second <> third <> fourth
    else
      false
    end
  end

  def down_left(grid, row, col) do
    if row < length(grid) - 3 and col > 2 do
      first = grid |> Enum.at(row) |> Enum.at(col)
      second = grid |> Enum.at(row + 1) |> Enum.at(col - 1)
      third = grid |> Enum.at(row + 2) |> Enum.at(col - 2)
      fourth = grid |> Enum.at(row + 3) |> Enum.at(col - 3)

      @xmas == first <> second <> third <> fourth
    else
      false
    end
  end

  def up_right(grid, row, col) do
    if col < length(grid) - 3 and row > 2 do
      first = grid |> Enum.at(row) |> Enum.at(col)
      second = grid |> Enum.at(row - 1) |> Enum.at(col + 1)
      third = grid |> Enum.at(row - 2) |> Enum.at(col + 2)
      fourth = grid |> Enum.at(row - 3) |> Enum.at(col + 3)

      @xmas == first <> second <> third <> fourth
    else
      false
    end
  end

  def up_left(grid, row, col) do
    if col > 2 and row > 2 do
      first = grid |> Enum.at(row) |> Enum.at(col)
      second = grid |> Enum.at(row - 1) |> Enum.at(col - 1)
      third = grid |> Enum.at(row - 2) |> Enum.at(col - 2)
      fourth = grid |> Enum.at(row - 3) |> Enum.at(col - 3)

      @xmas == first <> second <> third <> fourth
    else
      false
    end
  end

  def left_diagonal_mas(grid, row, col) do
    if row > 0 and col > 0 and row < length(grid) - 1 and col < length(grid) - 1 do
      ul = grid |> Enum.at(row - 1) |> Enum.at(col - 1)
      dr = grid |> Enum.at(row + 1) |> Enum.at(col + 1)

      (ul == "M" and dr == "S") or (ul == "S" and dr == "M")
    else
      false
    end
  end

  def right_diagonal_mas(grid, row, col) do
    if row > 0 and col > 0 and row < length(grid) - 1 and col < length(grid) - 1 do
      ur = grid |> Enum.at(row - 1) |> Enum.at(col + 1)
      dl = grid |> Enum.at(row + 1) |> Enum.at(col - 1)

      (ur == "M" and dl == "S") or (ur == "S" and dl == "M")
    else
      false
    end
  end

  def extract_xmas_occurrences(grid, row, col) do
    r = right(grid, row, col)
    l = left(grid, row, col)
    u = up(grid, row, col)
    d = down(grid, row, col)
    dr = down_right(grid, row, col)
    dl = down_left(grid, row, col)
    ur = up_right(grid, row, col)
    ul = up_left(grid, row, col)

    [l, r, u, d, dr, dl, ur, ul]
    |> Enum.reduce(0, fn x, acc -> if x, do: acc + 1, else: acc end)
  end

  def extract_x_mas_occurrences(grid, row, col) do
    center = grid |> Enum.at(row) |> Enum.at(col) == "A"
    left = left_diagonal_mas(grid, row, col)
    right = right_diagonal_mas(grid, row, col)

    if(center and right and left, do: 1, else: 0)
  end

  defp part_1(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      Task.async(fn ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {_, col_index} ->
          extract_xmas_occurrences(input, row_index, col_index)
        end)
        |> Enum.sum()
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> Enum.sum()
  end

  defp part_2(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {_, col_index} ->
        extract_x_mas_occurrences(input, row_index, col_index)
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def main do
    data =
      read_input(2024, 04)
      |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
