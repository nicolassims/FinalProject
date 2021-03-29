defmodule FinalProject.MonstersTest do
  use FinalProject.DataCase

  alias FinalProject.Monsters

  describe "monsters" do
    alias FinalProject.Monsters.Monster

    @valid_attrs %{location: 42, name: "some name", nickname: "some nickname", power: 42}
    @update_attrs %{location: 43, name: "some updated name", nickname: "some updated nickname", power: 43}
    @invalid_attrs %{location: nil, name: nil, nickname: nil, power: nil}

    def monster_fixture(attrs \\ %{}) do
      {:ok, monster} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Monsters.create_monster()

      monster
    end

    test "list_monsters/0 returns all monsters" do
      monster = monster_fixture()
      assert Monsters.list_monsters() == [monster]
    end

    test "get_monster!/1 returns the monster with given id" do
      monster = monster_fixture()
      assert Monsters.get_monster!(monster.id) == monster
    end

    test "create_monster/1 with valid data creates a monster" do
      assert {:ok, %Monster{} = monster} = Monsters.create_monster(@valid_attrs)
      assert monster.location == 42
      assert monster.name == "some name"
      assert monster.nickname == "some nickname"
      assert monster.power == 42
    end

    test "create_monster/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monsters.create_monster(@invalid_attrs)
    end

    test "update_monster/2 with valid data updates the monster" do
      monster = monster_fixture()
      assert {:ok, %Monster{} = monster} = Monsters.update_monster(monster, @update_attrs)
      assert monster.location == 43
      assert monster.name == "some updated name"
      assert monster.nickname == "some updated nickname"
      assert monster.power == 43
    end

    test "update_monster/2 with invalid data returns error changeset" do
      monster = monster_fixture()
      assert {:error, %Ecto.Changeset{}} = Monsters.update_monster(monster, @invalid_attrs)
      assert monster == Monsters.get_monster!(monster.id)
    end

    test "delete_monster/1 deletes the monster" do
      monster = monster_fixture()
      assert {:ok, %Monster{}} = Monsters.delete_monster(monster)
      assert_raise Ecto.NoResultsError, fn -> Monsters.get_monster!(monster.id) end
    end

    test "change_monster/1 returns a monster changeset" do
      monster = monster_fixture()
      assert %Ecto.Changeset{} = Monsters.change_monster(monster)
    end
  end
end
