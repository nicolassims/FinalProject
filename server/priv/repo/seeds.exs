# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FinalProject.Repo.insert!(%FinalProject.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias FinalProject.Repo
alias FinalProject.Users.User
alias FinalProject.Monsters.Monster

defmodule Inject do

  def user(name, pass, food) do
    hash = Argon2.hash_pwd_salt(pass)
    Repo.insert!(%User{name: name, password_hash: hash, food: food})
  end
end

beowulf = Inject.user("beowulf", "beowulf1", 1000);
ash = Inject.user("ash", "catchemall", 0);

_medusa = Repo.insert!(%Monster{name: "Medusa", nickname: "Dusa", power: 6, location: 0, user_id: beowulf.id})
_pikachu = Repo.insert!(%Monster{name: "Pikachu", nickname: "Pika", power: 9001, location: 0, user_id: ash.id})
