defmodule Solution do
  import Common.Input
  import Common.Output

  @directions ["N", "E", "S", "W"]

  defp parse_input(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_index}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, col_index}, acc ->
        Map.put(acc, {row_index, col_index}, cell)
      end)
    end)
  end

  defp find_square_by_value(input, value) do
    Enum.find_value(input, fn {coords, v} -> if v == value, do: coords end)
  end

  defp add_rotation_edges(graph, position) do
    Enum.reduce(@directions, graph, fn direction, acc_graph ->
      Enum.reduce(@directions -- [direction], acc_graph, fn other_direction, g ->
        Graph.add_edge(
          g,
          Graph.Edge.new({position, direction}, {position, other_direction}, weight: 1000)
        )
      end)
    end)
  end

  defp propose_coords({x, y}, "N"), do: {x - 1, y}
  defp propose_coords({x, y}, "E"), do: {x, y + 1}
  defp propose_coords({x, y}, "S"), do: {x + 1, y}
  defp propose_coords({x, y}, "W"), do: {x, y - 1}

  defp add_travel_edges(graph, coords_map) do
    Enum.reduce(coords_map, graph, fn {coords, _}, acc_graph ->
      Enum.reduce(@directions, acc_graph, fn direction, g ->
        proposed = propose_coords(coords, direction)

        if Map.get(coords_map, proposed) not in ["#", nil] do
          Graph.add_edge(
            g,
            Graph.Edge.new({coords, direction}, {proposed, direction}, weight: 1)
          )
        else
          g
        end
      end)
    end)
  end

  defp build_graph(data) do
    Enum.reduce(data, Graph.new(), fn {coords, value}, graph ->
      if value == "#" do
        graph
      else
        graph
        |> add_rotation_edges(coords)
      end
    end)
    |> add_travel_edges(data)
  end

  defp part_1(data) do
    start_coords = find_square_by_value(data, "S")
    end_coords = find_square_by_value(data, "E")
    start_square = {start_coords, "E"}

    graph = build_graph(data)

    @directions
    |> Enum.map(fn direction ->
      case Graph.dijkstra(graph, start_square, {end_coords, direction}) do
        nil ->
          :infinity

        path ->
          Enum.chunk_every(path, 2, 1, :discard)
          |> Enum.reduce(0, fn [from, to], acc ->
            acc + Graph.edge(graph, from, to).weight
          end)
      end
    end)
    |> Enum.min()
  end

  defp part_2(data) do
    start_coords = find_square_by_value(data, "S")
    end_coords = find_square_by_value(data, "E")
    start_square = {start_coords, "E"}

    graph = build_graph(data)

    @directions
    |> Enum.map(fn direction ->
      paths = Graph.Pathfindings.BellmanFord(graph, start_square, {end_coords, direction})

      paths
      |> Enum.map(fn path ->
        path
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce(0, fn [from, to], acc ->
          acc + Graph.edge(graph, from, to).weight
        end)
      end)
      |> IO.inspect()
    end)
    |> Enum.min()
  end

  def main do
    data = read_input(2024, 16) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
