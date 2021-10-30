defmodule GEMSWeb.PageController do
  use GEMSWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
