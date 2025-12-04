defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    input
    |> Enum.map(&String.graphemes/1)
  end

  defp get_value(input, row, col) do
    cond do
      row < 0 or row >= length(input) ->
        nil

      col < 0 or col >= length(Enum.at(input, row)) ->
        nil

      true ->
        input
        |> Enum.at(row)
        |> Enum.at(col)
    end
  end

  defp find_removables(input) do
    dirs = for x <- [-1, 0, 1], y <- [-1, 0, 1], do: {x, y}
    dirs = Enum.reject(dirs, fn {x, y} -> x == 0 and y == 0 end)

    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {value, col_index} ->
        num_adjacent_rolls =
          dirs
          |> Enum.filter(fn {dx, dy} ->
            get_value(input, row_index + dx, col_index + dy) == "@"
          end)
          |> length()

        num_adjacent_rolls < 4 && value == "@"
      end)
      |> Enum.map(fn {_, col_index} -> {row_index, col_index} end)
    end)
    |> Enum.to_list()
    |> MapSet.new()
  end

  defp remove_rolls(input, removables) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {value, col_index} ->
        cond do
          MapSet.member?(removables, {row_index, col_index}) -> "."
          true -> value
        end
      end)
    end)
  end

  defp part_1(input) do
    input
    |> find_removables()
    |> MapSet.size()
  end

  defp part_2(input) do
    Enum.reduce_while(1..100, {input, 0}, fn _, {grid, count} ->
      removable = find_removables(grid)
      new = remove_rolls(grid, removable)

      if MapSet.size(removable) == 0 do
        {:halt, {grid, count}}
      else
        {:cont, {new, count + MapSet.size(removable)}}
      end
    end)
    |> elem(1)
  end

  def main do
    data = read_input(2025, 04) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
