defmodule Solution do
  import Common.Input
  import Common.Output

  @directions ["N", "E", "S", "W"]

  defp parse_input(input) do
    input
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_index}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, col_index}, acc ->
        Map.put(acc, {row_index, col_index}, cell)
      end)
    end)
  end

  defp find_square_by_value(input, value) do
    input
    |> Enum.find(fn {_, v} -> v == value end)
    |> elem(0)
  end

  defp add_rotation_edges(graph, position) do
    Enum.reduce(@directions, graph, fn direction, graph2 ->
      Enum.reduce(@directions, graph2, fn direction2, graph3 ->
        if direction != direction2 do
          Graph.add_edge(
            graph3,
            Graph.Edge.new({position, direction}, {position, direction2}, weight: 1000)
          )
        else
          graph3
        end
      end)
    end)
  end

  defp propose_coords(coords, direction) do
    cond do
      direction == "N" -> {elem(coords, 0) - 1, elem(coords, 1)}
      direction == "E" -> {elem(coords, 0), elem(coords, 1) + 1}
      direction == "S" -> {elem(coords, 0) + 1, elem(coords, 1)}
      direction == "W" -> {elem(coords, 0), elem(coords, 1) - 1}
    end
  end

  defp add_travel_edges(graph) do
    Enum.reduce(
      Graph.vertices(graph),
      graph,
      fn {coords, direction}, graph2 ->
        Enum.reduce(Graph.vertices(graph), graph2, fn {coords2, _}, graph3 ->
          proposed = propose_coords(coords, direction)

          if coords2 == proposed do
            Graph.add_edge(
              graph3,
              Graph.Edge.new({coords, direction}, {coords2, direction}, weight: 1)
            )
          else
            graph3
          end
        end)
      end
    )
  end

  defp part_1(data) do
    start_square = {find_square_by_value(data, "S"), "E"}
    end_square = find_square_by_value(data, "E")

    g =
      data
      |> Enum.reduce(Graph.new(), fn {_, _}, graph ->
        data
        |> Enum.reduce(graph, fn {coords2, value2}, graph2 ->
          IO.inspect(coords2)

          if value2 == "#" do
            graph2
          else
            add_rotation_edges(graph2, coords2)
          end
        end)
      end)
      |> add_travel_edges()

    @directions
    |> Enum.map(fn direction ->
      Graph.dijkstra(g, start_square, {end_square, direction})
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [from, to] -> Graph.edge(g, from, to).weight end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  defp part_2(input) do
    input
  end

  def main do
    data = read_input(2024, 16) |> parse_input()

    run_solution(1, &part_1/1, data)
    # run_solution(2, &part_2/1, data)
  end
end

Solution.main()
