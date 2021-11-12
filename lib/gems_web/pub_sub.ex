defmodule GEMSWeb.PubSub do
  alias Phoenix.PubSub

  def subscribe(topic) do
    PubSub.subscribe(GEMS.PubSub, topic)
  end

  def broadcast(topic, data) do
    PubSub.broadcast(GEMS.PubSub, topic, data)
  end
end
