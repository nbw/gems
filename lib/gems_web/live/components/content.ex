defmodule GEMSWeb.Components.Content do
  @moduledoc """
  Renders content.html.heex
  """
  use Phoenix.LiveComponent

  # Note: it would make more sense if this was a Phoenix.Component instead of
  # a LiveComponent because the content is static. but at least for now there
  # it's easier to use a LiveComponent and call render().
end
