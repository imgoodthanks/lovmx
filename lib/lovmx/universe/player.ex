require Logger

defmodule Player do

  @moduledoc """
  # Player
  ## Interactive User Agent Component(s)
  
  Advanced Bot-like creatures that create and destroy 
  inside the LovMx Orbital Bootspace Network. ;)
  """

  @doc "Sweet prince."
  def anon(secret \\ Help.keycode) do
    Data.new
    |> Boot.move secret
  end

  # @doc "Get details from the Player."
  # def quiz(topic, secret \\ Help.keycode) do
  #   topic
  #   |> Data.new(secret)
  #   |> Boot.space
  # end
  #
  # @doc "Sweet prince."
  # def items(secret \\ Help.keycode) do
  #   Boot.space("player")
  # end
  #
  # @doc "Ask/broadcast to please take stuff from `player`."
  # def take(player, holospace, secret \\ nil) do
  #   #Cloud.share "Player::grab:bot:#{inspect player}"
  #
  #   ##GenServer.call(PlayerServer, {:data, self, holospace, secret})
  #
  #   player
  # end
  # def handle_cast({:data, source, holospace, secret}, computer) do
  #   #Cloud.share "Player.handle_call::grab: #{holospace} (#{inspect source})"
  #
  #   #send source, Boot.space(computer, holospace, secret)
  #
  #   {:noreply, computer}
  # end
  #
  # @doc "Anonymously grab and put stuff into `Player.items`."
  # def loot(player, data) do
  #   #Cloud.share "Player::grab:holospace:#{inspect player}"
  #
  #   #GenServer.call(PlayerServer, {:loot, player})
  # end
  # def handle_call({:loot, player}, source, computer) do
  #   ###Cloud.share "Player.handle_call:::loot: #{inspect player} (#{inspect computer})"
  #
  #   # TODO: grab stuff
  #
  #   {:reply, Player.items, computer}
  # end

end


