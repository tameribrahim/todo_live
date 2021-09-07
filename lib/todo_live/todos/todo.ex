defmodule TodoLive.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :title, :string
    field :done_at, :date
    field :due_at, :date
    field :channels, {:array, :string}

    belongs_to :user, TodoLive.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :due_at, :done_at, :user_id, :channels])
    |> validate_required([:title, :user_id])
    |> validate_length(:title, min: 4, max: 256)
  end
end
