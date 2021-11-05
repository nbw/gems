defmodule GEMSWeb.GEMSLive do
  use GEMSWeb, :live_view

  import GEMSWeb.GEMSLiveHelper

  alias GEMS.Matrix
  alias GEMS.Music

  @size 16
  @default_tempo 120
  @local_default %{
    key: 0,
    scale: 0,
    current: 0,
    tempo: @default_tempo,
    reverb: 10,
    delay: 10,
    adsr: %{
      a: 1,
      d: 25,
      s: 15,
      r: 35
    }
  }

  def mount(_params, _, socket) do
    if connected?(socket), do: Process.send_after(self(), :tic, Music.tempo(@default_tempo))
    matrix = Matrix.new(@size)
    matrix = Enum.reduce(0..15, matrix, fn x, m -> Matrix.set(m, x, x, 1) end)

    {:ok, assign(socket, local: @local_default, global: %{matrix: matrix})}
  end

  def handle_event(
        "matrix-item",
        %{"col" => x, "row" => y, "value" => v},
        %{assigns: %{global: %{matrix: m} = g}} = socket
      ) do
    {x, ""} = Integer.parse(x)
    {y, ""} = Integer.parse(y)
    {v, ""} = Integer.parse(v)

    next = abs(v - 1)

    {:noreply, assign(socket, :global, %{g | matrix: Matrix.set(m, x, y, next)})}
  end

  # handle updates from ADSR sliders
  def handle_event(
        "adsr",
        %{"_target" => [_, key], "slider" => value},
        %{assigns: %{local: local}} = socket
      ) do
    {v, ""} =
      Map.get(value, key)
      |> Integer.parse()

    {:noreply,
     assign(socket, local: %{local | adsr: Map.put(local[:adsr], String.to_atom(key), v)})}
  end

  # general-use updates from local-control sliders
  def handle_event(
        "local-control",
        %{"_target" => [_, key], "slider" => value},
        %{assigns: %{local: local}} = socket
      ) do
    {v, ""} =
      Map.get(value, key)
      |> Integer.parse()

    {:noreply, assign(socket, :local, Map.put(local, String.to_atom(key), v))}
  end

  # general-use updates from local-control < and > buttons
  def handle_event(
        "inc",
        %{"action" => action, "value" => key, "max" => max},
        %{assigns: %{local: local}} = socket
      ) do
    {max, ""} = Integer.parse(max)
    key = String.to_atom(key)

    current = Map.get(local, key)

    new =
      case action do
        "+" -> current + 1
        "-" -> current - 1
      end

    new =
      cond do
        new > max -> -1 * max + 1
        new < -1 * max -> max
        new -> new
      end

    {:noreply, assign(socket, :local, Map.put(local, key, new))}
  end

  # increment sequencer at a specific BPM
  def handle_info(:tic, %{assigns: %{local: %{current: current, tempo: tempo} = local}} = socket) do
    Process.send_after(self(), :tic, Music.tempo(tempo))

    local = Map.put(local, :current, rem(current + 1, @size))

    {:noreply, assign(socket, :local, local)}
  end
end
