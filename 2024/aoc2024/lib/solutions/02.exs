defmodule Solution do
  def read do
    "data/02.txt"
    |> File.read!()
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def check_is_safe(curr, prev) do
    if prev == nil do
      true
    else
      abs(curr - prev) <= 3 and curr != prev
    end
  end

  def determine_trend(current, previous) do
    cond do
      previous == nil -> nil
      current > previous -> "up"
      current < previous -> "down"
      true -> nil
    end
  end

  def part_1(input) do
    input
    |> Enum.map(fn line ->
      line
      |> Enum.reduce({0, nil, nil}, fn current, {num_failures, previous, trend} ->
        current_trend = determine_trend(current, previous)

        is_safe = check_is_safe(current, previous)
        trend_continuing = trend == nil or current_trend == trend

        is_failure = not (trend_continuing and is_safe)

        {num_failures + if(is_failure, do: 1, else: 0), current, trend || current_trend}
      end)
    end)
    |> Enum.map(fn {num_failures, _, _} -> num_failures end)
    |> Enum.reduce(0, fn x, num_failures -> num_failures + if(x == 0, do: 1, else: 0) end)
  end

  def part_2_valid(line) do
    line
    |> Enum.reduce({0, nil, nil}, fn current, {num_failures, previous, trend} ->
      current_trend = determine_trend(current, previous)

      is_safe = check_is_safe(current, previous)
      trend_continuing = trend == nil or current_trend == trend

      is_failure = not (trend_continuing and is_safe)

      if is_failure and num_failures == 0 do
        {1, previous, trend}
      else
        {num_failures + if(is_failure, do: 1, else: 0), current, trend || current_trend}
      end
    end)
  end

  def part_2(input) do
    input
    |> Enum.map(fn line ->
      {ffail, _, _} = part_2_valid(line)
      {bfail, _, _} = part_2_valid(Enum.reverse(line))

      min(ffail, bfail)
    end)
    |> Enum.reduce(0, fn x, num_failures -> num_failures + if(x <= 1, do: 1, else: 0) end)
  end

  def main do
    data = read()

    IO.puts(part_1(data))
    IO.puts(part_2(data))
  end
end

Solution.main()
