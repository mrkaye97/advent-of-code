defmodule Common.Grid do
  def new(input) do
    input
    # reverse the rows so y=0 is at the bottom
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {row, y}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, x}, acc2 ->
        Map.put(acc2, {x, y}, cell)
      end)
    end)
  end

  def get(grid, {x, y}, default \\ nil) do
    Map.get(grid, {x, y}, default)
  end

  def set(grid, {x, y}, value) do
    Map.put(grid, {x, y}, value)
  end

  def remove(grid, {x, y}) do
    Map.delete(grid, {x, y})
  end

  def find_neighbors(grid, {x, y}) do
    dirs = %{
      SW: {x - 1, y - 1},
      W: {x - 1, y},
      NW: {x - 1, y + 1},
      S: {x, y - 1},
      N: {x, y + 1},
      SE: {x + 1, y - 1},
      E: {x + 1, y},
      NE: {x + 1, y + 1}
    }

    dirs
    |> Enum.map(fn {dir, coords} -> {dir, get(grid, coords)} end)
    |> Map.new()
  end
end
