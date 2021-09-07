defmodule TodoLive.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoLive.Repo

  alias TodoLive.Todos.Todo

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    Repo.all(from t in Todo, order_by: [desc: t.inserted_at], preload: [:user])
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
    |> load_user
    |> broadcast(:todo_created)
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
    |> load_user
    |> broadcast(:todo_updated)
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  def toggle_todo(id) do
    todo = get_todo!(id)
    new_done_at = if todo.done_at, do: nil, else: DateTime.utc_now()

    todo = change_todo(todo, %{done_at: new_done_at})

    todo
    |> Repo.update()
    |> load_user
    |> broadcast(:todo_updated)
  end

  def load_user(todo) do
    case todo do
      {:ok, todo} -> {:ok, Repo.preload(todo, :user)}
      error -> error
    end
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(TodoLive.PubSub, "todos")
  end

  def broadcast({:error, _reason} = error, _event), do: error

  def broadcast({:ok, todo}, event) do
    Phoenix.PubSub.broadcast(TodoLive.PubSub, "todos", {event, todo})
    {:ok, todo}
  end

  def broadcast({1, todo}, event) do
    Phoenix.PubSub.broadcast(TodoLive.PubSub, "todos", {event, todo})
    {:ok, todo}
  end
end
