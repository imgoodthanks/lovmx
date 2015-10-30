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

  use GenServer
  import Kind
  
  ## APIs

  def start_link(data = %Data{}, secret \\ nil, duration \\ Help.tock) do
    # Create an Agent for our state, which also gets us
    # an extra or secondary process to do longer map updates/etc
    # outside of the Bot's own process.
    {:ok, agent} = Agent.start_link fn -> data end
    
    link = {:ok, bot} = GenServer.start_link(Bot, agent, debug: [])
        
    link
  end
  
  def fresh(data = %Data{}, secret \\ nil, duration \\ Help.tock) do
    {:ok, bot} = Bot.start_link(data, secret, duration)
    
    bot
  end
  
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
  
  ## Callbacks
  ########################################################
  ########################################################

  def handle_call({:meta, :upgrade, newdata}, source, agent) do
    :ok = Agent.update agent, fn data ->
      Data.tick(newdata)
    end
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  def handle_call({:meta, generic, effect}, source, agent) do
    :ok = Agent.update agent, fn data ->
      Data.meta(data, generic, effect)
    end

    {:reply, Agent.get(agent, &(&1)), agent}
  end

  
  def handle_call({:lock, holospace, secret, duration}, source, agent) do
    # TODO: globally capture this holospace as ours

    {:reply, Agent.get(agent, &(&1)), agent}
  end

  def handle_call({:list, holospace, secret, duration}, source, agent) do
    data = Agent.get(agent, &(&1))

    {:reply, data.thing, agent}
  end

  def handle_call({:pull, holospace, secret, duration}, source, agent) do    
    # Init + Compile + Exe a full Data/Flow..
    data = Agent.get agent, &(&1)
    
    # PULL: Data.pull things into here
    {_, pull_list} = Enum.map_reduce data.pull, Map.new, fn {key, value}, current ->
      case {key, value} do
        # put in static/atomic data via a straight data.pull -> `value`
        {key, value} when is_atom(key) and is_atom(value) ->
          {key, value}

        # put in dynamic/holospace data via a Holo.space
        {key, value} when is_atom(key) or is_binary(key) ->
          {key, Holo.space(key)}
          
        _ ->
          {key, Kind.drop}
      end
    end
    
    :ok = Agent.update agent, fn data ->
      put_in data.pull, pull_list
    end
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:code, holospace, secret, duration}, source, agent) do
    {:reply, Agent.get(agent, &(&1)).code, agent}
  end
  
  def handle_call({:flow, secret, duration}, source, agent) do
    # Init + Compile + Exe a full Data/Flow..
    data = Agent.get agent, &(&1)
    
    # COMPUTE: exe Data.code and effects
    Enum.map data.code, fn x ->
      Help.thaw(x).(data)
    end

    {:reply, data, agent}
  end
  
  def handle_call({:push, holospace, secret, duration}, source, agent) do
    data = Agent.get agent, &(&1)
    
    # Update all holospace that this data has just pinged
    Enum.each data.push, fn {key, value} ->
      case {key, value} do
        # a process, so send a :data message
        {key, value} when is_pid(value) ->
          GenServer.call key, {Kind.pull, key, secret, duration}

        {key, value} when is_atom(value) or is_binary(value) ->
          Holo.boost(data, key, secret)

        _ -> nil
      end
    end

    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:wait, holospace, secret, duration}, source, agent) do
    {:reply, Agent.get(agent, &(&1)), agent}
  end

  def handle_call({:drop, secret}, source, agent) do  
    Agent.stop(agent)
    
    {:stop, :normal, nil}
  end

end