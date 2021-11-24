defmodule GEMSWeb.Components.Modal.ResetConfirm do
  use GEMSWeb, :live_component

  alias Phoenix.LiveView.JS

  @prefix "reset"

  def hide(js \\ %JS{}) do
    js
    |> JS.add_class("closing", to: "##{@prefix}-modal-content")
    |> JS.hide(to: "##{prefix()}-modal", transition: "fade-out")
  end

  def hide_and_reset(js \\ %JS{}) do
    JS.push("reset")
    |> JS.hide(to: "##{prefix()}-modal")
  end

  def modal(assigns) do
    ~H"""
    <C.Modal.modal id_prefix={prefix()} hide={true} phx-remove={hide()} >
      <section>
        <p class="modal-header">Clear Matrix</p>
        <p>Clearing the matrix/grid affect anyone else connected to the page.</p>
        <p class="content-center">Are you sure?</p>
        <div class="modal-button-group">
          <button
            class="modal-button"
            phx-throttle="500"
            phx-click={ hide_and_reset() }
            phx-click-away={hide()}
          >
            Confirm
          </button>
          <button
            class="modal-button"
            phx-throttle="500"
            phx-click={ hide}
            phx-click-away={hide()}
          >
            Cancel
          </button>
        </div>
      </section>
    </C.Modal.modal>
    """
  end

  defp prefix do
    @prefix
  end
end
