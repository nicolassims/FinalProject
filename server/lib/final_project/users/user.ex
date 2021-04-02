defmodule FinalProject.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :food, :integer
    field :name, :string
    field :oauth_token, :string
    field :oauth_token_secret, :string
    field :password_hash, :string

    timestamps()

    has_many :monsters, FinalProject.Monsters.Monster
  end

  def add_password_hash(cset, nil) do
    cset
  end

  def add_password_hash(cset, password) do
    change(cset, Argon2.add_hash(password))
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password_hash, :food, :oauth_token, :oauth_token_secret])
    |> add_password_hash(attrs["password"])
    |> validate_required([:name, :password_hash, :food])
    |> unique_constraint(:name)
  end
end
