defmodule FinalProject.TrackTweet do
  # Tracks a given tweet (by id) with users access
  # updating food on new maximum likes within a time limit

  alias FinalProject.Users
  alias FinalProject.Users.User

  # starts async timer off
  def start(id, access, user) do
    IO.inspect("STARTED")
    IO.inspect(id)
    IO.inspect(access)
    seconds = 30 ########################### DURATION (seconds)
    Task.async(fn ->
      check(id, access, user, 0, seconds)
    end)
    0
  end

  # fetch the tweet and update if max likes is newer
  def check(id, access, user, max_likes, time_left) do
    IO.inspect("CHECKING")

    cur_likes = FinalProjectWeb.Helpers.get_likes_by_id(access, id)

    if (cur_likes > max_likes) do
      IO.inspect("INCREASE")
      gain_per_like = 100 ######################### AMOUNT (food)
      diff = cur_likes - max_likes
      FinalProject.Users.update_user(user, %{food: user.food + (gain_per_like * diff)})
    else
      IO.inspect("NO CHANGE")
    end

    wait_time = 3 ########################### FREQUENCY (seconds)
    :timer.sleep(wait_time * 1000)
    if (time_left > 0) do
      check(id, access, user, max(max_likes, cur_likes), time_left - wait_time)
    end
  end
end
