defmodule FinalProject.TrackTweet do
  # Tracks a given tweet (by id) with users access
  # updating food on new maximum likes within a time limit

  alias FinalProject.Users
  alias FinalProjectWeb.Helpers

  # starts async timer off
  def start(id, access, user) do
    seconds = 60 ########################### DURATION (seconds)
    Users.update_user(user, %{active_tweet: true})
    IO.inspect("Active")
    user = Users.get_user_by_name!(user.name)
    IO.inspect(user)

    Task.async(fn ->
      check(id, access, user, 0, seconds)
    end)
    0
  end

  # fetch the tweet and update if max likes is newer
  def check(id, access, user, max_likes, time_left) do
    IO.inspect("CHECKING TWEET")

    cur_likes = FinalProjectWeb.Helpers.get_likes_by_id(access, id)

    if (cur_likes > max_likes) do
      IO.inspect("INCREASE")
      user = Users.get_user_by_name!(user.name) # Need to update user or amount will not be accurate

      factor = 0.05 ######################### FACTOR (of total food)
      gain_per_like = round(factor * user.food)
      diff = cur_likes - max_likes


      Users.update_user(user, %{food: user.food + (gain_per_like * diff)})
      Helpers.broadcast_users()
    else
      IO.inspect("NO CHANGE")
    end

    wait_time = 3 ########################### FREQUENCY (seconds)
    :timer.sleep(wait_time * 1000)
    if (time_left > 0) do
      check(id, access, user, max(max_likes, cur_likes), time_left - wait_time)
    else
      Users.update_user(user, %{active_tweet: false})
      user = Users.get_user_by_name!(user.name)
      IO.inspect("Inactive")
      IO.inspect(user)
    end
  end
end
