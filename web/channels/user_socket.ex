defmodule Songbox.UserSocket do
  use Phoenix.Socket
  import Guardian.Phoenix.Socket

  ## Channels
  channel "room:*", Songbox.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket, timeout: 45_000, check_origin: ["https://beta.songbox.co", "https://app.songbox.co"]
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => jwt} = params, socket) do
    case sign_in(socket, jwt) do
      {:ok, authed_socket, guardian_params} -> {:ok, authed_socket}
      _ -> :error
    end
  end

  def connect(_params, socket) do
    :error
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Songbox.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket), do: "users_socket:#{current_resource(socket).id}"
end
