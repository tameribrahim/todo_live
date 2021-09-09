defmodule TodoLive.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    belongs_to :room, TodoLive.Chats.Room
    belongs_to :user, TodoLive.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :room_id, :user_id])
    |> validate_required([:body, :room_id, :user_id])
  end
end
