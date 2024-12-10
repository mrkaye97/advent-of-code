defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    input
    |> Enum.map(fn
      x ->
        x
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
    end)
  end

  defp build_graph(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(Graph.new(), fn {row, row_index}, graph ->
      row
      |> Enum.with_index()
      |> Enum.reduce(graph, fn {value, col_index}, graph ->
        above =
          if row_index > 0,
            do: {row_index - 1, col_index, Enum.at(Enum.at(input, row_index - 1), col_index)},
            else: nil

        left =
          if col_index > 0, do: {row_index, col_index - 1, Enum.at(row, col_index - 1)}, else: nil

        right =
          if col_index < length(row) - 1,
            do: {row_index, col_index + 1, Enum.at(row, col_index + 1)},
            else: nil

        below =
          if row_index < length(input) - 1,
            do: {row_index + 1, col_index, Enum.at(Enum.at(input, row_index + 1), col_index)},
            else: nil

        [above, left, right, below]
        |> Enum.filter(&(&1 != nil))
        |> Enum.reduce(graph, fn {r, c, x}, acc ->
          if x == value + 1 do
            Graph.add_edge(acc, Graph.Edge.new({row_index, col_index}, {r, c}))
          else
            acc
          end
        end)
      end)
    end)
  end

  defp find_cells_by_value(grid, v) do
    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {value, col_index} ->
        if value == v do
          {row_index, col_index}
        else
          nil
        end
      end)
    end)
    |> Enum.filter(&(&1 != nil))
  end

  defp part_1(input) do
    trailheads = find_cells_by_value(input, 0)
    peaks = find_cells_by_value(input, 9)

    g = build_graph(input)

    trailheads
    |> Enum.map(fn trailhead ->
      peaks
      |> Enum.map(fn peak ->
        Graph.Pathfinding.dijkstra(g, trailhead, peak)
      end)
      |> Enum.filter(&(&1 != nil))
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp part_2(input) do
    trailheads = find_cells_by_value(input, 0)
    peaks = find_cells_by_value(input, 9)

    g = build_graph(input)

    trailheads
    |> Enum.map(fn trailhead ->
      peaks
      |> Enum.map(fn peak ->
        g
        |> Graph.Pathfinding.all(trailhead, peak)
        |> Enum.count()
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def main do
    data = read_input(2024, 10) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
