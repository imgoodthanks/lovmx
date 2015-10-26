require Logger

defmodule Flow do
  
  @moduledoc """
  # Flow
  ## Actions/Events
  ### Computable Input/Output for Data.
  
  A data flow is the basic layout of an `application` or are the 
  Modules you need to define and respond to the various other 
  Data/Flow signal types, stacking and plugging your modules into 
  all the available framework signals. 
  
  For example a Bot produces something that Flows into a Pipe and
  out to the Cloud module for the world (Universe/Multiverse) to
  see and use.
  """
    
  ## IN
  
  @doc "Put `thing` *INTO* `data.thing`."
  def i(thing, data = %Data{}) do
    into(thing, data)
  end
  def into(thing, data = %Data{}) do
    data
    |> Data.renew(thing)
    |> Cloud.x
  end
    
  @doc "Map `holospace` *INTO* `data.pull`."
  def pull(data = %Data{}, holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    # embed that to the current player process.
    put_in(data.pull, Map.put(data.pull, holospace, Kind.boot))
    |> Cloud.x(holospace, secret)
  end
  
  @doc "Put `thing` *INTO* `data.pull` at `signal`."
  def take(thing, data = %Data{}, signal \\ nil, secret \\ nil) when is_atom(signal) or is_binary(signal) do
    #Logger.debug "Flow.take // #{data.keycode} // #{signal} // #{inspect thing}"

    put_in(data.pull, Map.put(data.pull, signal, thing))
    |> Cloud.x
  end
  
  @doc "Walk `holospace` and put into `data.pull`."
  def walk(data, holospace \\ "/", secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    #Logger.debug "Flow.push // #{holospace} // #{inspect data}"

    list = Cloud.space(holospace, secret)
  
    unless Enum.empty? list do
      data = List.first Enum.map list, fn path ->
        data = Flow.pull(data, path, secret)
      end
    end
    
    # flow it babe
    Cloud.x data, holospace, secret
  end
    
  ## OUT
  
  @doc "From `data` *to* `machine` or `holospace` in the *BACKGROUND*."
  def push(data = %Data{}, holospace, secret \\ nil) do
    put_in(data.push, Map.put(data.push, holospace, Kind.push))
    |> Cloud.x(holospace, secret)
  end
  
  # @doc "From `data` *to* `machine` or `holospace` and *WAIT*."
  # def wait(data = %Data{}, holospace, secret \\ nil) do
  #   # todo: call/receive for a data/signal from `holospace`
  #   put_in(data.push, Map.put(data.push, holospace, Kind.wait))
  #   |> Cloud.x(holospace, secret)
  # end
  
end
