defmodule GEMS.Music.Scale do
  alias GEMS.Music.Note

  # Note:
  #   although it would be fairly trivial to
  #   calculate scales intervals on the fly, in the interest
  #   of saving latency I've opted to simply define them
  #   beforehand.
  @scales [
    # ionian
    major: [2, 2, 1, 2, 2, 2, 1],
    # aeolian
    minor: [2, 1, 2, 2, 1, 2, 2],
    m_harmonic: [2, 1, 2, 2, 1, 3, 1],
    m_melodic: [2, 1, 2, 2, 2, 2, 1]
    # dorian: [2, 1, 2, 2, 2, 1, 2],
    # phrygian: [1, 2, 2, 2, 1, 2, 2],
    # lydian: [2, 2, 2, 1, 2, 2, 1],
    # mixolydian: [2, 2, 1, 2, 2, 1, 2],
    # locrian: [1, 2, 2, 1, 2, 2, 2]
  ]

  def scale_names, do: Keyword.keys(@scales)

  def get_scale(scale), do: @scales[scale]

  def notes_in_scale(start_note, start_octave, num_notes, scale_name) do
    build_notes(start_note, start_octave, get_scale(scale_name), num_notes)
  end

  defp build_notes(note, start_octave, scale, rem_notes, acc \\ [])

  defp build_notes(_note, _start_octave, _scale, 0, acc), do: Enum.reverse(acc)

  defp build_notes(start_note, start_octave, scale, rem_notes, []) do
    # initial
    {n, o} = Note.note_and_octave(start_note)
    build_notes(start_note, start_octave, scale, rem_notes - 1, ["#{n}#{start_octave + o}"])
  end

  defp build_notes(note_index, start_octave, [s | scale], rem_notes, notes) do
    {n, o} = Note.note_and_octave(note_index + s)

    build_notes(
      note_index + s,
      start_octave,
      scale ++ [s],
      rem_notes - 1,
      ["#{n}#{start_octave + o}" | notes]
    )
  end
end
