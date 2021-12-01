defmodule GEMS.Music.Adsr do
  @moduledoc """
  ADSR related functions.

  ```
  |
  |   /\
  |  /  \__
  | /      \
  ----------------
  ```

  Use for the ADSR Graph and interfacting with [Tone.js' Envelope](tonejs_normalize)
  features.
  """

  # Min/Max values set by Tone.js
  @min_max %{
    a: [0.0, 2.0],
    d: [0.0, 2.0],
    s: [0.0, 1.0],
    r: [0.0, 5.0]
  }

  @doc """
  Normalize a range of 0 - 100 to values accepted by Tone.js

  value: 0 to 100
  param: :a, :d, :s, :r
  """
  def tonejs_normalize(value, param) do
    value = value / 100.0

    [min, max] = @min_max[param]

    cond do
      value < min ->
        min

      value > max ->
        max

      true ->
        (value * max)
        |> Float.round(2)
    end
  end

  @doc """
  Coordinates for ADSR graph.
  """
  def adsr_coords(a, d, s, r) do
    f = 100 - 2 * a / 5

    x1 = 2 * a / 5
    x2 = f * (d / (0.1 + d + s + r)) + x1
    x3 = f * (s / (0.1 + d + s + r)) + x2
    x4 = f * (r / (0.1 + d + s + r)) + x3

    y1 = 100
    y2 = s
    y3 = s
    y4 = 0

    [[0, 0], [x1, y1], [x2, y2], [x3, y3], [x4, y4]]
  end
end
