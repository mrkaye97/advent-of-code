defmodule Common.Grid do
  @east :E
  @west :W
  @north :N
  @south :S
  @northeast :NE
  @northwest :NW
  @southeast :SE
  @southwest :SW

  @dirs [
    @north,
    @south,
    @east,
    @west,
    @northeast,
    @northwest,
    @southeast,
    @southwest
  ]

  def north, do: @north
  def south, do: @south
  def east, do: @east
  def west, do: @west
  def northeast, do: @northeast
  def northwest, do: @northwest
  def southeast, do: @southeast
  def southwest, do: @southwest

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

  def find(grid, value) do
    grid
    |> Enum.filter(fn {_pos, cell_value} -> cell_value == value end)
    |> Enum.map(fn {pos, _cell_value} -> pos end)
    |> Enum.at(0)
  end

  def neighbor_pos({x, y}, direction) do
    case direction do
      @north -> {x, y + 1}
      @south -> {x, y - 1}
      @east -> {x + 1, y}
      @west -> {x - 1, y}
      @northeast -> {x + 1, y + 1}
      @northwest -> {x - 1, y + 1}
      @southeast -> {x + 1, y - 1}
      @southwest -> {x - 1, y - 1}
    end
  end

  def find_neighbor(grid, {x, y}, direction) do
    case direction do
      @north -> get(grid, {x, y + 1})
      @south -> get(grid, {x, y - 1})
      @east -> get(grid, {x + 1, y})
      @west -> get(grid, {x - 1, y})
      @northeast -> get(grid, {x + 1, y + 1})
      @northwest -> get(grid, {x - 1, y + 1})
      @southeast -> get(grid, {x + 1, y - 1})
      @southwest -> get(grid, {x - 1, y - 1})
    end
  end

  def find_neighbors(grid, {x, y}) do
    @dirs
    |> Enum.map(fn dir -> {dir, find_neighbor(grid, {x, y}, dir)} end)
    |> Map.new()
  end
end
