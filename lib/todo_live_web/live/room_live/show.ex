defmodule TodoLiveWeb.RoomLive.Show do
  use TodoLiveWeb, :live_view
  alias TodoLiveWeb.Presence

  alias TodoLive.Chats

  def topic(id), do: "room-#{id}"

  @impl true
  def mount(%{"id" => id}, %{"current_user" => current_user} = _session, socket) do
    if connected?(socket) do
      Chats.subscribe(id)

      Presence.track(
        self(),
        topic(id),
        current_user.id,
        %{
          first_name: current_user.first_name,
          email: current_user.email,
          user_id: current_user.id,
          typing: false
        }
      )
    end

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:users, [])

    {:ok, socket}
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
  def handle_event(
        "typing",
        _params,
        %{assigns: %{room: room, current_user: current_user}} = socket
      ) do
    topic = topic(room.id)
    key = current_user.id
    payload = %{typing: true}

    metas =
      Presence.get_by_key(topic, key)[:metas]
      |> List.first()
      |> Map.merge(payload)

    Presence.update(self(), topic, key, metas)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "stop_typing",
        %{"value" => body} = _value,
        %{assigns: %{room: room, current_user: current_user}} = socket
      ) do
    IO.puts("#######STOP TYPING########")

    changeset =
      Chats.change_message(%Chats.Message{}, %{
        body: body,
        user_id: current_user.id,
        room_id: room.id
      })

    topic = topic(room.id)
    key = current_user.id
    payload = %{typing: false}

    metas =
      Presence.get_by_key(topic, key)[:metas]
      |> List.first()
      |> Map.merge(payload)

    Presence.update(self(), topic, key, metas)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"message" => message_params}, socket) do
    IO.puts("#######SAVING########")
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
  def handle_info(%{event: "presence_diff"}, %{assigns: %{room: room}} = socket) do
    users =
      Presence.list(topic(room.id))
      |> Enum.map(fn {_user_id, data} ->
        data[:metas]
        |> List.first()
      end)

    {:noreply, assign(socket, users: users)}
  end

  @impl true
  def handle_info({:message_added, message}, socket) do
    {:noreply, update(socket, :messages, fn messages -> messages ++ [message] end)}
  end
end
