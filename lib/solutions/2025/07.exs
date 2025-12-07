defmodule Solution do
  import Common.Input
  import Common.Output
  alias Common.Grid

  defp parse_input(input) do
    input
    |> Enum.map(&String.graphemes/1)
    |> Grid.new()
  end

  defp part_1(grid) do
    {_, height} = Grid.dim(grid)

    Enum.reduce_while(0..height, {grid, [Grid.find(grid, "S")], 0}, fn _, {g, row, count} ->
      candidates =
        Enum.map(row, fn coords ->
          pos = Grid.find_neighbor_pos(coords, Grid.south())

          {pos, Grid.get(g, pos)}
        end)

      cond do
        not Enum.any?(Enum.map(candidates, fn {_, v} -> v end)) ->
          {:halt, count}

        true ->
          {g, next, c} =
            candidates
            |> Enum.reduce({g, MapSet.new(), count}, fn {coords, val}, {acc, next, c} ->
              cond do
                val == "^" ->
                  east_neighbor = Grid.find_neighbor_pos(coords, Grid.east())
                  west_neighbor = Grid.find_neighbor_pos(coords, Grid.west())

                  {acc
                   |> Grid.set(east_neighbor, "|")
                   |> Grid.set(west_neighbor, "|"),
                   next |> MapSet.put(east_neighbor) |> MapSet.put(west_neighbor), c + 1}

                true ->
                  {acc |> Grid.set(coords, "|"), MapSet.put(next, coords), c}
              end
            end)

          {:cont, {g, next, c}}
      end
    end)
  end

  defp build_tree(grid) do
    {_, height} = Grid.dim(grid)
    tree = Graph.new()

    Enum.reduce_while(
      0..height,
      {grid, [Grid.find(grid, "S")], 0, tree},
      fn _, {g, row, count, t} ->
        t = Enum.reduce(row, t, fn coords, acc -> Graph.add_vertex(acc, coords) end)

        candidates =
          Enum.map(row, fn coords ->
            pos = Grid.find_neighbor_pos(coords, Grid.south())

            {pos, Grid.get(g, pos)}
          end)

        cond do
          not Enum.any?(Enum.map(candidates, fn {_, v} -> v end)) ->
            {:halt,
             {Enum.map(candidates, fn {pos, _} -> Grid.find_neighbor_pos(pos, Grid.north()) end),
              t}}

          true ->
            {g, next, c, t} =
              candidates
              |> Enum.reduce({g, MapSet.new(), count, t}, fn {coords, val}, {acc, next, c, t} ->
                cond do
                  val == "^" ->
                    east_neighbor = Grid.find_neighbor_pos(coords, Grid.east())
                    west_neighbor = Grid.find_neighbor_pos(coords, Grid.west())

                    {acc
                     |> Grid.set(east_neighbor, "|")
                     |> Grid.set(west_neighbor, "|"),
                     next |> MapSet.put(east_neighbor) |> MapSet.put(west_neighbor), c + 1,
                     t
                     |> Graph.add_edge(
                       Grid.find_neighbor_pos(coords, Grid.north()),
                       east_neighbor
                     )
                     |> Graph.add_edge(
                       Grid.find_neighbor_pos(coords, Grid.north()),
                       west_neighbor
                     )}

                  true ->
                    {acc |> Grid.set(coords, "|"), MapSet.put(next, coords), c,
                     t |> Graph.add_edge(Grid.find_neighbor_pos(coords, Grid.north()), coords)}
                end
              end)

            {:cont, {g, next, c, t}}
        end
      end
    )
  end

  defp part_2(grid) do
    {_, height} = Grid.dim(grid)
    {leaves, tree} = build_tree(grid)
    start = Grid.find(grid, "S")

    {m, _} =
      Enum.reduce_while(0..height, {Map.new(), leaves}, fn _, {memo, row} ->
        updated_memo =
          row
          |> Enum.reduce(memo, fn curr, memo ->
            {_, depth} = curr

            child_values =
              tree
              |> Graph.edges(curr)
              |> Enum.map(fn edge ->
                v1 = edge |> Map.get(:v1)
                v2 = edge |> Map.get(:v2)

                cond do
                  v1 == curr -> v2
                  true -> v1
                end
              end)
              |> Enum.filter(fn {_, y} -> y < depth end)
              |> Enum.map(fn node ->
                Map.get(memo, node, 1)
              end)
              |> Enum.sum()

            Map.put(
              memo,
              curr,
              cond do
                child_values == 0 -> 1
                true -> child_values
              end
            )
          end)

        parent_row =
          row
          |> Enum.flat_map(fn curr ->
            {_, depth} = curr

            tree
            |> Graph.edges(curr)
            |> Enum.map(fn edge ->
              v1 = edge |> Map.get(:v1)
              v2 = edge |> Map.get(:v2)

              cond do
                v1 == curr -> v2
                true -> v1
              end
            end)
            |> Enum.filter(fn {_, y} -> y > depth end)
          end)
          |> Enum.uniq()

        {:cont, {updated_memo, parent_row}}
      end)

    Map.get(m, start)
  end

  def main do
    data = read_input(2025, 07) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
