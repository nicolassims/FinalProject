defmodule FinalProjectWeb.TwitterController do
  use FinalProjectWeb, :controller

  alias FinalProject.Users
  alias FinalProject.Users.User

  alias FinalProjectWeb.Plugs
  plug Plugs.RequireAuth

  def index(conn, _params) do
    req_token = get_request_token()
    IO.inspect("REQUEST TOKEN:")
    IO.inspect(req_token)

    auth_url = get_authorize_url(req_token)

    IO.inspect("URL:")
    IO.inspect(auth_url)

    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(:ok, Jason.encode!(%{data: %{url: auth_url, req_token: req_token}}))
  end

  def create(conn, %{"pin" => pin, "token" => token}) do

    acc_token = get_access_token(pin, token)

    IO.inspect(acc_token)

    user = conn.assigns[:current_user]

    Users.update_user(user, %{oauth_token: Map.get(acc_token, "oauth_token"),
                                        oauth_token_secret: Map.get(acc_token, "oauth_token_secret")})

    user = FinalProject.Users.get_user!(user.id)
    IO.inspect(user)


    conn
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(:created, Jason.encode!(%{}))
  end

  def create(conn, %{"tweet" => tweet}) do
    user = conn.assigns[:current_user]

    access = %{"oauth_token" => user.oauth_token, "oauth_token_secret" => user.oauth_token_secret}

    tweet = post_status(access, tweet)
    FinalProject.TrackTweet.start(tweet.id, access, user)

    conn
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(:created, Jason.encode!(%{}))
  end
end
