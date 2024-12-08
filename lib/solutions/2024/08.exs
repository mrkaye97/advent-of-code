defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    input
    |> Enum.map(&String.graphemes/1)
  end

  defp pairs(xs) do
    Enum.reduce(xs, [], fn x, acc ->
      Enum.reduce(xs, acc, fn y, acc ->
        if x < y do
          [{x, y} | acc]
        else
          acc
        end
      end)
    end)
  end

  defp antenna_locations(input) do
    dim = length(input)

    input
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {value, index}, acc ->
      row = Integer.floor_div(index, dim)
      col = Integer.mod(index, dim)
      existing = Map.get(acc, value, [])

      Map.put(acc, value, existing ++ [{row, col}])
    end)
    |> Map.delete(".")
  end

  defp propose_antinodes({x1, y1}, {x2, y2}, n, input) do
    x_distance = x2 - x1
    y_distance = y2 - y1

    new =
      Enum.reduce_while(1..n, [], fn multiplier, acc ->
        left_antinode = {x1 - multiplier * x_distance, y1 - multiplier * y_distance}
        right_antinode = {x2 + multiplier * x_distance, y2 + multiplier * y_distance}

        left_valid = is_valid_location(left_antinode, length(input))
        right_valid = is_valid_location(right_antinode, length(input))

        cond do
          left_valid and right_valid ->
            {:cont, acc ++ [left_antinode, right_antinode]}

          left_valid ->
            {:cont, acc ++ [left_antinode]}

          right_valid ->
            {:cont, acc ++ [right_antinode]}

          true ->
            {:halt, acc}
        end
      end)

    if n == 1 do
      new
    else
      new ++
        [
          {x1, y1},
          {x2, y2}
        ]
    end
  end

  defp is_valid_location({x, y}, dim) do
    x >= 0 and x < dim and y >= 0 and y < dim
  end

  defp solve(input, n) do
    input
    |> antenna_locations()
    |> Enum.reduce(Map.new(), fn {value, coords}, acc ->
      Map.put(acc, value, pairs(coords))
    end)
    |> Enum.flat_map(fn {_value, pairs} ->
      pairs
      |> Enum.flat_map(fn {a, b} ->
        propose_antinodes(a, b, n, input)
      end)
      |> Enum.uniq()
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp part_1(input) do
    solve(input, 1)
  end

  defp part_2(input) do
    ## This is a hack
    solve(input, 20000)
  end

  def main do
    data = read_input(2024, 08) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
