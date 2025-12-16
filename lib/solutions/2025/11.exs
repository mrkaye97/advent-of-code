defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    input
    |> Enum.map(fn row -> String.split(row, ": ") end)
    |> Enum.map(fn [k, vs] -> {k, String.split(vs, " ")} end)
  end

  defp part_1(input) do
    graph =
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

  defp part_2(input) do
    input
  end

  def main do
    data = read_input(2025, 11) |> parse_input()

    IO.inspect(data)

    run_solution(1, &part_1/1, data)
    # run_solution(2, &part_2/1, data)
  end
end

Solution.main()
