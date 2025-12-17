defmodule Solution do
  import Common.Input
  import Common.Output
  use Memoize

  defp parse_input(input) do
    input
    |> Enum.map(fn row -> String.split(row, ": ") end)
    |> Enum.map(fn [k, vs] -> {k, String.split(vs, " ")} end)
  end

  defp part_1(input) do
    input
    |> Enum.reduce(Graph.new(), fn {k, vs}, g ->
      Enum.reduce(vs, g, fn v, g ->
        g
        |> Graph.add_vertex(v)
        |> Graph.add_edge(k, v)
      end)
    end)
    |> Graph.Pathfinding.all("you", "out")
    |> length()
  end

  defmemo dfs(_graph, curr, target, stack, visited_dac, visited_fft) when curr == target do
    cond do
      visited_dac and visited_fft -> 1
      true -> 0
    end
  end

  defmemo dfs(graph, curr, target, stack, visited_dac, visited_fft) do
    graph
    |> Map.get(curr, [])
    |> Enum.filter(fn child ->
      !Enum.member?(stack, child)
    end)
    |> Enum.reduce(0, fn child, total ->
      total +
        dfs(
          graph,
          child,
          target,
          [child | stack],
          visited_dac or child == "dac",
          visited_fft or child == "fft"
        )
    end)
  end

  defp part_2(input) do
    input
    |> Enum.reduce(Graph.new(), fn {k, vs}, g ->
      Enum.reduce(vs, g, fn v, g ->
        g
        |> Graph.add_vertex(v)
        |> Graph.add_edge(k, v)
      end)
    end)
    |> Graph.edges()
    |> Enum.reduce(Map.new(), fn e, acc ->
      from = e.v1
      to = e.v2
      existing = Map.get(acc, from, [])

      Map.put(acc, from, [to | existing])
    end)
    |> dfs("svr", "out", [], false, false)
  end

  def main do
    data = read_input(2025, 11) |> parse_input()

    IO.inspect(data)

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
