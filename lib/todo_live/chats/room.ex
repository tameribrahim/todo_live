defmodule TodoLive.Chats.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string

    belongs_to :creator, TodoLive.Accounts.User, foreign_key: :created_by
    has_many :messages, TodoLive.Chats.Message

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :created_by])
    |> validate_required([:name, :created_by])
  end
end
