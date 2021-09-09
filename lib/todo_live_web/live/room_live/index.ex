defmodule TodoLiveWeb.RoomLive.Index do
  use TodoLiveWeb, :live_view

  alias TodoLive.Chats
  alias TodoLive.Chats.Room

  @impl true
  def mount(_params, %{"current_user" => current_user} = _session, socket) do
    socket =
      socket
      |> assign(:rooms, list_rooms())
      |> assign(:current_user, current_user)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Room")
    |> assign(:room, Chats.get_room!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Room")
    |> assign(:room, %Room{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rooms")
    |> assign(:room, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    room = Chats.get_room!(id)
    {:ok, _} = Chats.delete_room(room)

    {:noreply, assign(socket, :rooms, list_rooms())}
  end

  defp list_rooms do
    Chats.list_rooms()
  end
end
