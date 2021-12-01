defmodule GEMSWeb.Components.Modal.AudioEnable do
  use GEMSWeb, :live_component

  alias Phoenix.LiveView.JS

  @prefix "audio"

  def hide_modal(js \\ %JS{}) do
    js
    |> JS.add_class("closing", to: "##{@prefix}-modal-content")
    |> JS.hide(transition: "fade-out", to: "##{@prefix}-modal")
    |> JS.hide(transition: "fade-out-scale", to: "##{@prefix}-modal-content")
  end

  def render(%{topic: topic} = assigns) do
    ~H"""
    <C.Modal.render id_prefix={prefix()} phx-remove={hide_modal()}>
      <section>
        <p>Welcome to GEMS.</p>
        <p>Audio will have to be enabled before you can continue.</p>
        <button id="audio-btn" class="modal-button" phx-click={hide_modal()}>enable audio</button>
      </section>
      <section>
        <hr/>
        <p class="modal-header">Dark/Light Mode</p>
        <C.ModeSwitch.button />
      </section>
      <section>
        <hr/>
        <%= if public_room?(topic) do %>
          <p>
            Alternatively, you can create a private room by clicking the link below:
          </p>
          <div class="private">
            <%= live_patch "private room", to: Routes.room_path(GEMSWeb.Endpoint, :new) %>
          </div>
        <% else %>
          <p class="modal-header">Private mode</p>
          <p>A few things to know:</p>
          <ul>
            <li>the matrix/grid state is saved in the url of the page (not the server)</li>
            <li>so when sharing the url, avoid making any changes to the grid before others have arrived</li>
          </ul>
        <% end %>
      </section>
    </C.Modal.render>
    """
  end

  defp prefix do
    @prefix
  end
end
