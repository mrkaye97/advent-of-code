defmodule Solution do
  import Common.Input
  import Common.Output

  defp create_node(row, col, value) do
    %{
      row: row,
      col: col,
      value: value
    }
  end

  defp parse_input(input) do
    input
    |> Enum.map(&String.graphemes/1)
  end

  defp part_1(g) do
    g
    |> Graph.components()
    |> Enum.reduce(0, fn component, total_price ->
      edges =
        g
        |> Graph.edges()
        |> Enum.filter(fn x ->
          Enum.member?(component, x.v1) and Enum.member?(component, x.v2)
        end)

      area = Enum.count(component)
      perimeter = 4 * area - 2 * Enum.count(edges)

      total_price + area * perimeter
    end)
  end

  defp part_2(g) do
    g
    |> Graph.components()
    |> Enum.reduce(0, fn component, total_price ->
    end)
  end

  defp build_graph(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(Graph.new(type: :undirected), fn {row, row_index}, graph ->
      row
      |> Enum.with_index()
      |> Enum.reduce(graph, fn {value, col_index}, graph ->
        new_graph = Graph.add_vertex(graph, create_node(row_index, col_index, value))

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
        |> Enum.reduce(new_graph, fn {r, c, x}, acc ->
          if x == value do
            Graph.add_edge(
              acc,
              Graph.Edge.new(create_node(row_index, col_index, value), create_node(r, c, x))
            )
          else
            acc
          end
        end)
      end)
    end)
  end

  def main do
    data = read_input(2024, 12) |> parse_input()

    g = build_graph(data)

    run_solution(1, &part_1/1, g)
    run_solution(2, &part_2/1, g)
  end
end

Solution.main()
