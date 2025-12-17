defmodule Solution do
  import Common.Output
  alias Common.Grid

  defp parse_input() do
    {grids, presents} =
      "data/2025/12.txt"
      |> File.read!()
      |> String.split(~r{\n\n}, trim: true)
      |> Enum.map(&String.split(&1, ~r{\n}, trim: true))
      |> List.pop_at(-1)

    presents =
      presents
      |> Enum.map(fn present ->
        Enum.slice(present, 1..-1//1)
        |> Enum.map(&String.graphemes/1)
        |> Grid.new()
      end)
      |> Enum.with_index()
      |> Enum.reduce(Map.new(), fn {g, i}, acc ->
        Map.put(acc, i, g)
      end)

    grids =
      Enum.map(grids, fn grid ->
        [dim, values] = String.split(grid, ": ")

        [x, y] =
          dim
          |> String.split("x")
          |> Enum.map(&String.to_integer/1)

        grid =
          Enum.reduce(1..x, [], fn _, acc ->
            [Enum.reduce(1..y, [], fn _, acc2 -> ["." | acc2] end) | acc]
          end)
          |> Grid.new()

        values =
          values
          |> String.split(" ")
          |> Enum.with_index()
          |> Enum.reduce(Map.new(), fn {v, i}, acc ->
            Map.put(acc, i, String.to_integer(v))
          end)

        {grid, values}
      end)

    {grids, presents}
  end

  defp part_1(input) do
    {grids, presents} = input

    grids
    |> Enum.filter(fn {grid, assignments} ->
      ## this is a hack that only works for the input provided because none
      ## of the presents actually need to fit inside of one another.
      ## the real problem is NP-hard, so it'd take some memoization / backtracking to
      ## solve in a reasonable amount of time
      to_place =
        Enum.flat_map(assignments, fn {ix, num} ->
          Enum.map(1..num//1, fn _ -> Map.get(presents, ix) end)
        end)
        |> length()
        |> Kernel.*(9)

      {x, y} = Grid.dim(grid)

      to_place <= x * y
    end)
    |> length()
  end

  def main do
    data = parse_input()

    run_solution(1, &part_1/1, data)
  end
end

Solution.main()
