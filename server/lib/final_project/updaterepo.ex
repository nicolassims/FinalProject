defmodule FinalProject.UpdateRepo do
  use GenServer

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

  defp loop(list) do
    Enum.each(list, fn x ->
      IO.inspect(x)
    end)
  end
end
