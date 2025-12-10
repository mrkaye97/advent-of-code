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

    Enum.reduce(input, 0, fn {x1, y1}, acc ->
      Enum.reduce(input, acc, fn {x2, y2}, acc ->
        cond do
          x1 < x2 ->
            cond do
              Topo.contains?(polygon, %Geo.Polygon{
                coordinates: [
                  cond do
                    y1 < y2 ->
                      [
                        {x1 + 0.5, y1 + 0.5},
                        {x2 - 0.5, y1 + 0.5},
                        {x2 - 0.5, y2 - 0.5},
                        {x1 + 0.5, y2 - 0.5}
                      ]

                    true ->
                      [
                        {x1 + 0.5, y1 - 0.5},
                        {x2 - 0.5, y1 - 0.5},
                        {x2 - 0.5, y2 + 0.5},
                        {x1 + 0.5, y2 + 0.5}
                      ]
                  end
                ]
              }) ->
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
