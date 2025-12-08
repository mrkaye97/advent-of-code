defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    input =
      input
      |> Enum.map(fn x ->
        x |> String.split(",") |> Enum.map(fn x -> String.to_integer(x) end)
      end)
      |> Enum.map(fn [x, y, z] -> {x, y, z} end)

    graph =
      input
      |> Enum.reduce(Graph.new(type: :undirected), fn {x, y, z}, graph ->
        Graph.add_vertex(graph, {x, y, z})
      end)

    distances =
      Enum.reduce(Graph.vertices(graph), Map.new(), fn {x1, y1, z1}, acc ->
        Enum.reduce(
          Graph.vertices(graph),
          acc,
          fn {x2, y2, z2}, acc ->
            cond do
              !is_nil(Map.get(acc, {{x2, y2, z2}, {x1, y1, z1}})) ->
                acc

              {x1, y1, z1} == {x2, y2, z2} ->
                acc

              true ->
                acc
                |> Map.put(
                  {{x1, y1, z1}, {x2, y2, z2}},
                  :math.sqrt(
                    :math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2) + :math.pow(z2 - z1, 2)
                  )
                )
                |> Map.put(
                  {{x2, y2, z2}, {x1, y1, z1}},
                  :math.sqrt(
                    :math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2) + :math.pow(z2 - z1, 2)
                  )
                )
            end
          end
        )
      end)
      |> Enum.to_list()
      |> Enum.sort_by(&elem(&1, 1))

    {graph, distances}
  end

  defp add_edges(graph, distances, n) do
    cond do
      length(Graph.edges(graph)) >= n ->
        graph

      true ->
        {{v1, v2}, distance} = Enum.at(distances, 0)
        remaining = Enum.slice(distances, 1..-1//1)
        add_edges(Graph.add_edge(graph, v1, v2), remaining, n)
    end
  end

  defp add_edges_2(graph, distances, last_nodes) do
    cond do
      length(Graph.components(graph)) == 1 ->
        last_nodes

      true ->
        {{v1, v2}, distance} = Enum.at(distances, 0)
        remaining = Enum.slice(distances, 1..-1//1)
        add_edges_2(Graph.add_edge(graph, v1, v2), remaining, [v1, v2])
    end
  end

  defp part_1(graph, distances) do
    graph
    |> add_edges(distances, 1000)
    |> Graph.components()
    |> Enum.sort(&(length(&1) <= length(&2)))
    |> Enum.reverse()
    |> Enum.slice(0, 3)
    |> Enum.map(&length/1)
    |> Enum.product()
  end

  defp part_2(graph, distances) do
    graph
    |> add_edges_2(distances, [nil, nil])
    |> Enum.map(fn {x, _, _} -> x end)
    |> Enum.product()
  end

  def main do
    data = read_input(2025, 08) |> parse_input()
    run_solution(1, fn {graph, distances} -> part_1(graph, distances) end, data)
    run_solution(2, fn {graph, distances} -> part_2(graph, distances) end, data)
  end
end

Solution.main()
