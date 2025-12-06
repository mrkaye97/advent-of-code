defmodule Solution do
  import Common.Output

  defp parse_input() do
    day = String.pad_leading(Integer.to_string(5), 2, "0")

    [fresh, available] =
      "data/#{2025}/#{day}.txt"
      |> File.read!()
      |> String.split(~r{\n\n}, trim: false)
      |> Enum.map(&String.split(&1, ~r{\n}, trim: true))

    fresh =
      fresh
      |> Enum.map(fn rng ->
        String.split(rng, "-") |> Enum.map(&String.to_integer/1)
      end)

    available = Enum.map(available, &String.to_integer/1)

    [fresh, available]
  end

  defp part_1(input) do
    [fresh, available] = input

    available
    |> Enum.filter(fn item ->
      fresh
      |> Enum.reduce_while(false, fn [lo, hi], _ ->
        cond do
          item <= hi and item >= lo -> {:halt, true}
          true -> {:cont, false}
        end
      end)
    end)
    |> length()
  end

  defp between?(x, [lo, hi]) do
    x >= lo and x <= hi
  end

  defp do_ranges_overlap?([a_lo, a_hi], [b_lo, b_hi]) do
    between?(a_lo, [b_lo, b_hi]) or between?(a_hi, [b_lo, b_hi]) or between?(b_lo, [a_lo, a_hi]) or
      between?(b_hi, [a_lo, a_hi])
  end

  defp merge_ranges(ranges) do
    [
      ranges |> Enum.map(fn [lo, _] -> lo end) |> Enum.min(),
      ranges |> Enum.map(fn [_, hi] -> hi end) |> Enum.max()
    ]
  end

  defp part_2(input) do
    [fresh, _] = input

    fresh
    |> Enum.reduce([], fn curr, acc ->
      ranges = Enum.map(acc, fn r -> {r, do_ranges_overlap?(r, curr)} end)
      overlapping = Enum.filter(ranges, fn {_, q} -> q end) |> Enum.map(fn {r, _} -> r end)
      non_overlapping = Enum.filter(ranges, fn {_, q} -> !q end) |> Enum.map(fn {r, _} -> r end)

      cond do
        length(overlapping) > 0 ->
          [merge_ranges([curr | overlapping]) | non_overlapping]

        true ->
          [curr | acc]
      end
    end)
    |> Enum.sum_by(fn [lo, hi] ->
      Enum.count(lo..hi)
    end)
  end

  def main do
    input = parse_input()

    run_solution(1, &part_1/1, input)
    run_solution(2, &part_2/1, input)
  end
end

Solution.main()
