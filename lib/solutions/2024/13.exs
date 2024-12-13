defmodule Solution do
  import Common.Output

  @digits_regex ~r/\d+/
  @button_regex ~r/Button (\w)/

  defp modify_prize(prize, part) do
    if part == 2 do
      prize + 10_000_000_000_000
    else
      prize
    end
  end

  defp parse_input(input, part) do
    input
    |> Enum.map(fn block ->
      [a, b, prize] = String.split(block, "\n")

      buttons_raw =
        [a, b]
        |> Enum.map(fn button ->
          [_, name] = Regex.run(@button_regex, button)

          [x, y] =
            Regex.scan(@digits_regex, button)
            |> List.flatten()
            |> Enum.map(&String.to_integer/1)

          {
            x,
            y,
            name
          }
        end)

      [prize_x, prize_y] =
        Regex.scan(@digits_regex, prize)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)

      buttons =
        buttons_raw
        |> Enum.reduce(%{}, fn {x, y, button}, acc ->
          Map.put(acc, button, %{x: x, y: y})
        end)

      %{
        buttons: buttons,
        prize: %{x: modify_prize(prize_x, part), y: modify_prize(prize_y, part)}
      }
    end)
  end

  def is_integerish?(number) do
    rounded = round(number)

    abs(number - rounded) < 0.005
  end

  defp solve_system(input) do
    ax =
      Nx.tensor(
        [
          [input[:buttons]["A"][:x], input[:buttons]["B"][:x]],
          [input[:buttons]["A"][:y], input[:buttons]["B"][:y]]
        ],
        type: :f64
      )

    b = Nx.tensor([input[:prize][:x], input[:prize][:y]], type: :f64)

    Nx.LinAlg.solve(ax, b)
    |> Nx.to_list()
    |> Enum.map(fn val ->
      if is_integerish?(val) do
        round(val)
      else
        nil
      end
    end)
  end

  defp part_1(input) do
    input
    |> parse_input(1)
    |> Enum.map(&solve_system/1)
    |> Enum.filter(fn [x, y] -> x != nil and y != nil end)
    |> Enum.reduce(0, fn [x, y], acc -> acc + 3 * x + y end)
  end

  defp part_2(input) do
    input
    |> parse_input(2)
    |> Enum.map(&solve_system/1)
    |> Enum.filter(fn [x, y] -> x != nil and y != nil end)
    |> Enum.reduce(0, fn [x, y], acc -> acc + 3 * x + y end)
  end

  def main do
    data =
      "data/2024/13.txt" |> File.read!() |> String.split(~r{\n\n}, trim: true)

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
