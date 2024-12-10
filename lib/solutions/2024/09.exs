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
    |> Enum.flat_map(fn {value, index} ->
      is_even = rem(index, 2) == 0
      id = if is_even, do: Integer.floor_div(index, 2), else: nil

      to_duplicate =
        if is_even,
          do: %{
            value: value,
            id: id
          },
          else: %{
            value: ".",
            id: nil
          }

      List.duplicate(to_duplicate, value)
    end)
  end

  defp replace_blank(input, index) do
    last_value =
      length(input) - 1 - Enum.find_index(Enum.reverse(input), fn x -> x[:value] != "." end)

    swap(input, index, last_value)
  end

  defp replace_blank_2(input, max_id_checked) do
    last_value =
      length(input) - 1 -
        Enum.find_index(Enum.reverse(input), fn x ->
          x[:value] != "." and x[:id] < max_id_checked
        end)

    max_id_checked = Enum.at(input, last_value)[:id]

    index =
      input
      |> Enum.find_index(fn x ->
        x[:id] == "." and x[:value] >= Enum.at(input, last_value)[:value]
      end)

    IO.inspect({input, index, max_id_checked, last_value})

    if index != nil and Enum.at(input, index)[:value] >= Enum.at(input, last_value)[:value] do
      IO.inspect({"Swap result", swap(input, index, last_value)})
      {swap(input, index, last_value), max_id_checked}
    else
      {input, max_id_checked}
    end
  end

  defp part_1(input) do
    exploded = explode_input(input)

    exploded
    |> Enum.with_index()
    |> Enum.reduce_while(exploded, fn {value, ix}, acc ->
      if value[:value] != "." do
        {:cont, acc}
      else
        {:cont, replace_blank(acc, ix)}
      end
    end)
    |> Enum.filter(fn x -> x[:value] != "." end)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {value, index}, acc ->
      acc + value[:id] * index
    end)
  end

  defp part_2(input) do
    exploded =
      input
      |> Enum.with_index()
      |> Enum.map(fn {value, index} ->
        is_even = rem(index, 2) == 0
        id = if is_even, do: Integer.floor_div(index, 2), else: nil

        if is_even,
          do: %{
            value: value,
            id: id
          },
          else: %{
            value: value,
            id: "."
          }
      end)

    exploded
    |> Enum.reduce({exploded, nil}, fn value, {acc, max_id_checked} ->
      if value[:id] != "." do
        {acc, max_id_checked}
      else
        replace_blank_2(acc, max_id_checked)
      end
    end)
    |> IO.inspect()

    # |> Enum.filter(fn {x, _} -> x[:value] != "." end)
    # |> Enum.with_index()
    # |> Enum.reduce(0, fn {value, index}, acc ->
    #   acc + value[:id] * index
    # end)
  end

  def main do
    data =
      "data/2024/09.txt"
      |> File.read!()
      |> parse_input()

    run_solution(1, &part_1/1, data)

    part_2(data)
    # run_solution(2, &part_2/1, data)
  end
end

Solution.main()
