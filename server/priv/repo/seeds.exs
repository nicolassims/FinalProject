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

beowulf = Repo.insert!(%User{name: "beowulf", password_hash: "beowulf1", food: 1000})
ash = Repo.insert!(%User{name: "ash", password_hash: "catchemall", food: 0})

_medusa = Repo.insert!(%Monster{name: "Medusa", nickname: "Dusa", power: 6, location: 0, user_id: beowulf.id})
_pikachu = Repo.insert!(%Monster{name: "Pikachu", nickname: "Pika", power: 9001, location: 0, user_id: ash.id})
