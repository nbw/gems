defmodule GEMSWeb.GEMSLiveHelper do
  alias GEMS.Music

  def pad_number(num, pad) do
    num
    |> Integer.to_string()
    |> String.pad_leading(3, "0")
  end

  defdelegate scale_name(i), to: Music

  defdelegate get_notes(key, scale, num_notes), to: Music
  defdelegate get_key(key), to: Music
end
