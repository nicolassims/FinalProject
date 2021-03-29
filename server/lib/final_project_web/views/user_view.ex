defmodule FinalProjectWeb.UserView do
  use FinalProjectWeb, :view
  alias FinalProjectWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      password_hash: user.password_hash,
      food: user.food,
      oauth_token: user.oauth_token,
      oauth_token_secret: user.oauth_token_secret}
  end
end
