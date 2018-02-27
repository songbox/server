defmodule SongboxWeb.UserSocket do
  use Phoenix.Socket
  import Guardian.Phoenix.Socket

  channel "room:*", Songbox.RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket, timeout: 45_000, check_origin: ["https://beta.songbox.co", "https://app.songbox.co"]

  def connect(%{"token" => jwt} = _params, socket) do
    case sign_in(socket, jwt) do
      {:ok, authed_socket, _guardian_params} -> {:ok, authed_socket}
      _ -> :error
    end
  end

  def connect(_params, _socket) do
    :error
  end

  def id(socket), do: "users_socket:#{current_resource(socket).id}"

end
