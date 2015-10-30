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
  
  @doc "Use `Flow.motion` to return all Data."
  def motion(secret \\ nil) do
    GenServer.call FlowServer, {:motion, secret}
  end
  
  @doc "Use `Flow.collect` to return specific Data."
  def collect(data = %Data{}, secret \\ nil) do
    GenServer.call FlowServer, {:collect, data, secret}
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
    if thing, do: data = put_in(data.thing, thing)
      
    data
    |> Data.tick
    |> match Kind.data
  end
  
  ## GRAPH
  
  @doc "Return `data` if flow is a `match`."
  def match(match = %Data{}, thing, secret \\ nil, duration \\ Help.tock) when not is_nil(thing) do
    GenServer.call FlowServer, {:match, match, thing, secret, duration}
  end
  
  @doc "Collect Data through all Data Flows."
  def graph(data = %Data{}, secret \\ nil, duration \\ Help.tock) do
    GenServer.call FlowServer, {:graph, data, secret, duration}
  end
  
  ## IN
  
  @doc "Put `thing` *INTO* `data.thing`."
  def take(data = %Data{home: bot}, thing, secret \\ nil) do
    put_in(data.thing, thing)
    |> upgrade(nil)
  end
  
  @doc "Put `thing` *INTO* `data.pull` at `signal`."
  def feed(thing, data = %Data{}, signal \\ nil, secret \\ nil) when is_atom(signal) or is_binary(signal) do
    put_in(data.pull, Map.update(data.pull, signal, [thing], fn take -> Enum.conact [take|thing] end))
    |> upgrade(nil)
  end
  
  @doc "Map `holospace` *INTO* `data.pull`."
  def pull(data = %Data{home: bot}, holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    put_in(data.pull, Map.put(data.pull, holospace, Kind.boot))
    |> upgrade(nil)
  end

  # @doc "Walk `holospace` and put into `data.pull`."
  # def walk(data, holospace \\ "/", secret \\ nil) when is_pid(bot) and is_atom(holospace) or is_binary(holospace) do
  #   list = Holo.space(holospace, secret)
  #
  #   unless Enum.empty? list do
  #     data = List.first Stream.map list, fn path ->
  #       data = Flow.pull(data, path, secret)
  #     end
  #   end
  # end
  
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
      Flow.match(data, Kind.data)
    end
    
    {:reply, data, agent}
  end
  
  # add match to the Universal Flow
  def handle_call({:match, match = %Data{}, thing, secret, duration}, source, agent) do
    Logger.warn "Flow:match #{inspect match} // #{inspect thing}"
    
    # update map/match -> match/data
    :ok = Agent.update agent, fn map ->
      Map.put map, thing, match
    end
    
    # return the thing so it can be piped
    {:reply, match, agent}
  end
  
  # collect all things from the Univeral Flow of data
  def handle_call({:graph, data = %Data{}, secret, duration}, source, agent) do
    Logger.debug "Flow:graph #{inspect data}"
    
    motion = Agent.get(agent, &(&1))
      
    Enum.map motion, fn {thing, match} ->
      Logger.debug "match >>> THING #{inspect thing} // MATCH #{inspect match}"
    
      if not is_nil(data) do
        if data == match do
          data = Flow.pull(data, match)
        end
      end
    end
        
    # return the data
    {:reply, data_from_agent(agent, data), agent}
  end
    
  # return *all* active Flow data.
  def handle_call({:motion, _secret}, source, agent) do
    #todo: support secret/access/codes
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  # return a specific Data Flow.
  def handle_call({:collect, data = %Data{}, secret}, source, agent) do
    #todo: support secret/access/codes
    {:reply, data_from_agent(agent, data), agent}
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
  
  ## Private
  
  defp data_from_agent(agent, data, secret \\ nil) do
    map = Agent.get(agent, &(&1))
    
    value = Map.get(map, data)
    thing = nil

    case value do
      value = :data -> 
        thing = data
      value when is_pid(value) ->
        thing = Bot.data(value, secret)
      _ -> 
        thing = data
    end
  end
  
end
