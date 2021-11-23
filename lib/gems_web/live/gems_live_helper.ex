defmodule GEMSWeb.GEMSLiveHelper do
  alias GEMS.Music
  alias GEMS.Matrix

  @public_topic "room:public"

  def pad_number(num, pad) do
    num
    |> Integer.to_string()
    |> String.pad_leading(3, "0")
  end

  defdelegate scale_name(i), to: Music

  defdelegate get_notes(key, scale, num_notes), to: Music

  defdelegate get_key(key), to: Music

  defdelegate tempo_ms(tempo), to: Music

  def room_topic(%{"room" => topic}), do: "room:private:#{topic}"
  def room_topic(_params), do: @public_topic

  def public_room?(%{assigns: %{topic: topic}} = _socket), do: public_room?(topic)
  def public_room?(topic), do: topic == @public_topic

  def new_matrix_64(size, nil), do: new_matrix(size)

  def new_matrix_64(size, matrix_64) do
    Base.url_decode64(matrix_64)
    |> case do
      {:ok, matrix} ->
        new_matrix(size, matrix)

      :error ->
        :error
    end
  end

  def new_matrix(size, matrix \\ nil)

  def new_matrix(size, matrix) when is_bitstring(matrix) do
    Matrix.new(size, board: matrix)
  end

  def new_matrix(size, _), do: Matrix.new(size)
end
