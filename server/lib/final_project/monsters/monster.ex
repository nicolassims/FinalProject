defmodule FinalProject.Monsters.Monster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "monsters" do
    field :location, :integer
    field :name, :string
    field :nickname, :string
    field :power, :integer
    #field :user_id, :id

    timestamps()

    belongs_to :user, FinalProject.Users.User
  end

  @doc false
  def changeset(monster, attrs) do
    monster
    |> cast(attrs, [:name, :nickname, :power, :location, :user_id])
    |> validate_required([:name, :nickname, :power, :location, :user_id])
  end
end
