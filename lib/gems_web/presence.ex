defmodule GEMSWeb.Presence do
  use Phoenix.Presence,
    otp_app: :gems,
    pubsub_server: GEMS.PubSub

  def user_count(topic) do
    __MODULE__.list(topic)
    |> Map.keys()
    |> length
  end
end
