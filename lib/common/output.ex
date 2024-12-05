defmodule Common.Output do
  @spec measure(fun()) :: {float(), String.t()}
  def measure(function) do
    {time_us, result} = :timer.tc(function)
    {time_us / 1_000, result}
  end

  @spec pretty_print(String.t(), (any() -> integer()), any()) :: :ok
  def pretty_print(part, func, data) do
    part_str = if part == 1, do: "Part I", else: "Part II"
    {runtime_ms, result} = measure(fn -> func.(data) end)

    IO.puts("#{part_str}: #{Integer.to_string(result)} Execution time: #{runtime_ms}ms")
  end
end
