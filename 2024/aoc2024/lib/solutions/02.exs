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

  def is_valid(line) do
    result =
      line
      |> Enum.reduce({0, nil, nil}, fn current, {num_failures, previous, trend} ->
        current_trend = determine_trend(current, previous)

        is_safe = check_is_safe(current, previous)
        trend_continuing = trend == nil or current_trend == trend

        is_failure = not (trend_continuing and is_safe)

        {num_failures + if(is_failure, do: 1, else: 0), current, current_trend}
      end)

    if elem(result, 0) == 0 do
      1
    else
      0
    end
  end

  def remove_each_element(list) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {_, index} ->
      list
      |> Enum.with_index()
      |> Enum.reject(fn {_value, i} -> i == index end)
      |> Enum.map(&elem(&1, 0))
    end)
  end

  def part_1(input) do
    input
    |> Enum.map(&is_valid/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  def part_2(input) do
    input
    |> Enum.map(&remove_each_element/1)
    |> Enum.map(fn x ->
      x |> Enum.map(fn y -> is_valid(y) end) |> Enum.any?(fn x -> x == 1 end)
    end)
    |> Enum.map(fn x -> if x, do: 1, else: 0 end)
    |> Enum.sum()
    |> IO.inspect()
  end

  def main do
    data = read()

    part_1(data)
    part_2(data)
  end
end

Solution.main()
