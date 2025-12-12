defmodule Solution do
  import Common.Input
  import Common.Output
  alias Common.Misc
  import Common.Enum
  alias Common.LinAlg

  defp parse_input(input) do
    input
    |> Enum.map(fn x -> String.split(x, ~r/(?<=\])\s+(?=\()|(?<=\))\s+(?=\{)/) end)
    |> Enum.map(fn row ->
      lights = row |> Enum.at(0) |> String.slice(1..-2//1)

      wiring =
        row
        |> Enum.at(1)
        |> String.split(" ")
        |> Enum.map(fn combo ->
          combo |> String.slice(1..-2//1) |> String.split(",") |> Enum.map(&String.to_integer/1)
        end)

      joltage =
        row
        |> Enum.at(2)
        |> String.slice(1..-2//1)
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      {lights, wiring, joltage}
    end)
  end

  defp part_1(input) do
    input
    |> Enum.map(fn {lights, wiring, _} ->
      sol =
        String.split(lights, "", trim: true)
        |> Enum.map(fn x -> Misc.boolean_to_integer(x == "#") end)

      mat =
        Enum.map(wiring, fn row ->
          Enum.map(0..(String.length(lights) - 1), fn ix ->
            Misc.boolean_to_integer(Enum.member?(row, ix))
          end)
        end)
        |> transpose()

      {rref, sol, free} = LinAlg.rref(mat, sol)

      LinAlg.find_all_solutions(rref, sol, free)
      |> Enum.map(fn {_, ct} -> ct end)
      |> Enum.min()
    end)
    |> Enum.sum()
  end

  defp part_2(input) do
    input
    |> Enum.map(fn {_, wiring, joltages} ->
      mat =
        Enum.map(wiring, fn row ->
          Enum.map(0..(length(joltages) - 1), fn ix ->
            Misc.boolean_to_integer(Enum.member?(row, ix))
          end)
        end)
        |> transpose()

      {rref, sol, free} = LinAlg.rref_real(mat, joltages)

      LinAlg.find_nonnegative_solutions_real(rref, sol, free, 1000)
      |> Enum.map(fn {_, ct} -> round(ct) end)
      |> Enum.min()
    end)
    |> Enum.sum()
  end

  def main do
    data = read_input(2025, 10) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
