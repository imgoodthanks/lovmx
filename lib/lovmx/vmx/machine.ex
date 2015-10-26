require Logger

defmodule Machine do
    
  @moduledoc """
  # Machine
  ## Machine
  ### Machine
  """
  
  use GenServer
  use Connection
  import Kind
  
  @doc "Machine"
  def boot(data = %Data{}) do
    link = {:ok, machine} = Machine.start_link(data)
    #Logger.debug "Machine.boot // #{inspect machine} // #{inspect data}"
    
    machine
  end
  
  @doc "Machine"
  def compute(machine, secret \\ nil, duration \\ Help.tock) when is_pid(machine) do
    GenServer.call machine, {flow, secret, duration}
  end
  def compute(nada, _, _) when is_nil(nada) do
    # TODO: log a Kind.drop w/ the wiz
    
    nil
  end
  
  ## Callbacks
  # Listen for replies to various signal `Kind`s. See `cake.ex` to learn more
  # about Machine Magic and how it works.
  
  def handle_call({flow, secret, duration}, source, agent) do
    # Init + Compile + Exe a full Data/Flow..
    data = Agent.get agent, &(&1)
    
    # PULL: Data.pull things into here
    {_, pull_list} = Enum.map_reduce data.pull, Map.new, fn {key, value}, current ->
      Logger.debug ">>> // #{inspect key} // #{inspect value} // #{inspect current}"    
      case {key, value} do
        # put in static/atomic data via a straight data.pull -> `value`
        {key, value} when is_atom(key) and is_atom(value) ->
          {key, value}

        # put in dynamic/holospace data via a Cloud.space
        {key, value} when is_atom(key) or is_binary(key) ->
          {key, Cloud.space(key)}

        # TODO: better support here
        _ -> 
          {key, Kind.drop}
      end
    end
    Logger.debug "PULL>LIST // #{inspect pull_list}"    
    
    # COMPUTE: exe Data.code and effects
    Enum.map data.code, fn x ->
      Help.thaw(x).(data)
    end

    # Update all nubspace that this data has just pinged
    Enum.each data.push, fn {key, value} ->
      case {key, value} do
        # a process, so send a :data message
        {key, value} when is_pid(value) ->
          GenServer.call key, {Kind.pull, key, secret, duration}

        {key, value} when is_atom(value) or is_binary(value) ->
          Cloud.x(data, key, secret)
          
        _ -> nil
      end
    end
    
    # update map/space
    :ok = Agent.update agent, fn data -> data end
      
    {:reply, data, agent}
  end
  
  def handle_call({boot, holospace, secret, duration}, source, agent) do
    {:reply, Agent.get(agent, &(&1)), agent}
  end

  def handle_call({lock, holospace, secret, duration}, source, agent) do
    # TODO: globally capture this holospace as ours

    {:reply, Agent.get(agent, &(&1)), agent}
  end

  def handle_call({meta, signal, effect}, source, agent) do
    :ok = Agent.update agent, fn data ->
      Data.meta(data, signal, effect)
    end

    {:reply, Agent.get(agent, &(&1)), agent}
  end

  def handle_call({list, holospace, secret, duration}, source, agent) do
    data = Agent.get(agent, &(&1))

    {:reply, data.thing, agent}
  end

  def handle_call({pull, holospace, secret, duration}, source, agent) do
    :ok = Agent.update agent, fn data ->
      data = Enum.map data.pull, fn {signal, message} ->
        Flow.pull(data, signal)
      end |> List.first
    end

    {:reply, Agent.get(agent, &(&1)), agent}
  end

  def handle_call({code, holospace, secret, duration}, source, agent) do
    {:reply, Agent.get(agent, &(&1)).code, agent}
  end

  def handle_call({push, holospace, secret, duration}, source, agent) do
    :ok = Agent.update agent, fn data ->
      Enum.each data.push, fn signal ->
        Flow.push(data, signal)
      end

      data
    end

    {:reply, Agent.get(agent, &(&1)), agent}
  end

  def handle_call({wait, holospace, secret, duration}, source, agent) do
    {:reply, Agent.get(agent, &(&1)), agent}
  end

  def handle_call({drop, holospace, secret, duration}, source, agent) do
    # spawn a task and forget it

    {:reply, Agent.get(agent, &(&1)), agent}
  end
    
  @doc "Machine"
  def start_link(data = %Data{}) do
    # Create an Agent for our state, which also gets us
    # an extra or secondary process to do longer map updates/etc
    # outside of the Bot's own process.
    {:ok, agent} = Agent.start_link fn -> data end
    
    link = {:ok, machine} = GenServer.start_link(Machine, agent, debug: [])
    #Logger.debug "Machine.start_link #{data.keycode}"
    
    # update the data to include our Machine home
    :ok = Agent.update agent, fn data -> 
      Cloud.home data, machine 
    end
    
    link
  end
  def start_link(thing) do
    start_link(Data.new thing)
  end
   
end
