defmodule GEMS.Matrix.BinaryMatrix do
  @moduledoc """
  Abstracts a matrix into a 1-D binary string.

  Example:

  ```
  # 16 points in the following matrix:
  [ 1, 0, 0, 0]
  [ 0, 1, 0, 0]
  [ 0, 0, 1, 0]
  [ 0, 0, 0, 1]
  ```
  The 16 points in the matrix above can be represeted by a 1-dimensional array/list/bitstring
  of `2 bytes` (2 x 8 bits).

  In this specific case, `1 0 0 0 0 1 0 0` and `0 0 1 0 0 0 0 1`

  So the matrix above can be abstracted as `132` and `33` in base 10.

  As a bitstring that's `<<132, 33>>`
  """

  @behaviour GEMS.Matrix

  defstruct board: "", h: 8, w: 8

  alias GEMS.Matrix.BinaryHelper, as: Binary

  @doc """
  Create a square matrix

  Note: hasn't been tested for non-multiples of 8.
  """
  @impl GEMS.Matrix
  def new(size, opts \\ []) do
    grid_size = size * size

    board = Keyword.get(opts, :board) || zero_grid(grid_size)

    if bit_size(board) == grid_size do
      {:ok, %__MODULE__{board: board, h: size, w: size}}
    else
      {:error, :invalid_board}
    end
  end

  @doc """
  Get an element from the matrix
  """
  @impl GEMS.Matrix
  def get(%{board: b, w: w}, x, y) do
    y_index = calc_y_index(x, y, w)
    x_index = calc_x_index(x)

    Binary.byte_at(b, y_index)
    |> Binary.bit_at(x_index)
  end

  @doc """
  Set an element in the matrix
  """
  @impl GEMS.Matrix
  def set(%{board: b, w: w} = grid, x, y, v) do
    y_index = calc_y_index(x, y, w)
    x_index = calc_x_index(x)

    updated_byte =
      Binary.byte_at(b, y_index)
      |> Binary.set_bit_at(x_index, v)

    b = Binary.set_byte_at(b, y_index, updated_byte)
    %{grid | board: b}
  end

  defp calc_y_index(x, y, w) do
    y_index = div(w, 8) * y
    y_index + div(x, 8)
  end

  defp calc_x_index(x) do
    rem(x, 8)
  end

  defp zero_grid(bit_size) do
    for i <- List.duplicate(0, bit_size), do: <<i::1>>, into: <<>>
  end
end
