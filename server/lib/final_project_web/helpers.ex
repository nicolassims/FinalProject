defmodule FinalProjectWeb.Helpers do

  # 1. get request token
  def get_request_token(url \\ nil)  do
    resp = ExTwitter.request_token(url)
    IO.inspect(resp)
    resp.oauth_token
  end

  # 2. get authoprize url using token
  def get_authorize_url(token) do
    resp = ExTwitter.authorize_url(token)
    IO.inspect(resp)
    elem(resp, 1)
  end

  # 3. get access token with pin
  def get_access_token(pin, token) do
    resp = ExTwitter.access_token(
      pin,
      token
    )

    resp = elem(resp, 1)
    IO.inspect(resp)

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

    IO.inspect(config)
    ExTwitter.Config.set(:process, config)
  end

  def get_status(access) do
    set_access(access)
    tl = ExTwitter.API.Timelines.user_timeline()
    IO.inspect(tl)
    tweet = Enum.fetch!(tl, 0)
    IO.inspect(tweet)
    tweet.text
  end

  def post_status(access, status) do
    set_access(access)
    resp = ExTwitter.API.Tweets.update(status)
    IO.inspect(resp)
    resp
  end
end
