defmodule GEMSWeb.RoomController do
  use GEMSWeb, :controller

  def new(conn, _params) do
    redirect(conn, to: Routes.room_gems_path(conn, :show, uniq_id()))
  end

  # Use first 8 characters of UUID
  defp uniq_id, do: String.slice(uuid(), 0..7)

  defp uuid, do: UUID.uuid1()
end
