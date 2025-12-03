defmodule Solution do
  import Common.Input
  import Common.Output

  defp parse_input(input) do
    input
    |> Enum.map(fn ln ->
      ln |> String.graphemes() |> Enum.map(fn x -> String.to_integer(x) end)
    end)
  end

  defp argmax(xs) do
    Enum.find_index(xs, fn x -> x == Enum.max(xs) end)
  end

  defp split_at_pivot(xs, pivot) do
    {left, [_max | right]} = Enum.split(xs, pivot)

    [left, right]
  end

  defp compute_joltage(bank, n) do
    pivot = argmax(bank)
    value = Enum.at(bank, pivot)

    bank
    |> split_at_pivot(pivot)
    |> Enum.map(fn x ->
      cond do
        Enum.empty?(x) -> nil
        true -> Enum.max(x)
      end
    end)
    |> Enum.with_index()
    |> Enum.map(fn {x, i} ->
      cond do
        is_nil(x) -> nil
        i == 0 -> String.to_integer(Integer.to_string(x) <> Integer.to_string(value))
        i == 1 -> String.to_integer(Integer.to_string(value) <> Integer.to_string(x))
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.max()
  end

  defp part_1(input) do
    Enum.sum_by(input, fn x -> compute_joltage(x, 2) end)
  end

  defp part_2(input) do
    # find the leftmost biggest number with at least n-1 values to the right of it
    # find the leftmost biggest number after that with at least n-2 values to the right of it
    # ...
    input
    |> Enum.map(fn bank ->
      Enum.reduce
      candidates = Enum.slice(bank, 1..(length(bank) - 12))
      max_value = Enum.max(bank)
      max_index = argmax(bank)

      IO.inspect({candidates, max_value, max_index})
    end)

    1
  end

  def main do
    data = read_input(2025, 03) |> parse_input()

    IO.inspect(data)

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
