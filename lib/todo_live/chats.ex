defmodule TodoLive.Chats do
  import Ecto.Query, warn: false
  alias TodoLive.Repo

  alias TodoLive.Chats.Room
  alias TodoLive.Chats.Message

  def list_rooms do
    Repo.all(from r in Room, order_by: [desc: r.inserted_at], preload: [:creator])
  end

  def get_room!(id), do: Repo.get!(Room, id)

  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  def list_messages do
    Repo.all(Message)
  end

  def get_room_messages(id) do
    from(t in Message, where: t.room_id == ^id, order_by: [asc: t.inserted_at], preload: [:user])
    |> Repo.all()
  end

  def get_message!(id), do: Repo.get!(Message, id)

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> load_message_user
    |> broadcast(:message_added)
  end

  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
    |> load_message_user
  end

  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def load_message_user(updated) do
    case updated do
      {:ok, message} -> {:ok, Repo.preload(message, :user)}
      {1, [message]} -> {:ok, Repo.preload(message, :user)}
      error -> error
    end
  end

  def subscribe(id) do
    Phoenix.PubSub.subscribe(TodoLive.PubSub, "room-#{id}")
  end

  def broadcast({:error, _reason} = error, _event), do: error

  def broadcast({:ok, message}, event) do
    Phoenix.PubSub.broadcast(TodoLive.PubSub, "room-#{message.room_id}", {event, message})
    {:ok, message}
  end

  def broadcast({1, message}, event) do
    Phoenix.PubSub.broadcast(TodoLive.PubSub, "room-#{message.room_id}", {event, message})
    {:ok, message}
  end
end
