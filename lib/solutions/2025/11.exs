defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    input
    |> Enum.map(fn row -> String.split(row, ": ") end)
    |> Enum.map(fn [k, vs] -> {k, String.split(vs, " ")} end)
  end

  defp dfs(graph, curr, visited_dac, visited_fft, cache, part) do
    key = {curr, visited_dac, visited_fft}
    cached_value = Agent.get(cache, &Map.get(&1, key))

    cond do
      cached_value != nil ->
        cached_value

      true ->
        result =
          cond do
            curr == "out" ->
              if visited_dac and visited_fft, do: 1, else: 0

            true ->
              graph
              |> Map.get(curr, [])
              |> Enum.reduce(0, fn child, total ->
                total +
                  dfs(
                    graph,
                    child,
                    part == 1 or visited_dac or child == "dac",
                    part == 1 or visited_fft or child == "fft",
                    cache,
                    part
                  )
              end)
          end

        Agent.update(cache, &Map.put(&1, key, result))

        result
    end
  end

  defp solve(input, part, start) do
    graph =
      input
      |> Enum.reduce(Map.new(), fn {k, vs}, g ->
        Enum.reduce(vs, g, fn v, g ->
          Map.put(g, k, [v | Map.get(g, k, [])])
        end)
      end)

    {:ok, cache} = Agent.start_link(fn -> %{} end)
    result = dfs(graph, start, false, false, cache, part)
    Agent.stop(cache)
    result
  end

  defp part_1(input) do
    solve(input, 1, "you")
  end

  defp part_2(input) do
    solve(input, 2, "svr")
  end

  def main do
    data = read_input(2025, 11) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
