defmodule FinalProject.UpdateRepo do
  use GenServer

  alias FinalProject.Repo
  alias FinalProject.Users

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
      newfood = user.food + 1
      changeset = Users.change_user(user, %{food: newfood})
      Repo.update(changeset)
    end)

    :timer.sleep(1_000)

    loop()
  end
end
