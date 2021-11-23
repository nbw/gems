defmodule GEMSWeb.Components.Presence do
  use Phoenix.Component

  def render(%{users: users} = assigns) do
    ~H"""
    <div class="presence">
      <span><%= users %></span>
      <img class="logo"/>
    </div>
    """
  end
end
