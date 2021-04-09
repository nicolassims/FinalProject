defmodule FinalProjectWeb.Plugs.RequireAuth do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _args) do
    Console.log("CHECKING AUTHORIZATION")
    token = Enum.at(get_req_header(conn, "x-auth"), 0)
    case Phoenix.Token.verify(conn, "user_id",
          token, max_age: 86400) do
      {:ok, user_id} ->
        Console.log("GRANTING")
        user = FinalProject.Users.get_user!(user_id)
        assign(conn, :current_user, user)
      {:error, err} ->
        Console.log("UNAUTHED")
        conn
        |> put_resp_header(
          "content-type", "application/json; charset=UTF-8")
        |> send_resp(
          :unprocessable_entity,
          Jason.encode!(%{"error" => err})
        )
        |> halt()
    end
  end
end
