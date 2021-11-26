defmodule GEMSWeb.Components.Presence do
  use Phoenix.Component

  def count(%{users: users} = assigns) do
    ~H"""
    <div class="presence">
      <span><%= users %></span>
      <img class="human"/>
    </div>
    """
  end
end
