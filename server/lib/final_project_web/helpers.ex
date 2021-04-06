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
end
