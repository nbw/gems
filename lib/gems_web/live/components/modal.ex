defmodule GEMSWeb.Components.Modal do
  use GEMSWeb, :live_component
  alias Phoenix.LiveView.JS

  def modal(%{id_prefix: id_prefix} = assigns) do
    ~H"""
    <div id={"#{id_prefix}-modal"} class="phx-modal">
      <div
        id={"#{id_prefix}-modal-content"}
        class="phx-modal-content modal-content"
        phx-key="escape"
      >
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
