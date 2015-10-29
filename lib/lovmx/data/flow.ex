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
  
  @doc "Use `Flow.motion` to return all <signals>."
  def motion(secret \\ nil) do
    GenServer.call FlowServer, {:motion, secret}
  end
  
  @doc "Update `data` inside the Universal Flow in the *BACKGROUND*."
  def x(data = %Data{}, secret \\ nil, duration \\ Help.long) do
    # async update of data
    Task.async fn -> 
      boot(data, secret, duration)
    end
    
    # return immedately w/ original data
    data
  end
  
  @doc "Start a `data` flow inside the Universal Flow."
  def boot(data = %Data{}, secret \\ nil, duration \\ Help.long) do
    GenServer.call FlowServer, {Kind.boot, data, secret, duration}
  end
  
  # @doc "Return `data` if flow is a `match`."
  # def match(match = %Data{}, thing, secret \\ nil, duration \\ nil) when not is_nil(thing) do
  #   GenServer.call FlowServer, {:match, match, thing, secret}
  # end
  
  # @doc "Forward Data through all Flow/Graphs."
  # def graph(data = %Data{}, secret \\ nil, duration \\ nil) do
  #   GenServer.call FlowServer, {:graph, data, secret}
  # end
  
  ## IN
  
  @doc "Put `thing` *INTO* `data.thing`."
  def i(thing, data = %Data{}) do
    into(thing, data)
  end
  def into(thing, data = %Data{}) do
    data
    |> Data.update(thing)
  end
    
  @doc "Map `holospace` *INTO* `data.pull`."
  def pull(data = %Data{}, holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    put_in(data.pull, Map.put(data.pull, holospace, Kind.boot))
  end
  
  @doc "Put `thing` *INTO* `data.pull` at `signal`."
  def take(thing, data = %Data{}, signal \\ nil, secret \\ nil) when is_atom(signal) or is_binary(signal) do
    put_in(data.pull, Map.put(data.pull, signal, thing))
  end
  
  @doc "Walk `holospace` and put into `data.pull`."
  def walk(data, holospace \\ "/", secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    list = Flow.space(holospace, secret)
    
    unless Enum.empty? list do
      data = List.first Stream.map list, fn path ->
        data = Flow.pull(data, path, secret)
      end
    end
    
    # flow it babe
    Holo.boost data, holospace, secret
  end
  
  ## OUT
    
  @doc "From `data` *to* `holospace` in the *BACKGROUND*."
  def push(data = %Data{}, holospace, secret \\ nil) do
    put_in(data.push, Map.put(data.push, holospace, Kind.push))
  end
  
  @doc "From `data` *to* `holospace` and *WAIT*."
  def wait(data = %Data{}, holospace, secret \\ nil) do
    # todo: call/receive for a data/signal from `holospace`
    put_in(data.push, Map.put(data.push, holospace, Kind.wait))
  end

  
  ## GenServer
  
  def handle_call({:motion, _secret}, source, agent) do
    #todo: support secret/access/codes
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({boot, data = %Data{}, secret, duration}, source, agent) do
    link = {:ok, machine} = Machine.start_link(data, secret, duration)
    
    # put the machine into the data
    data = Data.home data, machine
    
    # update the data to include our Machine home
    :ok = Agent.update agent, fn map ->
      Map.put map, data.keycode, machine
    end
    
    {:reply, data, agent}
  end
  
  # def handle_call({:match, match = %Data{}, thing}, source, agent) do
  #   # update map/space
  #   #:ok = Agent.update agent, fn map ->
  #
  #   # if Map.has_key? match do
  #   #   Map.update map, match, match, fn m -> match end
  #   # else
  #   #   Map.put map, match, thing
  #   # end
  #
  #   # return the data
  #   {:reply, data, agent}
  # end

#   def handle_call({:graph, match = %Data{}, data = %Data{}}, source, agent) do
#
#     # return the data
#     {:reply, data, agent}
#   end
  
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
