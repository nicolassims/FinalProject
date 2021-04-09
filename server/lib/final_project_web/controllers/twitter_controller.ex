defmodule FinalProjectWeb.TwitterController do
  use FinalProjectWeb, :controller

  alias FinalProject.Users

  alias FinalProjectWeb.Plugs
  plug Plugs.RequireAuth

  def index(conn, _params) do
    IO.inspect("GETTING REQUEST TOKEN")
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

  def create(conn, %{"verifier" => verifier,"token" => token}) do
    user = conn.assigns[:current_user]

    acc_token = get_access_token(verifier, token)

    IO.inspect("REQUEST TOKEN:")
    IO.inspect(acc_token)

    case acc_token do
      {:error, _error} ->
        conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:unauthorized, Jason.encode!(%{error: "Could not authorize twitter. PLease try again later."}))
      _ ->
        Users.update_user(user, %{oauth_token: Map.get(acc_token, "oauth_token"),
                                        oauth_token_secret: Map.get(acc_token, "oauth_token_secret")})

        user = FinalProject.Users.get_user!(user.id)
        IO.inspect(user)


        conn
          |> put_resp_header("content-type", "application/json; charset=UTF-8")
          |> send_resp(:created, Jason.encode!(%{success: "Twitter successfully authorized"}))
    end
  end

  def create(conn, %{"tweet" => tweet}) do
    user = conn.assigns[:current_user]

    access = %{"oauth_token" => user.oauth_token, "oauth_token_secret" => user.oauth_token_secret}

    IO.inspect(user)
    if (user.active_tweet) do
      conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:unauthorized, Jason.encode!(%{error: "Already have an active tweet."}))
    else
      tweet = post_status(access, tweet)
      FinalProject.TrackTweet.start(tweet.id, access, user)

      conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:created, Jason.encode!(%{}))
    end
  end
end
