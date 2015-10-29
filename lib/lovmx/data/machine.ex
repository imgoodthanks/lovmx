require Logger

defmodule Machine do
    
  @moduledoc """
  # Machine
  ## Code + Data
  ### FBP Component / Process
  """
  
  use GenServer
  import Kind
  
  ## APIs

  def start_link(data = %Data{}, secret \\ nil, duration \\ Help.tock) do
    # Create an Agent for our state, which also gets us
    # an extra or secondary process to do longer map updates/etc
    # outside of the Bot's own process.
    {:ok, agent} = Agent.start_link fn -> data end
    
    link = {:ok, machine} = GenServer.start_link(Machine, agent, debug: [])
        
    link
  end
  
  def data(machine, secret \\ nil, duration \\ Help.tock) when is_pid(machine) do
    GenServer.call machine, {:data, secret, duration}
  end
  
  def meta(machine, signal, effect \\ nil) when is_pid(machine) do
    GenServer.call machine, {:meta, signal, effect}
  end

  # def lock(machine, secret) when is_pid(machine) do
  #   GenServer.call machine, {:lock, secret}
  # end

  def list(machine, secret \\ nil) when is_pid(machine) do
    GenServer.call machine, {:list, secret}
  end

  def pull(machine, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call machine, {:pull, holospace, secret, duration}
  end

  def push(machine, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call machine, {:push, secret, duration}
  end

  def flow(machine, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call machine, {:flow, holospace, secret, duration}
  end
  
  # def wait(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
  #   # TODO: register a callback w/ Holo to trigger on holospace, then hibernate
  # end

  def drop(machine, secret \\ nil) when is_pid(machine) do
    GenServer.call machine, {:drop, secret}
  end

  ########################################################
  ########################################################  
  ## Callbacks
  ########################################################
  ########################################################

  def handle_call({meta, signal, effect}, source, agent) do
    :ok = Agent.update agent, fn data ->
      Data.meta(data, signal, effect)
    end

    {:reply, Agent.get(agent, &(&1)), agent}
  end

  # def handle_call({lock, holospace, secret, duration}, source, agent) do
  #   # TODO: globally capture this holospace as ours
  #
  #   {:reply, Agent.get(agent, &(&1)), agent}
  # end

  def handle_call({list, holospace, secret, duration}, source, agent) do
    data = Agent.get(agent, &(&1))

    {:reply, data.thing, agent}
  end

  def handle_call({pull, holospace, secret, duration}, source, agent) do
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
  
  def handle_call({flow, secret, duration}, source, agent) do
    # Init + Compile + Exe a full Data/Flow..
    data = Agent.get agent, &(&1)
    
    # COMPUTE: exe Data.code and effects
    Enum.map data.code, fn x ->
      Help.thaw(x).(data)
    end

    {:reply, data, agent}
  end
  
  def handle_call({push, holospace, secret, duration}, source, agent) do
    
    
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

  def handle_call({code, holospace, secret, duration}, source, agent) do
    {:reply, Agent.get(agent, &(&1)).code, agent}
  end
  
  # def handle_call({wait, holospace, secret, duration}, source, agent) do
  #   {:reply, Agent.get(agent, &(&1)), agent}
  # end

  def handle_call({drop, secret}, source, agent) do  
    Agent.stop(agent)
    
    {:stop, :normal, nil}
  end
   
end
