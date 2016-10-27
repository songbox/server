defmodule Songbox.RoomChannel do
  use Songbox.Web, :channel

  def join("room:" <> _room_id, _payload, socket) do
    {:ok, socket}
  end

  # share a song
  def handle_in("share", payload, socket) do
    if authorized?(socket) do
      broadcast socket, "share", payload
      {:noreply, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # users are authorized, viewers not
  defp authorized?(socket) do
    socket.handler == Songbox.UserSocket
  end
end
