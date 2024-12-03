defmodule Solution do
  @max_numeric_diff_allowed 3

  defp read do
    "data/2024/02.txt"
    |> File.read!()
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp check_is_safe(curr, prev) do
    if prev == nil,
      do: true,
      else: abs(curr - prev) <= @max_numeric_diff_allowed and curr != prev
  end

  defp determine_trend(current, previous) do
    cond do
      previous == nil -> nil
      current > previous -> :up
      current < previous -> :down
      true -> nil
    end
  end

  defp check_line_validity(line, num_failures_allowed) do
    {failures, _, _} =
      line
      |> Enum.reduce({0, nil, nil}, fn current, {num_failures, previous, trend} ->
        current_trend = determine_trend(current, previous)

        is_safe = check_is_safe(current, previous)
        trend_continuing = trend == nil or current_trend == trend

        is_failure = not (trend_continuing and is_safe)

        next_num_failures = num_failures + if(is_failure, do: 1, else: 0)
        next_trend = trend || current_trend

        next_value =
          if is_failure and num_failures < num_failures_allowed, do: previous, else: current

        {next_num_failures, next_value, next_trend}
      end)

    failures
  end

  defp compute_num_valid_lines(input, num_failures_allowed) do
    Enum.reduce(input, 0, fn line, acc ->
      failures =
        min(
          check_line_validity(line, num_failures_allowed),
          check_line_validity(Enum.reverse(line), num_failures_allowed)
        )

      acc + if(failures <= num_failures_allowed, do: 1, else: 0)
    end)
  end

  def main do
    data = read()

    IO.puts("Part I: " <> Integer.to_string(compute_num_valid_lines(data, 0)))
    IO.puts("Part II: " <> Integer.to_string(compute_num_valid_lines(data, 1)))
  end
end

Solution.main()
