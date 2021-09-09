defmodule TodoLiveWeb.TodoLive.Index do
  use TodoLiveWeb, :live_view

  alias TodoLive.Todos
  alias TodoLive.Todos.Todo

  @impl true
  def mount(_params, %{"current_user" => current_user} = _session, socket) do
    if connected?(socket) do
      Todos.subscribe()
    end

    socket =
      socket
      |> assign(:todos, list_todos())
      |> assign(:current_user, current_user)

    {:ok, socket, temporary_assigns: [todos: []]}
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
    |> assign(:todo, %Todo{})
  end

  @impl true
  def handle_event("toggle", %{"id" => id}, socket) do
    {:ok, todo} = Todos.toggle_todo(id)
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  @impl true
  def handle_info({:todo_created, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  @impl true
  def handle_info({:todo_updated, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  defp list_todos do
    Todos.list_todos()
  end
end
