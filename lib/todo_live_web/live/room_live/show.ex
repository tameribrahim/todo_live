defmodule TodoLiveWeb.RoomLive.Show do
  use TodoLiveWeb, :live_view

  alias TodoLive.Chats

  @impl true
  def mount(%{"id" => id}, %{"current_user" => current_user} = _session, socket) do
    if connected?(socket) do
      Chats.subscribe(id)

      # Presence.track(
      #   self(),
      #   @ room_presence,
      #   current_user.id,
      #   %{
      #     first_name: current_user.first_name,
      #     email: current_user.email,
      #     user_id: current_user.id
      #   }
      # )
    end

    {:ok, assign(socket, :current_user, current_user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _session, socket) do
    messages = Chats.get_room_messages(id)
    changeset = Chats.change_message(%Chats.Message{})

    {:noreply,
     socket
     |> assign(:room, Chats.get_room!(id))
     |> assign(:messages, messages)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("typing", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"message" => message_params}, socket) do
    %{current_user: current_user, room: room} = socket.assigns

    full_params =
      message_params
      |> Map.put_new("user_id", current_user.id)
      |> Map.put_new("room_id", room.id)

    case Chats.create_message(full_params) do
      {:ok, _message} ->
        {:noreply, push_event(socket, :clear_input, %{})}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_info({:message_added, message}, socket) do
    {:noreply, update(socket, :messages, fn messages -> messages ++ [message] end)}
  end
end
