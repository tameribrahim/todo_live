defmodule TodoLiveWeb.Presence do
  use Phoenix.Presence,
    otp_app: :todo_live,
    pubsub_server: TodoLive.PubSub
end
