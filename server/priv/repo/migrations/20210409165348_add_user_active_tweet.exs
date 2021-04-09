defmodule FinalProject.Repo.Migrations.AddUserActiveTweet do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :active_tweet, :boolean
    end
  end
end
