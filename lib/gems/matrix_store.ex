defmodule GEMS.MatrixStore do
  @moduledoc """
  Persistence layer for the current Matrix (public)

  Used to retrieve the initial state of the matrix when a user
  connects.

  Note: there are a lot of ways to implement this, for now
  I've chosen to leverage Presence, aka: Phoenix.Tracker, since
  it's battletested. Behind the scenes it uses PG2 (or just PG).
  """

  @type state() :: %{board: any(), updated_at: DateTime.t() | nil}

  use GenServer

  import GEMS.Util.Time

  alias GEMSWeb.PubSub
  alias GEMSWeb.Presence

  @name :"store:matrix"
  @topic "store:matrix"

  def start_link(_default) do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  @impl true
  def init(_default) do
    state = build_state()

    PubSub.subscribe(@topic)
    Presence.track(self(), @topic, Node.self(), state)

    {:ok, state}
  end

  def update(board, updated_at), do: GenServer.cast(@name, {:update, board, updated_at})

  def get(), do: GenServer.call(@name, :get)

  @impl true
  def handle_call(:get, _from, %{board: board} = state) do
    {:reply, board, state}
  end

  @impl true
  def handle_cast({:update, board, updated_at}, _prev_state) do
    new_state = build_state(board, updated_at)

    update_presence(new_state)

    {:noreply, new_state}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, _state) do
    {:noreply, get_latest_state(@topic) || build_state()}
  end

  def handle_info(
        {:matrix_update, %{board: b}},
        state
      ) do
    update_presence(build_state(b, now()))

    {:noreply, state}
  end

  @doc """
  Iterate tracked presences and return the newest state.
  """
  @spec get_latest_state(String.t()) :: state()
  def get_latest_state(topic) do
    Presence.list(topic)
    |> Map.values()
    |> Stream.map(fn
      %{
        metas: [
          %{
            board: _board,
            updated_at: _updated_at
          } = s
        ]
      } ->
        s
    end)
    |> Stream.filter(fn %{updated_at: d} -> d != nil end)
    |> Enum.sort(fn %{updated_at: d1}, %{updated_at: d2} -> DateTime.compare(d1, d2) != :lt end)
    |> List.first()
  end

  defp build_state(board \\ nil, updated_at \\ nil), do: %{board: board, updated_at: updated_at}

  defp update_presence(data) do
    Presence.update(Process.whereis(@name), @topic, Node.self(), data)
  end
end
