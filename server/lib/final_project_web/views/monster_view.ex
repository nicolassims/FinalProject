defmodule FinalProjectWeb.MonsterView do
  use FinalProjectWeb, :view
  alias FinalProjectWeb.MonsterView
  alias FinalProjectWeb.UserView

  def render("index.json", %{monsters: monsters}) do
    %{data: render_many(monsters, MonsterView, "monster.json")}
  end

  def render("show.json", %{monster: monster}) do
    %{data: render_one(monster, MonsterView, "monster.json")}
  end

  def render("monster.json", %{monster: monster}) do
    %{id: monster.id,
      name: monster.name,
      nickname: monster.nickname,
      power: monster.power,
      location: monster.location,
      user: render_one(monster.user, UserView, "user.json")
    }
  end
end
