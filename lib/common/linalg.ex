defmodule Common.LinAlg do
  # Field operations for binary field GF(2)
  defmodule GF2 do
    def is_pivot?(val, _eps), do: val == 1
    def is_zero?(val, _eps), do: val == 0
    def normalize_row(row, _pivot_col, _pivot_val), do: row
    def subtract_rows(row1, row2, factor) do
      if factor == 1 do
        xor_rows(row1, row2)
      else
        row1
      end
    end
    def find_pivot(matrix, col, start_row, _eps) do
      matrix
      |> Enum.drop(start_row)
      |> Enum.with_index(start_row)
      |> Enum.find(fn {row, _} -> Enum.at(row, col) == 1 end)
      |> case do
        nil -> nil
        {_, idx} -> idx
      end
    end

    defp xor_rows(row1, row2) do
      Enum.zip_with(row1, row2, fn a, b -> rem(a + b, 2) end)
    end
  end

  # Field operations for real numbers
  defmodule Real do
    def is_pivot?(val, eps), do: abs(val) > eps
    def is_zero?(val, eps), do: abs(val) <= eps
    def normalize_row(row, _pivot_col, pivot_val) do
      if pivot_val == 0 do
        row
      else
        Enum.map(row, fn val -> val / pivot_val end)
      end
    end
    def subtract_rows(row1, row2, factor) do
      Enum.zip_with(row1, row2, fn a, b -> a - factor * b end)
    end
    def find_pivot(matrix, col, start_row, eps) do
      matrix
      |> Enum.drop(start_row)
      |> Enum.with_index(start_row)
      |> Enum.filter(fn {row, _} -> abs(Enum.at(row, col)) > eps end)
      |> Enum.max_by(fn {row, _} -> abs(Enum.at(row, col)) end, fn -> nil end)
      |> case do
        nil -> nil
        {_, idx} -> idx
      end
    end
  end

  # XOR-based RREF for binary fields (GF(2))
  def rref(matrix, solution) do
    rref_generic(matrix, solution, GF2, 0)
  end

  # Regular Gauss-Jordan elimination for real numbers
  def rref_real(matrix, solution, eps \\ 1.0e-10) do
    rref_generic(matrix, solution, Real, eps)
  end

  # Generic RREF implementation
  defp rref_generic(matrix, solution, field_ops, eps) do
    augmented = Enum.zip_with(matrix, solution, fn row, sol -> row ++ [sol] end)

    n_rows = length(matrix)
    n_cols = length(hd(matrix))

    {reduced, pivot_row} = forward_eliminate(augmented, n_cols, n_rows, 0, 0, field_ops, eps)

    final = backward_eliminate(reduced, n_cols, pivot_row - 1, field_ops, eps)

    {rref_matrix, rref_solution} = split_augmented(final)

    pivot_cols = find_pivot_columns(rref_matrix, n_cols, field_ops, eps)
    free_vars = Enum.to_list(0..(n_cols - 1)) -- pivot_cols

    {rref_matrix, rref_solution, free_vars}
  end

  defp forward_eliminate(matrix, n_cols, n_rows, current_col, current_row, field_ops, eps) do
    if current_col >= n_cols or current_row >= n_rows do
      {matrix, current_row}
    else
      case field_ops.find_pivot(matrix, current_col, current_row, eps) do
        nil ->
          forward_eliminate(matrix, n_cols, n_rows, current_col + 1, current_row, field_ops, eps)

        pivot_row ->
          matrix = swap_rows(matrix, current_row, pivot_row)

          matrix = normalize_pivot_row(matrix, current_row, current_col, field_ops)

          matrix = eliminate_column(matrix, current_row, current_col, field_ops)

          forward_eliminate(matrix, n_cols, n_rows, current_col + 1, current_row + 1, field_ops, eps)
      end
    end
  end

  defp backward_eliminate(matrix, n_cols, current_row, field_ops, eps) do
    if current_row < 0 do
      matrix
    else
      row = Enum.at(matrix, current_row)

      case find_first_pivot(row, n_cols, field_ops, eps) do
        nil ->
          backward_eliminate(matrix, n_cols, current_row - 1, field_ops, eps)

        pivot_col ->
          matrix = eliminate_above(matrix, current_row, pivot_col, field_ops)
          backward_eliminate(matrix, n_cols, current_row - 1, field_ops, eps)
      end
    end
  end

  defp swap_rows(matrix, i, j) do
    if i == j do
      matrix
    else
      row_i = Enum.at(matrix, i)
      row_j = Enum.at(matrix, j)

      matrix
      |> List.replace_at(i, row_j)
      |> List.replace_at(j, row_i)
    end
  end

  defp normalize_pivot_row(matrix, pivot_row, pivot_col, field_ops) do
    row = Enum.at(matrix, pivot_row)
    pivot_val = Enum.at(row, pivot_col)
    normalized_row = field_ops.normalize_row(row, pivot_col, pivot_val)
    List.replace_at(matrix, pivot_row, normalized_row)
  end

  defp eliminate_column(matrix, pivot_row, col, field_ops) do
    pivot = Enum.at(matrix, pivot_row)

    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, idx} ->
      if idx != pivot_row do
        factor = Enum.at(row, col)
        field_ops.subtract_rows(row, pivot, factor)
      else
        row
      end
    end)
  end

  defp eliminate_above(matrix, pivot_row, col, field_ops) do
    pivot = Enum.at(matrix, pivot_row)

    matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, idx} ->
      if idx < pivot_row do
        factor = Enum.at(row, col)
        field_ops.subtract_rows(row, pivot, factor)
      else
        row
      end
    end)
  end

  defp find_first_pivot(row, n_cols, field_ops, eps) do
    row
    |> Enum.take(n_cols)
    |> Enum.with_index()
    |> Enum.find(fn {val, _} -> field_ops.is_pivot?(val, eps) end)
    |> case do
      nil -> nil
      {_, idx} -> idx
    end
  end

  defp split_augmented(augmented) do
    rref_matrix = Enum.map(augmented, fn row -> Enum.drop(row, -1) end)
    rref_solution = Enum.map(augmented, fn row -> List.last(row) end)
    {rref_matrix, rref_solution}
  end

  defp find_pivot_columns(matrix, n_cols, field_ops, eps) do
    matrix
    |> Enum.map(fn row ->
      find_first_pivot(row, n_cols, field_ops, eps)
    end)
    |> Enum.reject(&is_nil/1)
  end

  # Solve with free variables (GF(2))
  def solve_with_free_vars(rref_matrix, rref_solution, free_assignments) do
    n_vars = length(hd(rref_matrix))

    solution = Map.new(free_assignments)

    rref_matrix
    |> Enum.zip(rref_solution)
    |> Enum.reverse()
    |> Enum.reduce(solution, fn {row, rhs}, acc ->
      case find_first_pivot(row, n_vars, GF2, 0) do
        nil ->
          acc

        pivot_col ->
          sum =
            row
            |> Enum.with_index()
            |> Enum.reduce(0, fn {coefficient, idx}, s ->
              if idx != pivot_col and coefficient == 1 do
                rem(s + Map.get(acc, idx, 0), 2)
              else
                s
              end
            end)

          pivot_value = rem(rhs + sum, 2)
          Map.put(acc, pivot_col, pivot_value)
      end
    end)
  end

  # Find all solutions for binary systems
  def find_all_solutions(rref_matrix, rref_solution, free_vars) do
    n_free = length(free_vars)

    0..(Integer.pow(2, n_free) - 1)
    |> Enum.map(fn combo ->
      free_assignments =
        free_vars
        |> Enum.with_index()
        |> Map.new(fn {var, idx} ->
          bit = rem(div(combo, Integer.pow(2, idx)), 2)
          {var, bit}
        end)

      solution = solve_with_free_vars(rref_matrix, rref_solution, free_assignments)

      sum = solution |> Map.values() |> Enum.sum()

      {solution, sum}
    end)
    |> Enum.sort_by(fn {_, sum} -> sum end)
  end

  # Solve real-valued system with specific free variable assignments
  def solve_with_free_vars_real(rref_matrix, rref_solution, free_assignments \\ %{}) do
    n_vars = length(hd(rref_matrix))
    eps = 1.0e-10

    solution = Map.new(free_assignments)

    rref_matrix
    |> Enum.zip(rref_solution)
    |> Enum.reverse()
    |> Enum.reduce(solution, fn {row, rhs}, acc ->
      pivot_col = find_first_pivot(row, n_vars, Real, eps)

      if is_nil(pivot_col) do
        acc
      else
        sum =
          row
          |> Enum.with_index()
          |> Enum.reduce(0, fn {coefficient, idx}, s ->
            if idx != pivot_col do
              s + coefficient * Map.get(acc, idx, 0)
            else
              s
            end
          end)

        pivot_value = rhs - sum
        Map.put(acc, pivot_col, pivot_value)
      end
    end)
  end

  # Find non-negative real solutions by enumerating integer free variable values
  # Returns solutions sorted by sum (smallest first)
  def find_nonnegative_solutions_real(rref_matrix, rref_solution, free_vars, max_free_value \\ 10) do
    n_free = length(free_vars)
    n_vars = length(hd(rref_matrix))

    if n_free == 0 do
      # No free variables - just solve and check if non-negative
      solution = solve_with_free_vars_real(rref_matrix, rref_solution, %{})
      if Enum.all?(0..(n_vars - 1), fn i -> Map.get(solution, i, 0) >= 0 end) do
        sum = solution |> Map.values() |> Enum.sum()
        [{solution, sum}]
      else
        []
      end
    else
      # Enumerate all combinations of free variable values from 0 to max_free_value
      enumerate_combinations(free_vars, max_free_value)
      |> Enum.map(fn free_assignments ->
        solution = solve_with_free_vars_real(rref_matrix, rref_solution, free_assignments)
        {solution, free_assignments}
      end)
      |> Enum.filter(fn {solution, _} ->
        # Keep only solutions where all variables are non-negative
        Enum.all?(0..(n_vars - 1), fn i -> Map.get(solution, i, 0) >= -1.0e-10 end)
      end)
      |> Enum.map(fn {solution, _} ->
        sum = solution |> Map.values() |> Enum.sum()
        {solution, sum}
      end)
      |> Enum.sort_by(fn {_, sum} -> sum end)
    end
  end

  defp enumerate_combinations(free_vars, max_value) do
    n_free = length(free_vars)
    total_combinations = :math.pow(max_value + 1, n_free) |> trunc()

    0..(total_combinations - 1)
    |> Enum.map(fn combo ->
      free_vars
      |> Enum.with_index()
      |> Map.new(fn {var, idx} ->
        value = rem(div(combo, trunc(:math.pow(max_value + 1, idx))), max_value + 1)
        {var, value}
      end)
    end)
  end
end
