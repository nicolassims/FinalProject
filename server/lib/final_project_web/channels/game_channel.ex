defmodule FinalProjectWeb.GameChannel do
  use FinalProjectWeb, :channel

  alias FinalProject.Users

  @impl true
  def join("game", payload, socket) do
    IO.inspect("Joining channel")
    IO.inspect(payload)

    if authorized?(socket, payload) do
      {:ok, %{}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", _payload, socket) do
    list = Enum.reduce(Users.list_users(), [], fn user, acc ->
      acc = [user.food | acc]
    end)
    {:reply, {:ok, list}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  def authorized?(socket, payload) do
    IO.inspect("Trying to authorize")

    # check token in payload
    token = Map.get(payload, "token")

    if token != nil do
      IO.inspect("We have a token")

      # verify token on user
      case Phoenix.Token.verify(socket, "user_id", token, max_age: 86400) do
        {:ok, _user_id} ->
          # user = FinalProject.Users.get_user!(user_id)
          # assign(socket, :current_user, user)
          true
        {:error, _err} ->
          false
      end
    else
      IO.inspect("We DONT HAVE a token")
      false
    end
  end
end
