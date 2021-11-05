defmodule GEMS.Matrix.BinaryHelper do
  @moduledoc """
  Helper functions for bitwise/binary/bitstring operations.
  """
  use Bitwise

  @doc """
  Replaces a byte in a binarystring (of bytes)
  """
  def set_byte_at(byte_str, index, byte) do
    <<head::binary-size(index), _::binary-size(1), tail::binary>> = byte_str

    head <> byte <> tail
  end

  @doc """
  Retrieves a byte from a bitstring.

  `byte_at(<<0, 97, 255>>, 1) == 97`
  """
  def byte_at(binary, index) do
    :binary.at(binary, index)
  end

  # ex: bit_at(97, 1)
  def bit_at(binary, index) when is_integer(binary) do
    bit_at(<<binary>>, index)
  end

  # ex: bit_at(<<97>>, 0)
  def bit_at(binary, 0) do
    <<result::size(1), _::bitstring>> = binary
    result
  end

  # ex: bit_at(<<97>>, 1)
  def bit_at(binary, index) do
    <<_::size(index), result::size(1), _::bitstring>> = binary
    result
  end

  @doc """
  Sets a bit in an byte (as 1 or 0).

  ex: `set_bit_at(97, 1, 1)`
  """
  def set_bit_at(binary, index, value) when is_integer(binary) do
    set_bit_at(<<binary>>, index, value)
  end

  def set_bit_at(<<binary>>, index, value) when is_integer(binary) and value in [0, 1] do
    pattern = Integer.pow(2, 7 - index)

    result =
      case value do
        1 -> binary ||| pattern
        0 -> binary &&& ~~~pattern
      end

    <<result>>
  end

  def set_bit_at(_binary, _index, _value), do: :error
end
