require Logger

defmodule Bot do

  @moduledoc """
  # Bot
  ## Bot(s) are a module to map `code` + `data` to `holospace` Machine(s).
  ### aka. Globally Persistent Code and Data Storage Component(s).

  Bot are animated and friendly little helpers.

  Bot like to eat `Cake` and write code for `Data` and `Player`s
  and should be considered when interacting with any thing,
  static, primitive, or holospace based object(s) in need of
  holographic intelligence.

  Good Bot should be fun, simple, and enjoy `Cake` immensely.

  Learn more:
  https://lovmx.com/help/bot

  Or on the web:
  https://en.wikipedia.org/wiki/Persistent_data_structure

  tl;dr - Bot(s) manage Code for Machine Data.
  """
  
  def code(function) when is_function(function) do
    code Data.new, function
  end
  def code(data = %Data{}, function) when is_function(function) do
    # todo: better update meta
    Data.tick put_in(data.code, Enum.concat(data.code, [function]))
  end
  def code(block = [do: _]) do
    code Data.new, block
  end
  def code(data = %Data{}, block = [do: _]) do
    code data, fn data ->
      block
    end
  end
  def code(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:code, holospace, secret, duration}
  end
  
end