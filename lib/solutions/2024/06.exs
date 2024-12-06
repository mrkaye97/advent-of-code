defmodule Solution do
  import Common.Input
  import Common.Output

  @guard_symbols [">", "<", "^", "v"]

  def parse_input(input) do
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

  def rotate(current_direction) do
    case current_direction do
      ">" -> "v"
      "^" -> ">"
      "<" -> "^"
      "v" -> "<"
    end
  end

  def get_value({row, col}, grid) do
    grid |> Enum.at(row, []) |> Enum.at(col)
  end

  def propose_move({row, col}, grid) do
    {r, c, is_escaped} =
      case get_value({row, col}, grid) do
        ">" -> {row, col + 1, col == length(grid) - 1}
        "<" -> {row, col - 1, col == 0}
        "^" -> {row - 1, col, row == 0}
        "v" -> {row + 1, col, row == length(grid) - 1}
      end

    {r, c, get_value({r, c}, grid), is_escaped}
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
    current_value = get_value({row, col}, grid)

    {proposed_row, proposed_col, proposed_value, is_escaped} = propose_move({row, col}, grid)

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
        MapSet.put(visited, {proposed_row, proposed_col})
      else
        visited
      end

    if accepted do
      {proposed_row, proposed_col, new_grid, is_escaped, new_visited}
    else
      {row, col, new_grid, is_escaped, new_visited}
    end
  end

  def part_1(input) do
    starting_position = input[:guard_starting_position]
    grid = input[:grid]
    visited = MapSet.new([starting_position])

    Enum.reduce_while(
      1..10000,
      {starting_position, grid, visited},
      fn _, {starting_position, grid, visited} ->
        {
          row,
          col,
          new_grid,
          is_escaped,
          visited
        } = process_move(starting_position, grid, visited)

        if is_escaped do
          {:halt, MapSet.size(visited)}
        else
          {:cont, {{row, col}, new_grid, visited}}
        end
      end
    )
  end

  def part_2(input) do
    input
  end

  def main do
    data = read_input(2024, 06) |> parse_input()

    run_solution(1, &part_1/1, data)
    # run_solution(2, &part_2/1, data)
  end
end

Solution.main()