defmodule FinalProject.Repo.Migrations.ChangeNumberTypes do
  use Ecto.Migration

  def change do
    alter table("users") do
      modify :food, :bigint
    end
    alter table("monsters") do
      modify :power, :bigint
    end
  end
end
