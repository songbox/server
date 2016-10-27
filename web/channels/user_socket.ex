defmodule Songbox.UserSocket do
  use Phoenix.Socket
  import Guardian.Phoenix.Socket

  channel "room:*", Songbox.RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket, timeout: 45_000, check_origin: ["https://beta.songbox.co", "https://app.songbox.co"]

  def connect(%{"token" => jwt} = params, socket) do
    case sign_in(socket, jwt) do
      {:ok, authed_socket, guardian_params} -> {:ok, authed_socket}
      _ -> :error
    end
  end

  def connect(_params, socket) do
    :error
  end

  def id(socket), do: "users_socket:#{current_resource(socket).id}"

end
