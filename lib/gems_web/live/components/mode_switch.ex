defmodule GEMSWeb.Components.ModeSwitch do
  @doc """
  Light/Dark mode switch
  """
  use Phoenix.Component

  def button(assigns) do
    ~H"""
      <div class="mode-switch">
        <label class="switch">
          <span class="box"></span>
        </label>
        <img />
      </div>
    """
  end
end
