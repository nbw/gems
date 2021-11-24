defmodule GEMS.Music.Note do
  # octave increment on C
  # https://tonejs.github.io/docs/14.7.77/type/Note
  @notes [
    "C",
    "C#",
    "D",
    "D#",
    "E",
    "F",
    "F#",
    "G",
    "G#",
    "A",
    "A#",
    "B"
  ]

  @doc false
  def note(num) do
    Enum.at(@notes, rem(num, 12))
  end

  @doc false
  def octave(num) when num >= 0 do
    div(abs(num), 12)
  end

  @doc false
  def octave(num) when num < 0 do
    div(num + 1, 12) - 1
  end

  @doc false
  def note_and_octave(num) do
    {note(num), octave(num)}
  end
end
