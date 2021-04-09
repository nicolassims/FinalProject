defmodule FinalProjectWeb.Helpers do
  alias FinalProject.Users
  alias FinalProject.Monsters

  # get users list and simplify into simple data to send through users Channel
  def broadcast_users() do
    users = Users.list_users()
    users = Enum.map(users, fn u -> %{id: u.id, food: u.food, name: u.name} end)
    FinalProjectWeb.Endpoint.broadcast("game", "update", %{users: users})
  end

  # get monsters list and simplify into simple data to send through monsters Channel
  def broadcast_monsters() do
    monsters = Monsters.list_monsters()
    monsters = Enum.map(monsters, fn m -> %{id: m.id, user: %{id: m.user.id, food: m.user.food, name: m.user.name}, power: m.power, name: m.name, location: m.location, nickname: m.nickname} end)
    FinalProjectWeb.Endpoint.broadcast("game", "updatemonsters", %{monsters: monsters})
  end

  # 1. get request token
  def get_request_token(url \\ "http://monster-browser.tkwaffle.site/auth/twitter")  do
    IO.inspect("REsponse for Request Token")
    IO.inspect(ExTwitter.configure())
    resp = ExTwitter.request_token(url)
    IO.inspect(resp)
    resp.oauth_token
  end

  # 2. get authoprize url using token
  def get_authorize_url(token) do
    resp = ExTwitter.authorize_url(token)
    elem(resp, 1)
  end

  # 3. get access token with pin
  def get_access_token(pin, token, _third) do
    resp = ExTwitter.access_token(
      pin,
      token
    )

    resp = elem(resp, 1)

    %{"name" => resp.screen_name,
      "id" => resp.user_id,
      "oauth_token" => resp.oauth_token,
      "oauth_token_secret" => resp.oauth_token_secret}
  end

  def get_access_token(verifier, token) do
    resp = ExTwitter.API.Auth.access_token(
      verifier,
      token
    )

    IO.inspect(resp)

    case resp do
      {:error, _error} ->
        resp
      {:ok, resp_tok} ->
        %{"name" => resp_tok.screen_name,
          "id" => resp_tok.user_id,
          "oauth_token" => resp_tok.oauth_token,
          "oauth_token_secret" => resp_tok.oauth_token_secret}
    end
  end

  # set the ExTwitter config for a users oauth_token and the secret
  def set_access(access) do
    IO.inspect(access)
    config = ExTwitter.Config.get()
    %{"oauth_token" => oauth_token,
      "oauth_token_secret" => oauth_token_secret } = access

    config = config
    |> Keyword.put(:access_token, oauth_token)
    |> Keyword.put(:access_token_secret, oauth_token_secret)

    ExTwitter.Config.set(:process, config)
  end

  def get_status(access) do
    set_access(access)
    tl = ExTwitter.API.Timelines.user_timeline()
    tweet = Enum.fetch!(tl, 0)
    tweet.text
  end

  def post_status(access, status) do
    set_access(access)
    resp = ExTwitter.API.Tweets.update(status)
    resp
  end

  def get_likes_by_id(access, id) do
    set_access(access)
    tweet = ExTwitter.API.Tweets.show(id)
    tweet.favorite_count
  end
end
