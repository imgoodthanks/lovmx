require Logger

defmodule Bot do

  @moduledoc """
  # Bot
  ## Bot(s) are a module to map `code` + `data` to `holospace` Bot(s).
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

  tl;dr - Bot(s) manage Code and Data.
  """

  ## APIs
  
  def data(bot, secret \\ nil, duration \\ Help.tock) when is_pid(bot) do
    GenServer.call bot, {:data, secret, duration}
  end
  
  def upgrade(bot, data = %Data{}, secret \\ nil) when is_pid(bot) do
    GenServer.call bot, {:meta, :upgrade, data}
  end
  
  def meta(bot, signal, effect \\ nil) when is_pid(bot) do
    GenServer.call bot, {:meta, signal, effect}
  end

  def lock(bot, secret) when is_pid(bot) do
    GenServer.call bot, {:lock, secret}
  end

  def list(bot, secret \\ nil) when is_pid(bot) do
    GenServer.call bot, {:list, secret}
  end

  def pull(bot, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(bot) do
    GenServer.call bot, {:pull, holospace, secret, duration}
  end

  def code(text) when is_binary(text) do
    # todo: better update meta
    text
    |> Data.new
    |> Cake.magic
  end
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
  def code(data = %Data{home: bot}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(bot) do
    GenServer.call data.home, {:code, holospace, secret, duration}
  end
  
  def flow(bot, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(bot) do
    GenServer.call bot, {:flow, holospace, secret, duration}
  end

  def push(bot, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(bot) do
    GenServer.call bot, {:push, secret, duration}
  end
  
  def wait(data = %Data{home: bot}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(bot) do
    # TODO: register a callback w/ Holo to trigger on holospace, then hibernate
  end

  def drop(bot, secret \\ nil) when is_pid(bot) do
    GenServer.call bot, {:drop, secret}
  end
  
end