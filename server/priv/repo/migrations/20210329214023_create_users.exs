defmodule FinalProject.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :password_hash, :string, null: false
      add :food, :integer, null: false
      add :oauth_token, :string
      add :oauth_token_secret, :string

      timestamps()
    end

    create unique_index(:users, [:name])

  end
end
