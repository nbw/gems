defmodule GEMSWeb.Components.AudioModal do
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  def hide_modal(js \\ %JS{}) do
    js
    |> JS.add_class("closing", to: "#modal-content")
    |> JS.hide(transition: "fade-out", to: "#modal")
    |> JS.hide(transition: "fade-out-scale", to: "#modal-content")
  end

  def render(assigns) do
    ~H"""
    <div id="modal" class="phx-modal" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content modal-content"
        phx-key="escape"
      >
        <p>Welcome to GEMS.</p>
        <p>Audio will have to be enabled before you can continue.</p>
        <button id="audio-btn" class="modal-button" phx-click={hide_modal()}>enable audio</button>
        <hr class="my-4" />
        <GEMSWeb.Components.ModeSwitch.button />
      </div>
    </div>
    """
  end
end
