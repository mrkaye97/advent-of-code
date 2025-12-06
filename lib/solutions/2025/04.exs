defmodule Solution do
  import Common.Input
  import Common.Output
  import Common.Grid

  defp parse_input(input) do
    input
    |> Enum.map(&String.graphemes/1)
    |> new()
  end

  defp is_removable(value, neighbors) do
    num_adjacent_rolls = Enum.count(neighbors, fn {_, val} -> val == "@" end)

    num_adjacent_rolls < 4 and value == "@"
  end

  defp find_removables(input) do
    input
    |> Enum.filter(fn {coords, value} ->
      is_removable(value, find_neighbors(input, coords))
    end)
  end

  defp remove_rolls(input, removables) do
    removables
    |> Enum.reduce(input, fn {coords, _}, acc ->
      set(acc, coords, ".")
    end)
  end

  defp part_1(input) do
    input
    |> find_removables()
    |> length()
  end

  defp part_2(input) do
    Enum.reduce_while(1..100, {input, 0}, fn _, {grid, count} ->
      removable = find_removables(grid)

      if length(removable) == 0 do
        {:halt, {grid, count}}
      else
        {:cont, {remove_rolls(grid, removable), count + length(removable)}}
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
