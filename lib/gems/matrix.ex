defmodule GEMS.Matrix do
  @moduledoc """
  Matrix
  """
  @callback new(size :: number) :: term
  @callback get(grid :: term, x :: number, y :: number) :: any
  @callback set(grid :: term, x :: number, y :: number, v :: any) :: term

  alias __MODULE__.BinaryMatrix, as: M

  defdelegate new(size), to: M
  defdelegate get(matrix, x, y), to: M
  defdelegate set(matrix, x, y, v), to: M
end
