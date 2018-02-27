defmodule Songbox.RoomChannel do
  use Songbox.Web, :channel

  def join("room:" <> room_uid, _payload, socket) do
    room = Songbox.Room
           |> where(uid: ^room_uid)
           |> Repo.one

    # TODO: save in session/socket if room belongs to user

    if room do
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
