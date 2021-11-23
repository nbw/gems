defmodule GEMSWeb.Components.Cables do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="cables mx-4">
      <div class="cables-mid">
        <div class="cable">
          <div class="cable-top"></div>
          <div class="cable-mid"></div>
          <div class="cable-bot"></div>
        </div>
        <div class="cable">
          <div class="cable-top"></div>
          <div class="cable-mid"></div>
          <div class="cable-bot"></div>
        </div>
        <div class="cable">
          <div class="cable-top"></div>
          <div class="cable-mid"></div>
          <div class="cable-bot"></div>
        </div>
      </div>
      <div class="cables-bottom"></div>
    </div>
    """
  end
end
