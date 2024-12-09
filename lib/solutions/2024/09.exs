defmodule Solution do
  import Common.Output
  import Common.Enum

  defp parse_input(input) do
    input
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  defp explode_input(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      is_even = rem(index, 2) == 0
      to_duplicate = if is_even, do: Integer.to_string(Integer.floor_div(index, 2)), else: "."

      String.duplicate(to_duplicate, value)
    end)
    |> Enum.join("")
    |> String.split("", trim: true)
  end

  defp is_valid(input) do
    first_blank = Enum.find_index(input, fn x -> x == "." end)

    input
    |> Enum.with_index()
    |> Enum.all?(fn {x, ix} -> ix >= first_blank and x == "." end)
  end

  defp replace_blank(input) do
    first_blank = Enum.find_index(input, fn x -> x == "." end)
    last_value = length(input) - 1 - Enum.find_index(Enum.reverse(input), fn x -> x != "." end)

    swap(input, first_blank, last_value)
  end

  defp part_1(input) do
    exploded = explode_input(input)

    Enum.reduce_while(0..(length(exploded) + 1), exploded, fn _ix, acc ->
      new = replace_blank(acc)

      if is_valid(new) do
        {:halt, new}
      else
        {:cont, new}
      end
    end)
    |> Enum.filter(fn x -> x != "." end)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {value, index}, acc ->
      acc + String.to_integer(value) * index
    end)
  end

  defp part_2(input) do
    input
  end

  def main do
    data =
      "data/2024/09.txt"
      |> File.read!()
      |> parse_input()

    run_solution(1, &part_1/1, data)
    # run_solution(2, &part_2/1, data)
  end
end

Solution.main()
