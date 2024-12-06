defmodule Solution do
  import Common.Input
  import Common.Output
  import Common.Enum

  @guard_symbols [">", "<", "^", "v"]

  defp parse_input(input) do
    grid =
      input
      |> Enum.map(fn line ->
        line |> String.split("") |> Enum.filter(fn cell -> cell != "" end)
      end)

    guard_starting_position =
      grid
      |> Enum.with_index()
      |> Enum.reduce(nil, fn {row, row_index}, acc ->
        case Enum.find_index(row, fn cell -> Enum.member?(@guard_symbols, cell) end) do
          nil -> acc
          col_index -> {row_index, col_index}
        end
      end)

    %{
      grid: grid,
      guard_starting_position: guard_starting_position
    }
  end

  defp rotate(current_direction) do
    case current_direction do
      ">" -> "v"
      "^" -> ">"
      "<" -> "^"
      "v" -> "<"
    end
  end

  defp propose_move({row, col}, grid) do
    {r, c, is_escaped} =
      case get_value_from_2_by_2_matrix({row, col}, grid) do
        ">" -> {row, col + 1, col == length(grid) - 1}
        "<" -> {row, col - 1, col == 0}
        "^" -> {row - 1, col, row == 0}
        "v" -> {row + 1, col, row == length(grid) - 1}
      end

    {r, c, get_value_from_2_by_2_matrix({r, c}, grid), is_escaped}
  end

  defp replace_item(grid, r, c, value) do
    grid
    |> Enum.with_index(fn row, row_index ->
      row
      |> Enum.with_index(fn cell, col_index ->
        if row_index == r && col_index == c do
          value
        else
          cell
        end
      end)
    end)
  end

  defp process_move({row, col}, grid, visited) do
    current_value = get_value_from_2_by_2_matrix({row, col}, grid)

    {proposed_row, proposed_col, proposed_value, is_escaped} = propose_move({row, col}, grid)

    is_cycle = MapSet.member?(visited, {proposed_row, proposed_col, proposed_value})

    accepted = proposed_value != "#"

    new_grid =
      if accepted do
        grid
        |> replace_item(row, col, ".")
        |> replace_item(proposed_row, proposed_col, current_value)
      else
        grid
        |> replace_item(row, col, rotate(current_value))
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
    {l, r} = starting_position
    grid = input[:grid]
    visited = MapSet.new([{l, r, get_value_from_2_by_2_matrix(starting_position, grid)}])

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
        } = process_move(starting_position, grid, visited)

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
    |> Enum.with_index()
    |> Enum.filter(fn {{row, col}, index} ->
      IO.puts(
        "Progressing... #{index + 1} / #{length(candidates)} #{round(100 * (index + 1) / length(candidates))}%"
      )

      grid = replace_item(input[:grid], row, col, "#")

      visited =
        MapSet.new([{l, r, get_value_from_2_by_2_matrix(starting_position, grid)}])

      Enum.reduce_while(
        1..10000,
        {starting_position, grid, visited},
        fn _, {position, grid, visited} ->
          {
            row,
            col,
            new_grid,
            is_escaped,
            new_visited,
            is_cycle
          } = process_move(position, grid, visited)

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
