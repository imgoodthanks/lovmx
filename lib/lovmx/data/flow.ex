require Logger

defmodule Flow do
  
  @moduledoc """
  # Flow
  ## Actions/Events
  ### Manage and Trigger Input(s)/Output(s) for Data.
  
  A data flow is the basic layout of an `application` or are the 
  Modules you need to define and respond to the various other 
  Data/Flow signal types, stacking and plugging your modules into 
  all the available framework signals. 
  
  For example a Bot produces something that Flows into a Pipe and
  out to the Tube module for the world (Universe/Multiverse) to
  see and use.
  """
    
  ## IN
  
  @doc "Put `native` *INTO* `data.pull`."
  def i(native, data = %Data{}, signal) do
    into(native, data, signal)
  end
  def into(native, data = %Data{}, signal) do    
    put_in(data.pull, Map.put(data.pull, signal, native))
    |> Holo.x
  end
    
  @doc "Put everything at `holospace` *INTO* `data.pull`."
  def pull(data = %Data{}, holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do    
    #todo: route the flow based on Kind.flow to spawn a Computer process
    
    # embed that to the current player process.
    put_in(data.pull, Map.put(data.pull, holospace, Kind.init))
    |> Holo.x(holospace, secret)
  end
  
  @doc "Put `native` *INTO* `data.pull`."
  def take(data = %Data{}, native, signal \\ nil, secret \\ nil) when is_atom(signal) or is_binary(signal) do
    #Logger.debug "Flow.take // #{data.keycode} // #{signal} // #{inspect native}"
    
    #todo: update all data/bots that live at this holospace with our new `data`
    #todo: route the flow based on Kind.flow to spawn a Computer process
    # embed that to the current player process.
     
    put_in(data.pull, Map.put(data.pull, signal, native))
    |> Holo.x
  end
  
  @doc "Walk `holospace` and put into `data.pull`."
  def walk(data, holospace \\ "/", lock \\ nil) when is_atom(holospace) or is_binary(holospace) do
    #Logger.debug "Flow.push // #{holospace} // #{inspect data}"
    
    data = put_in data.home, lock
    data = put_in data.kind, Data.new
    data = put_in data.life, Lovmx.long
    
    pulls = Holo.list(holospace, lock)
  
    unless Enum.empty? pulls do
      data = List.first Enum.map pulls, fn path ->
        data = Flow.pull(data, path, lock)
      end
    end
    
    # flow it babe
    Holo.x data, holospace, lock
  end
    
  ## OUT
  
  @doc "From `data` *to* `machine` or `holospace` in the *BACKGROUND*."
  def push(data = %Data{}, holospace, secret \\ nil) do
    put_in data.push, Map.put(data.push, holospace, Kind.push)
    |> Holo.x(holospace, secret)
  end
  
  @doc "From `data` *to* `machine` or `holospace` and *WAIT*."
  def wait(data = %Data{}, holospace, secret \\ nil) do
    put_in(data.push, Map.put(data.push, holospace, Kind.wait))
    |> Holo.x(holospace, secret)
  end
  
end
