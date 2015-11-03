require Logger

defmodule Flow do
  
  @moduledoc """
  # Flow
  ## Real-time Map of Active/Unique Data in Motion.
  
  A data flow is the basic layout of an `application` or are the 
  Modules you need to define and respond to the various other 
  Data/Flow signal types, stacking and plugging your modules into 
  all the available framework signals. 
  
  For example a Bot produces something that Flows into a Pipe and
  out to the Universe and Multiverse modules that people see and use.
  """
  
  use GenServer

  ## META
  
  @doc "Use `Flow.beam` to return all Data."
  def beam(secret \\ nil) do
    GenServer.call FlowServer, {:beam, secret}
  end

  ## BOOT
  
  @doc "Boot or Upgrade `data` inside in the *BACKGROUND*."
  def x(data = %Data{}, secret \\ nil, duration \\ Help.long) do
    # async update of data
    Task.async fn ->
      if not is_pid(data.home) do
        boot(data, secret, duration)
      else
        upgrade(data, secret)
      end
    end

    # return immedately w/ original data
    data
  end
  
  @doc "Start a `data` flow inside the Universal Flow."
  def boot(data = %Data{}, secret \\ nil, duration \\ Help.long) do
    GenServer.call FlowServer, {:boot, data, secret, duration}
  end
  
  @doc "Upgrade data in the Universal Flow w/ optional new data."
  def upgrade(data = %Data{}, thing, secret \\ nil) do
    if thing, do: data = Flow.take(data, thing, secret)
    
    data = Data.tick data
    
    Task.async fn ->
      match data, Kind.data
    end
    
    data
  end
  
  ## GRAPH
  
  @doc "Put `match` into `Flow.beam` to return `thing` when `Flow.graph <thing>` matches."
  def match(match = %Data{}, thing, secret \\ nil) when not is_nil(thing) do
    GenServer.call FlowServer, {:match, match, thing, secret}
  end
  
  @doc "Collect Data through all Data Flows."
  def graph(thing, secret \\ nil, duration \\ Help.tock)
  
  def graph(data = %Data{}, secret, duration) do
    GenServer.call FlowServer, {:graph, data, secret, duration}
  end
  def graph(things, secret, duration) do
    Enum.map things, fn data -> 
      GenServer.call FlowServer, {:graph, data, secret, duration}
    end
  end
  
  ## IN
  
  @doc "Put `thing` *INTO* `data.thing`."
  def take(data = %Data{home: bot}, thing, secret \\ nil) do
    put_in(data.thing, thing)
    |> upgrade(nil)
  end
  
  @doc "Put `thing` *INTO* `data.pull` at `signal`."
  def feed(thing, data = %Data{}, signal, secret \\ nil) when is_atom(signal) or is_binary(signal) do
    put_in(data.pull, Map.update(data.pull, signal, [thing], fn take -> 
      take
      |> Enum.concat([thing])
      |> List.flatten
      |> List.wrap
    end))
    |> upgrade(nil)
  end
  
  @doc "Map `holospace` *INTO* `data.pull`."
  def pull(data = %Data{}, holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    put_in(data.pull, Map.put(data.pull, holospace, Kind.boot))
    |> upgrade(nil)
  end
    
  ## OUT
  
  @doc "From `data` *to* `holospace` in the *BACKGROUND*."
  def push(data = %Data{}, holospace, secret \\ nil) do
    put_in(data.push, Map.put(data.push, holospace, Kind.push))
    |> upgrade(nil)
  end
  
  @doc "From `data` *to* `holospace` and *WAIT*."
  def wait(data = %Data{}, holospace, secret \\ nil) do
    # todo: call/receive for a data/signal from `holospace`
    put_in(data.push, Map.put(data.push, holospace, Kind.wait))
    |> upgrade(nil)
  end
  
  ## GenServer

  # start an active data -> session.
  def handle_call({:boot, data = %Data{}, secret, duration}, source, agent) do
    # put the bot into the data
    data = Data.home(data, self)
    
    # put the data/bot into the flow
    Task.async fn ->
      Flow.match(data, data)
    end
    
    {:reply, data, agent}
  end
  
  # add match to the Universal Flow
  def handle_call({:match, match = %Data{}, thing, secret}, source, agent) do
    # update map/match -> match/data
    :ok = Agent.update agent, fn map ->
      Map.put map, thing, match
    end
      
    # return the thing so it can be piped
    {:reply, match, agent}
  end
  
  # collect all things from the Univeral Flow of data
  def handle_call({:graph, data = %Data{}, secret, duration}, source, agent) do
    motion = Agent.get(agent, &(&1))
    
    # Feed
    data = Enum.reduce motion, data, fn {thing, match}, data ->
      if match = data do
        Flow.feed(thing, data, :graph, secret)
      end
    end
    #Logger.warn ">>> Flow:graph #{inspect data}"
    
    # Pull
    pull_map = Enum.reduce data.pull, Map.new, fn {key, value}, current ->
      #Logger.warn ">>> Flow:pull_map #pull // #{inspect key} // #value // #{inspect value}"
      
      # So we are enum'ing %Data{pull: %{key1: value1, key2: value2}}
      case {key, value} do
        {:pull, holospace} ->
          #Logger.warn "@@@ Flow:pull // #key // #{inspect key}"
          {key, value}

        _ ->
          #Logger.warn "@@@ Flow:any // #key // #{inspect key}"
          
          {key, Kind.drop}
      end
    end
    
    # Code
    Enum.map data.code, fn x ->
      #Logger.warn "@@@ Flow:code // #x // #{inspect x}"
  
      data = Help.thaw(x).(data)
    end

    # # Push
    Enum.each data.push, fn {key, value} ->
      case {key, value} do
        # a process, so send a :data message
        {key, value} when is_pid(value) ->
          Logger.warn "@@@ Flow:pid // #key // #{inspect key}"
          
        {key, value} when is_atom(value) or is_binary(value) ->
          Logger.warn "@@@ Flow:atom // #key // #{inspect key}"
          
          Holo.boost(data, key, secret)
          
        _ -> nil
      end
    end

    # return the data
    {:reply, data, agent}
  end
    
  # return *all* active Flow data.
  def handle_call({:beam, _secret}, source, agent) do
    #todo: support secret/access/codes
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
      
  @doc "Start the named FlowServer process."
  def start_link(_) do
    # An agent that we'll eventually pass around to *all* the Flow servers...
    link = {:ok, agent} = Agent.start_link(fn -> Map.new end)
    
    # Keep the map in memory for fluffiness.
    link = {:ok, holo} = GenServer.start_link(Flow, agent, name: FlowServer, debug: [])
    Logger.info "Flow.start_link #{inspect link}"
    
    link
  end
  
end
