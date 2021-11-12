defmodule GEMSWeb.GemsChannel do
  use Phoenix.Channel

  def join("room:public", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
