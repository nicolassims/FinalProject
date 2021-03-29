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

beowulf = Repo.insert!(%User{name: "beowulf", password_hash: "beowulf1", food: 1000})
ash = Repo.insert!(%User{name: "ash", password_hash: "catchemall", food: 0})
