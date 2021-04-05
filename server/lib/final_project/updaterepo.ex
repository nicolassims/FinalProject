defmodule FinalProject.UpdateRepo do
  use GenServer

  alias FinalProject.Repo
  alias FinalProject.Users

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    Users.list_users()
    |> loop()

    {:ok, opts}
  end

  defp loop(userlist) do
    Enum.each(userlist, fn user ->
      newfood = user.food + 1
      #IO.inspect("newfood")
      #IO.inspect(newfood)

      changeset = Users.change_user(user, %{food: newfood})
      #IO.inspect("changeset")
      #IO.inspect(changeset)


      update = Repo.update(changeset)
      IO.inspect("update")
      IO.inspect(update)
      #Users.change_user(user, %{food: newfood})
      #IO.inspect(user.food)
    end)
  end
end
