defmodule Songbox.RoomChannel do
  use Songbox.Web, :channel

  def join("room:" <> room_token, _payload, socket) do
    user = Songbox.User
           |> where(id: ^room_token)
           |> Repo.one
    if user do
      {:ok, socket}
    else
      {:error, %{reason: "400"}}
    end
  end

  # share a song
  def handle_in("share", payload, socket) do
    if authorized?(socket) do
      broadcast socket, "share", payload
      {:noreply, socket}
    else
      {:error, %{reason: "401"}}
    end
  end

  # users are authorized, viewers not
  defp authorized?(socket) do
    socket.handler == Songbox.UserSocket
  end
end
