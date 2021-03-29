defmodule FinalProjectWeb.MonsterView do
  use FinalProjectWeb, :view
  alias FinalProjectWeb.MonsterView

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
      location: monster.location}
  end
end
