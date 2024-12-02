defmodule Solution do
  def extract_valid_mul_statements(input) do
    regex = ~r/mul\(\d{1,3},\d{1,3}\)/

    Regex.scan(regex, input) |> List.flatten()
  end

  def eval_mul_statement(statement) do
    statement
    |> String.replace(~r/(mul\(|\))/, "")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.product()
  end

  def aggregate_muls_in_string(input) do
    input
    |> extract_valid_mul_statements()
    |> Enum.map(&eval_mul_statement/1)
    |> Enum.sum()
  end

  def extract_enabled_substrings(input) do
    input
    |> String.split(~r/(?=(do\(\)|don't\(\)))/)
    |> Enum.with_index()
    |> Enum.filter(fn {x, ix} ->
      ix == 0 or String.slice(x, 0, 4) == "do()"
    end)
    |> Enum.map(fn {x, _} -> x end)
    |> Enum.join("")
  end

  def part_1(input) do
    input
    |> aggregate_muls_in_string()
    |> Integer.to_string()
  end

  def part_2(input) do
    input
    |> extract_enabled_substrings()
    |> aggregate_muls_in_string()
    |> Integer.to_string()
  end

  def main do
    input = File.read!("data/2024/03.txt")

    IO.puts("Part I: " <> part_1(input))
    IO.puts("Part II: " <> part_2(input))
  end
end

Solution.main()
