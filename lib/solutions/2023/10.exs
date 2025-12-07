defmodule Solution do
  import Common.Input
  import Common.Output
  alias Common.Grid
  alias Common.Misc

  @char_to_dirs %{
    "F" => {Grid.south(), Grid.east()},
    "-" => {Grid.east(), Grid.west()},
    "7" => {Grid.west(), Grid.south()},
    "|" => {Grid.north(), Grid.south()},
    "J" => {Grid.north(), Grid.west()},
    "L" => {Grid.north(), Grid.east()}
  }

  defp parse_input(input) do
    input
    |> Enum.map(&String.graphemes/1)
    |> Grid.new()
  end

  defp infer_start(grid, {x, y}) do
    neighbors = Grid.find_neighbors(grid, {x, y})

    cond do
      Enum.member?(["|", "L", "J"], neighbors[Grid.south()]) and
          Enum.member?(["|", "F", "7"], neighbors[Grid.north()]) ->
        "|"

      Enum.member?(["-", "L", "F"], neighbors[Grid.west()]) and
          Enum.member?(["-", "7", "J"], neighbors[Grid.east()]) ->
        "-"

      Enum.member?(["-", "L", "F"], neighbors[Grid.west()]) and
          Enum.member?(["|", "L", "J"], neighbors[Grid.south()]) ->
        "7"

      Enum.member?(["-", "J", "7"], neighbors[Grid.east()]) and
          Enum.member?(["|", "L", "J"], neighbors[Grid.south()]) ->
        "F"

      Enum.member?(["-", "L", "F"], neighbors[Grid.east()]) and
          Enum.member?(["|", "7", "F"], neighbors[Grid.north()]) ->
        "J"

      Enum.member?(["|", "F", "7"], neighbors[Grid.north()]) and
          Enum.member?(["-", "7", "J"], neighbors[Grid.east()]) ->
        "L"
    end
  end

  defp move(grid, {x, y}) do
    {d1, d2} = Map.get(@char_to_dirs, Grid.get(grid, {x, y}))

    Enum.map([d1, d2], fn d -> Grid.neighbor_pos({x, y}, d) end)
  end

  defp dfs(grid, {x, y}, visited) do
    [c1, c2] = move(grid, {x, y})

    cond do
      MapSet.member?(visited, c1) and MapSet.member?(visited, c2) ->
        visited

      MapSet.member?(visited, c1) ->
        visited = MapSet.put(visited, c2)
        dfs(grid, c2, visited)

      true ->
        visited = MapSet.put(visited, c1)
        dfs(grid, c1, visited)
    end
  end

  defp part_1(input) do
    start_coords = Grid.find(input, "S")

    input
    |> Grid.set(start_coords, infer_start(input, start_coords))
    |> dfs(start_coords, MapSet.new())
    |> MapSet.size()
    |> div(2)
  end

  defp traverse_to_edge(grid, coords, dir, cycle_nodes, count, has_seen_empty, has_seen_cycle) do
    next_ix = Grid.neighbor_pos(coords, dir)
    next = Grid.get(grid, next_ix)
    is_cycle_node = MapSet.member?(cycle_nodes, coords)
    count = count + Misc.boolean_to_integer(is_cycle_node)

    has_seen_cycle = has_seen_cycle or is_cycle_node

    has_seen_empty =
      cond do
        not has_seen_cycle -> false
        has_seen_cycle and not is_cycle_node -> true
        true -> has_seen_empty
      end

    cond do
      is_nil(next) ->
        # you can't get out in this direction if _either_
        # 1. you crossed an odd number of cycle nodes in this direction
        # 2. or, you crossed an even, non-zero number of cycle nodes, but you never saw an empty cell
        rem(count, 2) != 0 or (not has_seen_empty and has_seen_cycle)

      true ->
        traverse_to_edge(
          grid,
          next_ix,
          dir,
          cycle_nodes,
          count,
          has_seen_empty,
          has_seen_cycle
        )
    end
  end

  defp part_2(input) do
    start_coords = Grid.find(input, "S")

    nodes =
      input
      |> Grid.set(start_coords, infer_start(input, start_coords))
      |> dfs(start_coords, MapSet.new())

    input
    |> Enum.map(fn {coords, obj} ->
      cond do
        MapSet.member?(nodes, coords) ->
          {coords, obj, false}

        true ->
          {coords, obj,
           Enum.all?(
             [
               Grid.north(),
               Grid.south(),
               Grid.east(),
               Grid.west()
               #  Grid.southwest(),
               #  Grid.southeast(),
               #  Grid.northwest(),
               #  Grid.northeast()
             ],
             fn dir ->
               traverse_to_edge(input, coords, dir, nodes, 0, false, false)
             end
           )}
      end
    end)
    |> Enum.filter(fn {_, _, is_trapped} -> is_trapped end)
    |> length()
  end

  def main do
    data = read_input(2023, 10) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
