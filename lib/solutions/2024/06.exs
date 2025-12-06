defmodule Solution do
  import Common.Input
  import Common.Output
  alias Common.Grid

  @guard_symbols [">", "<", "^", "v"]
  @symbol_to_dir %{
    "^" => Grid.north(),
    "v" => Grid.south(),
    ">" => Grid.east(),
    "<" => Grid.west()
  }
  @rotation_map %{"^" => ">", ">" => "v", "v" => "<", "<" => "^"}

  defp parse_input(input) do
    grid =
      input
      |> Enum.map(&String.graphemes/1)
      |> Grid.new()

    guard_starting_position =
      @guard_symbols
      |> Enum.map(fn sym ->
        Grid.find(grid, sym)
      end)
      |> Enum.filter(& &1)
      |> Enum.at(0)

    %{
      grid: grid,
      guard_starting_position: guard_starting_position,
      dimension: length(input)
    }
  end

  defp propose_move(pos, grid, _) do
    current_value = Grid.get(grid, pos, ".")
    direction = Map.get(@symbol_to_dir, current_value)

    next_pos = Grid.neighbor_pos(pos, direction)
    next_value = Grid.get(grid, next_pos)

    {elem(next_pos, 0), elem(next_pos, 1), next_value, is_nil(next_value)}
  end

  defp process_move({row, col}, grid, visited, dimension) do
    current_value = Grid.get(grid, {row, col})

    {proposed_row, proposed_col, proposed_value, is_escaped} =
      propose_move({row, col}, grid, dimension)

    is_cycle = MapSet.member?(visited, {proposed_row, proposed_col, proposed_value})

    accepted = proposed_value != "#"

    new_grid =
      if accepted do
        grid
        |> Grid.set({row, col}, ".")
        |> Grid.set({proposed_row, proposed_col}, current_value)
      else
        grid
        |> Grid.set({row, col}, Map.get(@rotation_map, current_value, current_value))
      end

    new_visited =
      if accepted and not is_escaped do
        MapSet.put(visited, {proposed_row, proposed_col, current_value})
      else
        visited
      end

    if accepted do
      {proposed_row, proposed_col, new_grid, is_escaped, new_visited, is_cycle}
    else
      {row, col, new_grid, is_escaped, new_visited, is_cycle}
    end
  end

  defp find_visited_tiles(input) do
    starting_position = input[:guard_starting_position]
    {x, y} = starting_position
    grid = input[:grid]
    visited = MapSet.new([{x, y, Grid.get(grid, starting_position)}])

    Enum.reduce_while(
      1..10000,
      {starting_position, grid, visited},
      fn _, {starting_position, grid, visited} ->
        {
          row,
          col,
          new_grid,
          is_escaped,
          visited,
          _is_cycle
        } = process_move(starting_position, grid, visited, input[:dimension])

        if is_escaped do
          {:halt, visited}
        else
          {:cont, {{row, col}, new_grid, visited}}
        end
      end
    )
  end

  defp part_1(input) do
    input
    |> find_visited_tiles()
    |> MapSet.to_list()
    |> Enum.map(fn {row, col, _} -> {row, col} end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp part_2(input) do
    starting_position = input[:guard_starting_position]
    {l, r} = starting_position

    candidates =
      input
      |> find_visited_tiles()
      |> Enum.map(fn {row, col, _} -> {row, col} end)
      |> Enum.filter(fn p -> p != starting_position end)

    candidates
    |> Enum.map(fn {row, col} ->
      Task.async(fn ->
        grid = Grid.set(input[:grid], {row, col}, "#")

        visited =
          MapSet.new([{l, r, Grid.get(grid, starting_position)}])

        Enum.reduce_while(
          1..15000,
          {starting_position, grid, visited},
          fn _, {position, grid, visited} ->
            {
              row,
              col,
              new_grid,
              is_escaped,
              new_visited,
              is_cycle
            } = process_move(position, grid, visited, input[:dimension])

            if is_escaped or is_cycle do
              if is_escaped do
                {:halt, false}
              else
                {:halt, true}
              end
            else
              {:cont, {{row, col}, new_grid, new_visited}}
            end
          end
        )
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> Enum.filter(& &1)
    |> Enum.uniq()
    |> Enum.count()
  end

  def main do
    data = read_input(2024, 06) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
