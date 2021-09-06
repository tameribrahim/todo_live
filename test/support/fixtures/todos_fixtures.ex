defmodule TodoLive.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoLive.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        done_at: ~D[2021-09-05],
        due_at: ~D[2021-09-05],
        title: "some title"
      })
      |> TodoLive.Todos.create_todo()

    todo
  end
end
