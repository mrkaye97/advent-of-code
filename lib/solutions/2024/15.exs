defmodule Solution do
  import Common.Output

  defp parse_input(input) do
    [grid, directions] =
      input
      |> String.split(~r{\n\n}, trim: true)

    %{
      :grid =>
        grid
        |> String.split(~r{\n}, trim: true)
        |> Enum.map(&String.graphemes/1)
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {row, row_index}, acc ->
          row
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {cell, col_index}, acc ->
            Map.put(acc, {row_index, col_index}, cell)
          end)
        end),
      :directions =>
        directions
        |> String.split(~r{\n}, trim: true)
        |> Enum.map(&String.graphemes/1)
        |> List.flatten()
    }
  end

  defp propose_new_coordinations(position, direction) do
    {dx, dy} =
      case direction do
        "^" -> {-1, 0}
        "v" -> {1, 0}
        ">" -> {0, 1}
        "<" -> {0, -1}
      end

    {dx + elem(position, 0), dy + elem(position, 1)}
  end

  defp shift(grid, value, prev, curr) do
    grid
    |> Map.put(
      prev,
      "."
    )
    |> Map.put(
      curr,
      value
    )
  end

  defp find_terminal_square(grid, position, direction) do
    Enum.reduce_while(1..100, position, fn _, position ->
      proposal = propose_new_coordinations(position, direction)

      cond do
        grid[proposal] == "#" ->
          {:halt, {proposal, false}}

        grid[proposal] == "." ->
          {:halt, {proposal, true}}

        grid[proposal] == "O" ->
          {:cont, proposal}
      end
    end)
  end

  defp create_range(starting_position, ending_position) do
    dx = elem(ending_position, 1) - elem(starting_position, 1)
    dy = elem(ending_position, 0) - elem(starting_position, 0)

    if dx == 0 do
      Enum.map(0..dy, &{elem(starting_position, 0) + &1, elem(starting_position, 1)})
    else
      Enum.map(0..dx, &{elem(starting_position, 0), elem(starting_position, 1) + &1})
    end
  end

  defp process_move(grid, position, direction) do
    proposal = propose_new_coordinations(position, direction)

    cond do
      grid[proposal] == "." ->
        {shift(grid, grid[position], position, proposal), proposal}

      grid[proposal] == "#" ->
        {grid, position}

      grid[proposal] == "O" ->
        {terminal, can_move} = find_terminal_square(grid, proposal, direction)

        if can_move do
          range = Enum.reverse(create_range(position, terminal))

          grid =
            range
            |> Enum.with_index()
            |> Enum.reduce_while(grid, fn {position, index}, grid ->
              if index == 0 do
                {:cont, grid}
              else
                {:cont, shift(grid, grid[position], position, Enum.at(range, index - 1))}
              end
            end)

          {grid, proposal}
        else
          {grid, position}
        end
    end
  end

  defp print_grid(grid) do
    coords =
      grid
      |> Map.keys()
      |> Enum.sort()

    max_col = coords |> Enum.map(&elem(&1, 1)) |> Enum.max()

    coords
    |> Enum.with_index()
    |> Enum.reduce("", fn {{row, col}, ix}, acc ->
      if rem(ix, max_col + 1) == 0 do
        acc <> "\n" <> grid[{row, col}]
      else
        acc <> grid[{row, col}]
      end
    end)
    |> IO.puts()
  end

  defp compute_coordinate(position) do
    {y, x} = position

    100 * y + x
  end

  defp part_1(input) do
    starting_position =
      input[:grid]
      |> Enum.find(fn {_k, v} -> v == "@" end)
      |> elem(0)

    {grid, _pos} =
      Enum.reduce_while(
        input[:directions],
        {input[:grid], starting_position},
        fn direction, {grid, robot} ->
          {:cont, process_move(grid, robot, direction)}
        end
      )

    grid
    |> Enum.reduce(0, fn {coords, value}, acc ->
      if value == "O" do
        acc + compute_coordinate(coords)
      else
        acc
      end
    end)
  end

  defp part_2(input) do
    input
  end

  def main do
    data = "data/2024/15.txt" |> File.read!() |> parse_input()

    run_solution(1, &part_1/1, data)
    # run_solution(2, &part_2/1, data)
  end
end

Solution.main()
