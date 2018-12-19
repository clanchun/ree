defmodule A do
  def a, do: 42
end

defmodule :__Main__ do
  def main([]), do: A.a()
end
