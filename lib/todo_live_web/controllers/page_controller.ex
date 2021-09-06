defmodule TodoLiveWeb.PageController do
  use TodoLiveWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
