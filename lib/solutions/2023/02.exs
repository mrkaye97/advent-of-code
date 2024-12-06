defmodule Solution do
  import Common.Input

  @color_maxima %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  defp parse_input(input) do
    input
    |> Enum.map(fn line ->
      [game, data] = String.split(line, ": ")

      game_id = game |> String.replace("Game ", "") |> String.to_integer()

      draws =
        data
        |> String.split("; ")
        |> Enum.map(fn round ->
          String.split(round, ", ")
          |> Enum.map(fn draw ->
            [count, color] = String.split(draw, " ")
            {color, String.to_integer(count)}
          end)
        end)
        |> Enum.map(fn round ->
          round
          |> Enum.into(%{})
        end)

      {game_id, draws}
    end)
  end

  defp part_1(input) do
    input
    |> Enum.filter(fn {_, draws} ->
      draws
      |> Enum.map(fn draw ->
        draw
        |> Enum.map(fn {color, count} ->
          @color_maxima[color] >= count
        end)
        |> Enum.all?()
      end)
      |> Enum.all?()
    end)
    |> Enum.map(fn {game_id, _} -> game_id end)
    |> Enum.sum()
  end

  defp part_2(input) do
    input
    |> Enum.map(fn {_, rounds} ->
      rounds
      |> Enum.reduce(fn l, r ->
        Map.merge(l, r, fn _k, l, r ->
          max(l, r)
        end)
      end)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.product()
    end)
    |> Enum.sum()
  end

  def main do
    input = read_input(2023, 02) |> parse_input()

    IO.puts("Part I: " <> part_1(input))
    IO.puts("Part II: " <> part_2(input))
  end
end

Solution.main()
