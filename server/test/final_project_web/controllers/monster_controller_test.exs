defmodule FinalProjectWeb.MonsterControllerTest do
  use FinalProjectWeb.ConnCase

  alias FinalProject.Monsters
  alias FinalProject.Monsters.Monster

  @create_attrs %{
    location: 42,
    name: "some name",
    nickname: "some nickname",
    power: 42
  }
  @update_attrs %{
    location: 43,
    name: "some updated name",
    nickname: "some updated nickname",
    power: 43
  }
  @invalid_attrs %{location: nil, name: nil, nickname: nil, power: nil}

  def fixture(:monster) do
    {:ok, monster} = Monsters.create_monster(@create_attrs)
    monster
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all monsters", %{conn: conn} do
      conn = get(conn, Routes.monster_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create monster" do
    test "renders monster when data is valid", %{conn: conn} do
      conn = post(conn, Routes.monster_path(conn, :create), monster: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.monster_path(conn, :show, id))

      assert %{
               "id" => id,
               "location" => 42,
               "name" => "some name",
               "nickname" => "some nickname",
               "power" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.monster_path(conn, :create), monster: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update monster" do
    setup [:create_monster]

    test "renders monster when data is valid", %{conn: conn, monster: %Monster{id: id} = monster} do
      conn = put(conn, Routes.monster_path(conn, :update, monster), monster: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.monster_path(conn, :show, id))

      assert %{
               "id" => id,
               "location" => 43,
               "name" => "some updated name",
               "nickname" => "some updated nickname",
               "power" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, monster: monster} do
      conn = put(conn, Routes.monster_path(conn, :update, monster), monster: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete monster" do
    setup [:create_monster]

    test "deletes chosen monster", %{conn: conn, monster: monster} do
      conn = delete(conn, Routes.monster_path(conn, :delete, monster))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.monster_path(conn, :show, monster))
      end
    end
  end

  defp create_monster(_) do
    monster = fixture(:monster)
    %{monster: monster}
  end
end
