defmodule Solution do
  import Common.Output

  defp parse_input() do
    day = String.pad_leading(Integer.to_string(2), 2, "0")

    "data/#{2025}/#{day}.txt"
    |> File.read!()
    |> String.split(",", trim: true)
    |> Enum.map(fn pair -> String.split(pair, "-") |> Enum.map(&String.to_integer/1) end)
  end

  defp split_every_n(string, n) do
    xs = String.graphemes(string)
    chunk_size = div(length(xs), n)

    Enum.chunk_every(xs, chunk_size)
    |> Enum.map(fn s -> Enum.join(s, "") end)
  end

  defp all_elements_same?(list) do
    case list do
      [] -> true
      _ -> Enum.count(Enum.uniq(list)) == 1
    end
  end

  defp has_repeats?(num, factors) do
    str = Integer.to_string(num)

    factors
    |> Enum.filter(fn f -> rem(String.length(str), f) == 0 end)
    |> Enum.map(fn factor ->
      str
      |> split_every_n(factor)
      |> all_elements_same?()
    end)
    |> Enum.any?()
  end

  defp part_1(input) do
    input
    |> Enum.map(fn [lo, hi] ->
      Enum.reduce(lo..hi, 0, fn num, acc ->
        if has_repeats?(num, [2]) do
          acc + num
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
  end

  defp part_2(input) do
    input
    |> Enum.map(fn [lo, hi] ->
      Enum.reduce(lo..hi, 0, fn num, acc ->
        if has_repeats?(num, 2..max(2, length(Integer.digits(num)))) do
          acc + num
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
  end

  def main do
    data = parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
