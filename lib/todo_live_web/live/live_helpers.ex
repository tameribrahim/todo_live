defmodule TodoLiveWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  alias TodoLive.Accounts

  @doc """
  Renders a component inside the `TodoLiveWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal TodoLiveWeb.TodoLive.FormComponent,
        id: @todo.id || :new,
        action: @live_action,
        todo: @todo,
        return_to: Routes.todo_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(TodoLiveWeb.ModalComponent, modal_opts)
  end

  def assign_defaults(socket, %{"current_user" => current_user} = _session) do
    socket =
      Phoenix.LiveView.assign_new(socket, :current_user, fn ->
        current_user
      end)

    if socket.assigns.current_user.id do
      socket
    else
      Phoenix.LiveView.redirect(socket, to: "/login")
    end
  end
end
