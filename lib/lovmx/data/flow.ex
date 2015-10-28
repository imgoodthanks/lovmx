require Logger

defmodule Flow do
  
  @moduledoc """
  # Flow
  ## Data Input or Action/Event Graph
  
  A data flow is the basic layout of an `application` or are the 
  Modules you need to define and respond to the various other 
  Data/Flow signal types, stacking and plugging your modules into 
  all the available framework signals. 
  
  For example a Bot produces something that Flows into a Pipe and
  out to the Flow module for the world (Universe/Multiverse) to
  see and use.
  """
  
  use GenServer

  @doc "Use `Holo.graph` to return all <signals>."
  def graph(things) when is_list(things) do
    Logger.debug "Flow.graph #{inspect things}"
    
    Enum.map things, &(Holo.space &1)
  end
  def graph(nada) when is_nil(nada) do
    nil
  end
  
  ## META

  # @doc "Broadcast `thing` *OUT* to the universe in the *BACKGROUND*."
  # def x(data = %Data{}, secret \\ nil) do
  #   Task.async fn ->
  #     GenServer.call FlowServer, {Kind.push, data, secret}
  #   end
  #
  #   data
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
    # embed that to the current player process.
    put_in(data.pull, Map.put(data.pull, holospace, Kind.boot))
  end
  
  @doc "Put `thing` *INTO* `data.pull` at `signal`."
  def take(thing, data = %Data{}, signal \\ nil, secret \\ nil) when is_atom(signal) or is_binary(signal) do
    #Logger.debug "Flow.take // #{data.keycode} // #{signal} // #{inspect thing}"

    put_in(data.pull, Map.put(data.pull, signal, thing))
  end
  
  @doc "Walk `holospace` and put into `data.pull`."
  def walk(data, holospace \\ "/", secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    #Logger.debug "Flow.push // #{holospace} // #{inspect data}"

    list = Flow.space(holospace, secret)
  
    unless Enum.empty? list do
      data = List.first Enum.map list, fn path ->
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
