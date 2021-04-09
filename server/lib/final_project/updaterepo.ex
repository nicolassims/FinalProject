defmodule FinalProject.UpdateRepo do
  use GenServer

  alias FinalProject.Users
  alias FinalProject.Monsters
  alias FinalProjectWeb.Helpers

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    Task.async(fn ->
      loop()
    end)

    {:ok, opts}
  end

  defp loop() do
    Enum.each(Users.list_users(), fn user ->
      foodcount = Enum.reduce(user.monsters, 0, fn monster, acc ->
        if (monster.location == 0) do#if they're on the farm, then increase your food count.
          acc + round(:math.sqrt(monster.power))
        else
          Monsters.update_monster(monster, %{power: monster.power + 1})
          acc
        end
      end)
      if (foodcount > 0) do
        Users.update_user(user, %{food: user.food + foodcount})
      end
    end)

    :timer.sleep(1_000)

    Helpers.broadcast_users()
    Helpers.broadcast_monsters()

    loop()
  end
end
