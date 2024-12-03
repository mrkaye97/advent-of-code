defmodule Common.Input do
  def read_input(year, day) do
    day = String.pad_leading(Integer.to_string(day), 2, "0")

    "data/#{year}/#{day}.txt"
    |> File.read!()
    |> String.split(~r{\n}, trim: true)
  end
end
