defmodule TodoLive.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :done_at, :date
    field :due_at, :date
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :due_at, :done_at])
    |> validate_required([:title, :due_at, :done_at])
  end
end
