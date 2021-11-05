defmodule GEMS.Music.Tempo do
  @moduledoc false

  @doc """
  Convert bpm to milliseconds

  Default: uses 1/4 timing
  """
  def bpm_to_ms(bpm, note \\ 4) do
    div(240_000, bpm * note)
  end
end
