defmodule FinalProjectWeb.Helpers do
  alias FinalProject.Users


  # get users list and simplify into simple data to send through users Channel
  def broadcast_users() do
    users = Users.list_users()
    users = Enum.map(users, fn u -> %{id: u.id, food: u.food, name: u.name} end)
    FinalProjectWeb.Endpoint.broadcast("game", "update", %{users: users})
  end

  # 1. get request token
  def get_request_token(url \\ nil)  do
    config = ExTwitter.configure()
    resp = ExTwitter.request_token(url)
    resp.oauth_token
  end

  # 2. get authoprize url using token
  def get_authorize_url(token) do
    resp = ExTwitter.authorize_url(token)
    elem(resp, 1)
  end

  # 3. get access token with pin
  def get_access_token(pin, token) do
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
