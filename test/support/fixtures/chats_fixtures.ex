defmodule TodoLive.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoLive.Chats` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TodoLive.Chats.create_room()

    room
  end

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> TodoLive.Chats.create_message()

    message
  end
end
