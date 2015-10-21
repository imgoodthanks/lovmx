require Logger

defmodule Player do

  @moduledoc """
  # Player
  ## Interactive User Agent Component(s)
  
  Advanced Bot-like creatures that create and destroy 
  inside the LovMx Orbital Nubspace Network. ;)
  """

  @doc "Sweet prince."
  def anon(secret \\ Lovmx.keycode) do
    Data.new
    |> Holo.move secret
  end

  # @doc "Get details from the Player."
  # def quiz(topic, secret \\ Lovmx.keycode) do
  #   topic
  #   |> Data.new(secret)
  #   |> Holo.pull
  # end
  #
  # @doc "Sweet prince."
  # def items(secret \\ Lovmx.keycode) do
  #   Holo.pull("player")
  # end
  #
  # @doc "Ask/broadcast to please take stuff from `player`."
  # def take(player, nubspace, secret \\ nil) do
  #   #Holo.share "Player::grab:bot:#{inspect player}"
  #
  #   ##GenServer.call(PlayerServer, {:data, self, nubspace, secret})
  #
  #   player
  # end
  # def handle_cast({:data, source, nubspace, secret}, computer) do
  #   #Holo.share "Player.handle_call::grab: #{nubspace} (#{inspect source})"
  #
  #   #send source, Holo.pull(computer, nubspace, secret)
  #
  #   {:noreply, computer}
  # end
  #
  # @doc "Anonymously grab and put stuff into `Player.items`."
  # def loot(player, data) do
  #   #Holo.share "Player::grab:nubspace:#{inspect player}"
  #
  #   #GenServer.call(PlayerServer, {:loot, player})
  # end
  # def handle_call({:loot, player}, source, computer) do
  #   ###Holo.share "Player.handle_call:::loot: #{inspect player} (#{inspect computer})"
  #
  #   #todo: grab stuff
  #
  #   {:reply, Player.items, computer}
  # end

end


