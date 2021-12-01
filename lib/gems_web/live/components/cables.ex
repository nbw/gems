defmodule GEMSWeb.Components.Cables do
  use Phoenix.Component

  def show(assigns) do
    ~H"""
    <div class="cables">
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
