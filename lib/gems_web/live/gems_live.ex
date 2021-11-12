defmodule GEMSWeb.GEMSLive do
  use GEMSWeb, :live_view

  import GEMSWeb.GEMSLiveHelper

  alias GEMS.Matrix
  alias GEMS.Music
  alias GEMSWeb.PubSub
  alias GEMSWeb.Presence

  @size 16
  @default_tempo 180
  @local_default %{
    key: 0,
    scale: 0,
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

  @topic "room:public"
  @presence_topic "presence"

  def mount(_params, _, socket) do
    PubSub.subscribe(@topic)
    Presence.track(self(), @topic, socket.id, %{})

    matrix = Matrix.new(@size)
    matrix = Enum.reduce(0..15, matrix, fn x, m -> Matrix.set(m, x, x, 1) end)

    {:ok, assign(socket, users: 1, local: @local_default, global: %{matrix: matrix})}
  end

  def handle_event(
        "matrix-item",
        %{"col" => x, "row" => y, "value" => v},
        socket
      ) do
    {x, ""} = Integer.parse(x)
    {y, ""} = Integer.parse(y)
    {v, ""} = Integer.parse(v)

    # flips a 1 or a 0
    next = abs(v - 1)

    PubSub.broadcast(@topic, {:matrix_update, %{x: x, y: y, v: next}})

    {:noreply, socket}
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

  def handle_info(
        {:matrix_update, %{x: x, y: y, v: v}},
        %{assigns: %{global: %{matrix: m} = g}} = socket
      ) do
    {:noreply, assign(socket, :global, %{g | matrix: Matrix.set(m, x, y, v)})}
  end

  # callback for Presence when a user connects/disconnects
  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves} = payload},
        socket
      ) do
    {:noreply, assign(socket, :users, Presence.user_count(@topic))}
  end
end
