defmodule GEMSWeb.Components.AudioModal do
  use GEMSWeb, :live_component
  alias Phoenix.LiveView.JS

  def hide_modal(js \\ %JS{}) do
    js
    |> JS.add_class("closing", to: "#modal-content")
    |> JS.hide(transition: "fade-out", to: "#modal")
    |> JS.hide(transition: "fade-out-scale", to: "#modal-content")
  end

  def render(%{topic: topic} = assigns) do
    ~H"""
    <div id="modal" class="phx-modal" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content modal-content"
        phx-key="escape"
      >
        <section>
          <p>Welcome to GEMS.</p>
          <p>Audio will have to be enabled before you can continue.</p>
          <button id="audio-btn" class="modal-button" phx-click={hide_modal()}>enable audio</button>
        </section>
        <section>
          <hr class="my-4" />
          <p class="uppercase text-center">Dark/Light Mode</p>
          <GEMSWeb.Components.ModeSwitch.button />
        </section>
        <section>
          <hr class="my-4" />
          <%= if public_room?(topic) do %>
            <p>
              Alternatively, you can create a private room by clicking the link below:
            </p>
            <div class="text-center">
              <%= live_patch "private room", to: Routes.room_path(GEMSWeb.Endpoint, :new) %>
            </div>
          <% else %>
            <p class="uppercase text-center">Private mode</p>
            <p>A few things to know:</p>
            <ul>
              <li>the matrix/grid state is saved in the url of the page (not the server)</li>
              <li>so when sharing the url, avoid making any changes to the grid before others have arrived</li>
            </ul>
          <% end %>
        </section>
      </div>
    </div>
    """
  end
end
