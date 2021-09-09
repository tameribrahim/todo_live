defmodule TodoLiveWeb.LobbyLive.Chat do
  use TodoLiveWeb, :live_view

  @impl true
  def mount(_params, %{"current_user" => current_user} = _session, socket) do
    socket =
      socket
      # |> assign_defaults(session)
      |> assign(:current_user, current_user)

    IO.inspect(current_user)
    {:ok, socket}
  end
end
