defmodule TodoLiveWeb.TodoLive.Index do
  use TodoLiveWeb, :live_view

  alias TodoLive.Todos
  alias TodoLive.Todos.Todo

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, assign(socket, :todos, list_todos())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo")
    |> assign(:todo, Todos.get_todo!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_event("toggle", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {1, _} = Todos.toggle_todo(todo)
    {:noreply, assign(socket, :todos, list_todos())}
  end

  defp list_todos do
    Todos.list_todos()
  end
end
