defmodule GEMSWeb.Components.Matrix do
  use GEMSWeb, :live_view
  use Phoenix.LiveComponent

  def active_column?(current, col) when current == col do
    " active"
  end

  def active_column?(_current, _col), do: ""

  def active_cell?(1), do: "active"
  def active_cell?(0), do: ""
end
