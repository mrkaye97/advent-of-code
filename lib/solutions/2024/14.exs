defmodule Solution do
  import Common.Input
  import Common.Output

  @dimensions %{x: 101, y: 103}
  @iters 100

  defp parse_input(input) do
    input
    |> Enum.map(fn robot ->
      [pos, vel] = String.split(robot, " ")

      [x_pos, y_pos] =
        pos |> String.replace("p=", "") |> String.split(",") |> Enum.map(&String.to_integer/1)

      [x_vel, y_vel] =
        vel |> String.replace("v=", "") |> String.split(",") |> Enum.map(&String.to_integer/1)

      %{
        position: %{x: x_pos, y: y_pos},
        velocity: %{x: x_vel, y: y_vel}
      }
    end)
  end

  defp wrap(position, direction) do
    dim = if direction == :x, do: @dimensions[:x], else: @dimensions[:y]

    if position < 0, do: dim + position, else: rem(position, dim)
  end

  defp apply_transition(robot) do
    %{
      position: %{
        x: wrap(robot.position.x + robot.velocity.x, :x),
        y: wrap(robot.position.y + robot.velocity.y, :y)
      },
      velocity: robot.velocity
    }
  end

  defp assign_quadrant(position) do
    x_threshold = (@dimensions[:x] - 1) / 2
    y_threshold = (@dimensions[:y] - 1) / 2

    cond do
      position.x == x_threshold || position.y == y_threshold -> nil
      position.x < x_threshold && position.y < y_threshold -> 1
      position.x > x_threshold && position.y < y_threshold -> 2
      position.x < x_threshold && position.y > y_threshold -> 3
      position.x > x_threshold && position.y > y_threshold -> 4
      true -> nil
    end
  end

  defp part_1(input) do
    Enum.reduce_while(1..@iters, input, fn _, input ->
      {:cont, Enum.map(input, &apply_transition/1)}
    end)
    |> Enum.map(&assign_quadrant(&1.position))
    |> Enum.filter(&(&1 != nil))
    |> Enum.frequencies()
    |> Enum.reduce(1, fn {_k, v}, acc -> acc * v end)
  end

  defp has_tree?(state) do
    biggest_component_size =
      state
      |> Enum.reduce(Graph.new(type: :undirected), fn robot, graph ->
        Graph.add_vertex(graph, robot.position)

        state
        |> Enum.reduce(graph, fn robot2, graph2 ->
          if abs(robot.position.x - robot2.position.x) <= 1 &&
               abs(robot.position.y - robot2.position.y) <= 1,
             do: Graph.add_edge(graph2, robot.position, robot2.position),
             else: graph2
        end)
      end)
      |> Graph.components()
      |> Enum.map(&Enum.count(&1))
      |> Enum.max()

    biggest_component_size > 50
  end

  defp part_2(input) do
    ## IMPORTANT: This could run forever if there is never a tree found
    Enum.reduce_while(Stream.iterate(1, &(&1 + 1)), input, fn ix, input ->
      state = Enum.map(input, &apply_transition/1)

      if has_tree?(state), do: {:halt, ix}, else: {:cont, state}
    end)
  end

  def main do
    data = read_input(2024, 14) |> parse_input()

    run_solution(1, &part_1/1, data)
    run_solution(2, &part_2/1, data)
  end
end

Solution.main()
