defmodule Solution do
  def parse_input_part_1(input) do
    regex = ~r/mul\(\d{1,3},\d{1,3}\)/

    Regex.scan(regex, input) |> List.flatten()
  end

  def parse_input_part_2(input) do
    String.split(input, ~r/(?=(do\(\)|don't\(\)))/)
    |> Enum.with_index()
    |> Enum.filter(fn {x, ix} ->
      ix == 0 or String.slice(x, 0, 4) == "do()"
    end)
    |> Enum.map(fn {x, _} ->
      x
    end)
    |> Enum.join("")
    |> parse_input_part_1()
    |> Enum.map(&eval_mul_statement/1)
    |> Enum.sum()
    |> Integer.to_string()
  end

  def eval_mul_statement(statement) do
    statement
    |> String.replace("mul(", "")
    |> String.replace(")", "")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.product()
  end

  def part_1(input) do
    input
    |> parse_input_part_1()
    |> Enum.map(&eval_mul_statement/1)
    |> Enum.sum()
    |> Integer.to_string()
  end

  def part_2(input) do
    input
    |> parse_input_part_2()
  end

  def main do
    data =
      "data/2024/03.txt"
      |> File.read!()

    IO.puts("Part I: " <> part_1(data))
    IO.puts("Part II: " <> part_2(data))
  end
end

Solution.main()
