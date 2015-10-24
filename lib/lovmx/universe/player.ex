require Logger

defmodule Player do

  @moduledoc """
  # Player
  ## Interactive User Agent Component(s)
  
  Advanced Bot-like creatures that create and destroy 
  inside the LovMx Orbital Holospace Network. ;)
  """

  @doc "Sweet prince."
  def anon(secret \\ Help.keycode) do
    Data.new
    |> Holo.move secret
  end

  # @doc "Get details from the Player."
  # def quiz(topic, secret \\ Help.keycode) do
  #   topic
  #   |> Data.new(secret)
  #   |> Holo.space
  # end
  #
  # @doc "Sweet prince."
  # def items(secret \\ Help.keycode) do
  #   Holo.space("player")
  # end
  #
  # @doc "Ask/broadcast to please take stuff from `player`."
  # def take(player, holospace, secret \\ nil) do
  #   #Holo.share "Player::grab:bot:#{inspect player}"
  #
  #   ##GenServer.call(PlayerServer, {:data, self, holospace, secret})
  #
  #   player
  # end
  # def handle_cast({:data, source, holospace, secret}, computer) do
  #   #Holo.share "Player.handle_call::grab: #{holospace} (#{inspect source})"
  #
  #   #send source, Holo.space(computer, holospace, secret)
  #
  #   {:noreply, computer}
  # end
  #
  # @doc "Anonymously grab and put stuff into `Player.items`."
  # def loot(player, data) do
  #   #Holo.share "Player::grab:holospace:#{inspect player}"
  #
  #   #GenServer.call(PlayerServer, {:loot, player})
  # end
  # def handle_call({:loot, player}, source, computer) do
  #   ###Holo.share "Player.handle_call:::loot: #{inspect player} (#{inspect computer})"
  #
  #   # TODO: grab stuff
  #
  #   {:reply, Player.items, computer}
  # end

end


