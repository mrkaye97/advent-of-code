defmodule Solution do
  import Common.Input
  import Common.Output
  alias Common.Grid

  defp parse_input(input) do
    input
    |> Enum.map(fn x -> String.split(x, ",") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn [x, y] -> {x, y} end)
  end

  defp part_1(input) do
    Enum.reduce(input, 0, fn {x1, y1}, acc ->
      Enum.reduce(input, acc, fn {x2, y2}, acc ->
        cond do
          x1 < x2 -> max((abs(x2 - x1) + 1) * (abs(y2 - y1) + 1), acc)
          true -> acc
        end
      end)
    end)
  end

  defp find_nearest({x, y}, lookup_table) do
    {x_to_ys, y_to_xs} = lookup_table

    nearest_y =
      x_to_ys |> Map.get(x) |> Enum.filter(fn y2 -> y2 != y end) |> Enum.sort() |> Enum.at(0)

    nearest_x =
      y_to_xs |> Map.get(y) |> Enum.filter(fn x2 -> x2 != x end) |> Enum.sort() |> Enum.at(0)

    {{nearest_x, y}, {x, nearest_y}}
  end

  defp expand_range({x1, y1}, {x2, y2}) do
    cond do
      x1 == x2 and y1 == y2 -> []
      x1 != x2 and y1 != y2 -> []
      x1 < x2 -> Enum.map(1..(x2 - x1 - 1), fn ix -> {x1 + ix, y1} end)
      x1 > x2 -> Enum.map(1..(x1 - x2 - 1), fn ix -> {x2 + ix, y1} end)
      y1 < y2 -> Enum.map(1..(y2 - y1 - 1), fn ix -> {x1, y1 + ix} end)
      y1 > y2 -> Enum.map(1..(y1 - y2 - 1), fn ix -> {x1, y2 + ix} end)
    end
  end

  defp is_trapped_in_dir(grid, coords, dir) do
    IO.inspect({coords, dir})

    Enum.reduce_while(0..500, {coords, 0}, fn _, {c, ct} ->
      # neighbor = Grid.find_neighbor_pos(c, dir)
      # neighbor_value = Grid.get(grid, neighbor)

      # cond do
      #   is_nil(neighbor_value) -> rem(ct, 2) == 0
      # end

      {:halt, false}
    end)
  end

  defp is_trapped(grid, coords) do
    Enum.all?(
      [Grid.south(), Grid.north(), Grid.east(), Grid.west()]
      |> Enum.map(fn dir ->
        is_trapped_in_dir(grid, coords, dir)
      end)
    )
  end

  defp part_2(input) do
    polygon = %Geo.Polygon{coordinates: [input]} |> IO.inspect()

    Enum.reduce(input, 0, fn {x1, y1}, acc ->
      Enum.reduce(input, acc, fn {x2, y2}, acc ->
        cond do
          x1 < x2 ->
            corners = [{x1, y1}, {x2, y1}, {x2, y2}, {x1, y2}]

            all_corners_in_or_on_polygon =
              Enum.map(corners, fn {x, y} ->
                pt = %Geo.Point{coordinates: {x, y}}

                Topo.contains?(polygon, pt) or Topo.intersects?(polygon, pt)
              end)
              |> Enum.all?()

            cond do
              all_corners_in_or_on_polygon -> max((abs(x2 - x1) + 1) * (abs(y2 - y1) + 1), acc)
              true -> acc
            end

          true ->
            acc
        end
      end)
    end)
  end

  def main do
    data = read_input(2025, 09) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
