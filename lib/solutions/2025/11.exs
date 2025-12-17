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

  defp dfs(graph, curr, visited_dac, visited_fft, cache) do
    key = {curr, visited_dac, visited_fft}

    case Agent.get(cache, &Map.get(&1, key)) do
      nil ->
        result =
          if curr == "out" do
            if visited_dac and visited_fft, do: 1, else: 0
          else
            graph
            |> Map.get(curr, [])
            |> Enum.reduce(0, fn child, total ->
              total +
                dfs(
                  graph,
                  child,
                  visited_dac or child == "dac",
                  visited_fft or child == "fft",
                  cache
                )
            end)
          end

        Agent.update(cache, &Map.put(&1, key, result))
        result

      cached ->
        cached
    end
  end

  defp part_2(input) do
    graph =
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

    {:ok, cache} = Agent.start_link(fn -> %{} end)
    result = dfs(graph, "svr", false, false, cache)
    Agent.stop(cache)
    result
  end

  def main do
    data = read_input(2025, 11) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
