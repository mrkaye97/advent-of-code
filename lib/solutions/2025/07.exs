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

    Enum.reduce_while(0..height, {grid, [Grid.find(grid, "S"), 0]}, fn _, {g, row, count} ->
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
            |> Enum.reduce({g, [], count}, fn {coords, val}, {acc, next, c} ->
              cond do
                val == "^" ->
                  east_neighbor = Grid.find_neighbor_pos(coords, Grid.east())
                  west_neighbor = Grid.find_neighbor_pos(coords, Grid.west())

                  {acc
                   |> Grid.set(east_neighbor, "|")

                true ->
                  {acc |> Grid.set(coords, "|"), [coords | next], c}
              end
            end)

          {:cont, {g, next, c}}
      end
      |> IO.inspect()
    end)

    # |> Grid.pretty_print()
    # |> Enum.count(fn {coords, value} ->
    #   value == "|"
    # end)
  end

  defp part_2(input) do
    input
  end

  def main do
    data = read_input(2025, 07) |> parse_input()

    IO.inspect(data)

    run_solution(1, &part_1/1, data)
    # run_solution(2, &part_2/1, data)
  end
end

Solution.main()
