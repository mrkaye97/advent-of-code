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
    start = Grid.find(grid, "S")
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

    Enum.reduce_while(0..height, {grid, [Grid.find(grid, "S")], 0, tree}, fn _,
                                                                             {g, row, count, t} ->
      t = Enum.reduce(row, t, fn coords, acc -> Graph.add_vertex(acc, coords) end)

      candidates =
        Enum.map(row, fn coords ->
          pos = Grid.find_neighbor_pos(coords, Grid.south())

          {pos, Grid.get(g, pos)}
        end)

      cond do
        not Enum.any?(Enum.map(candidates, fn {_, v} -> v end)) ->
          {:halt,
           {Enum.map(candidates, fn {pos, _} -> Grid.find_neighbor_pos(pos, Grid.north()) end), t}}

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
    end)
  end

  defp part_2(grid) do
    {_, height} = Grid.dim(grid)
    {leaves, tree} = build_tree(grid)
    start = Grid.find(grid, "S")

    ## todo: do this with DP, iterating from the bottom up and caching
    ## paths along the way
    Enum.sum_by(leaves, fn leaf ->
      tree |> Graph.get_paths(start, leaf) |> Enum.count()
    end)
  end

  def main do
    data = read_input(2025, 07) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
