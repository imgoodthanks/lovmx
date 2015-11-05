require Logger

defmodule Holo do
  
  @moduledoc """
  # Holo
  ## Universal Code + Data + Blob Storage.
  
  Holo renders the local Universe (aka your App) by
  routing Player data to Bot code and graphing,
  routing, and piping the side effects as needed.

  Holo signals into the Bot and other parts of the 
  framework often in order to best get/create/update 
  whatever your little heart asks for. Like magic, but 
  with software bugs.
  """
  
  use GenServer
  
  ## Holospace (internal web-readable static/dynamic storage)
  
  @doc "Use `Holo.map` to return all <signals>."
  def map(secret \\ nil) do
    GenServer.call HoloServer, {Kind.data, secret}
  end
    
  @doc "Use `Holo.space <thing>` to compute all <signals> at `holospace`."
  def space(thing, secret \\ nil)
  
  def space(things, secret) when is_list(things) do
    Enum.map things, fn thing -> 
      space(thing, secret)
    end
  end
  def space(holospace, secret) when is_atom(holospace) or is_binary(holospace) do
    GenServer.call HoloServer, {Kind.pull, holospace, secret}
  end
  
  @doc "Use `Holo.boost` to put `thing` into `holospace`."
  def boost(thing, holospace \\ nil, secret \\ nil, duration \\ Help.long) do
    GenServer.call HoloServer, {Kind.push, thing, holospace, secret, duration}
  end
  
  ## Callbacks
  
  # return the universal hologram of %{"holospace" => [things]}
  def handle_call({:data, _secret}, source, agent) do
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  # update the universal hologram: %{"holospace" => [things]}
  def handle_call({:push, data = %Data{}, holospace, secret, duration}, source, agent) do
    # we need a namespace to share over..
    if is_nil holospace do
      holospace = data.keycode
    end
    
    # update map/space
    :ok = Agent.update agent, fn map ->
      Map.update map, holospace, [data], fn space -> 
        space
        |> Enum.concat([data])
        |> List.flatten
        |> List.wrap
      end
    end
    
    # send a :pull notice to holospace
    Task.async fn ->
      Enum.each Holo.space(holospace, secret), fn thing ->
        case thing do
          _ -> 
          #Logger.warn "@@@ Holo:push // #thing // #{inspect thing}"
        
        end
      end
    end

    # return the data
    {:reply, data, agent}
  end
  
  # return specific [things] inside %{"holospace" => [things]}
  def handle_call({:pull, holospace, secret}, source, agent) do
    map  = Agent.get(agent, &(&1))
    data = Map.get(map, holospace)
    #Logger.warn "@@@ Holo:pull // #thing // #{inspect data}"
    
    {:reply, data, agent}
  end
    
  def start_link(_) do
    # An agent that we'll eventually pass around to the *all* the Holo servers...
    link = {:ok, agent} = Agent.start_link(fn -> Map.new end)
    
    # Keep the map inmemory for fluffiness.
    link = {:ok, holo} = GenServer.start_link(Holo, agent, name: HoloServer, debug: [])
    Logger.info "Holo.start_link #{inspect link}"

    link
  end
  
end