defmodule Common.Misc do
  def boolean_to_integer(bool) do
    if bool, do: 1, else: 0
  end
end
