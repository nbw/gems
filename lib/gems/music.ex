defmodule GEMS.Music do
  alias GEMS.Music.{
    Tempo,
    Adsr,
    Note,
    Scale
  }

  defdelegate tempo_ms(bpm), to: Tempo, as: :bpm_to_ms

  defdelegate adsr_coords(a, d, s, r), to: Adsr

  defdelegate tonejs_normalize(num, param), to: Adsr, as: :tonejs_normalize

  def scale_name(i) do
    scales = Scale.scale_names()

    Enum.at(scales, rem(i, length(scales)))
  end

  # key: 0 -> C3
  # key: -12 -> C2
  # key: 12 -> C4
  def get_notes(key, scale_index, num_notes) do
    Scale.notes_in_scale(key, 3 + div(key, 12), num_notes, scale_name(scale_index))
  end

  def get_key(key) do
    {n, o} = Note.note_and_octave(key)
    "#{n}-#{3 + o}"
  end
end
