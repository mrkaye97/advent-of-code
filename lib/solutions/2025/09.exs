defmodule Solution do
  import Common.Input
  import Common.Output

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

  defp part_2(input) do
    polygon = %Geo.Polygon{coordinates: [input]}

    input =
      Enum.sort(input, fn {x1, y1}, {x2, y2} ->
        cond do
          x1 < x2 -> true
          x1 == x2 and y1 < y2 -> true
          true -> false
        end
      end)

    min_x = input |> Enum.map(fn {x, _} -> x end) |> Enum.min()
    max_x = input |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    min_y = input |> Enum.map(fn {_, y} -> y end) |> Enum.min()
    max_y = input |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    IO.inspect({min_x, max_x, min_y, max_y}, label: "Bounds")

    Enum.reduce(input, 0, fn {x1, y1}, acc ->
      IO.puts("Progress: (#{x1}, #{y1}) out of (#{max_x}, #{max_y}) ")

      Enum.reduce(input, acc, fn {x2, y2}, acc ->
        cond do
          x1 < x2 ->
            cond do
              Enum.all?(
                Enum.map([{x1, y1}, {x2, y1}, {x2, y2}, {x1, y2}], fn {x, y} ->
                  pt = %Geo.Point{coordinates: {x, y}}

                  Topo.contains?(polygon, pt) or Topo.intersects?(polygon, pt)
                end)
              ) ->
                max((abs(x2 - x1) + 1) * (abs(y2 - y1) + 1), acc)

              true ->
                acc
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
