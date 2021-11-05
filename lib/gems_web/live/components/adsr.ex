defmodule GEMSWeb.Components.Adsr do
  use GEMSWeb, :live_view
  use Phoenix.LiveComponent

  def adsr_normalize(num, param), do: GEMS.Music.tonejs_normalize(num, param)
end
