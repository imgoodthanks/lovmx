require Logger

defmodule Holo do
  
  @moduledoc """
  # Holo
  ## Holospace Management
  ### Holo manages the entire dynamic + static hologram.
  
  Holo renders the local Universe (aka your App) by
  routing Player data to Machine code and graphing,
  routing, and piping the side effects as needed.

  Holo signals into the Machine and other parts of the 
  framework often in order to best get/create/update 
  whatever your little heart asks for. Like magic, but 
  with software boom.
  
  tl;dr Global Namespace + Push Data into the Machine.
  """  

  use GenServer
  import Kind
  
  ## Holospace (internet readable static/dynamic storage)
  
  @doc "Use `Holo.space` to return *everything* in Holospace share."
  def space do
    GenServer.call HoloServer, {Kind.meta}
  end
  
  @doc "Use `Holo.space <signal>` to look at and return *SPECIFIC* data at `holospace`."
  def space(holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    GenServer.call HoloServer, {Kind.pull, holospace, secret}
  end
  
  # @doc "Use `Holo.data <signal>` to return *ALL* `<data>.native` at `holospace`."
  # def data(machine, secret \\ nil, duration \\ Help.tock) when is_pid(machine) do
  #   compute machine, secret, duration
  # end
  
  @doc "Use `Holo.list <holospace>` to return a [list] of things at `holospace`."
  def list(holospace \\ "/", secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    GenServer.call HoloServer, {Kind.list, holospace, secret}
  end
  
  @doc "Give `data` a new home at `process`."    
  def home(data = %Data{}, process) when is_pid(process) do
    # # say goodbye
    # if not is_nil data.home and is_pid data.home and Process.alive? data.home do
    #   Process.exit(data.home, :normal)
    # end
    
    # update the data
    Data.tick(put_in data.home, process)
    |> Holo.x
  end
  
  @doc "Move `data` to `holospace`."  
  def move(data = %Data{}, holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    # say goodbye
    Holo.forget(data.home, secret)
    
    put_in(data.home, holospace)
    |> Holo.x
  end
  
  @doc "Use `Holo.x` and `Holo.share` to start a `Machine` at `holospace` with `data`."
  def x(data = %Data{}, _holospace \\ nil, _secret \\ nil) do
    # Task.async fn ->
    #   Holo.share(data)
    # end
    
    data
  end
  def share(data = %Data{}, holospace \\ nil, secret \\ nil, duration \\ Help.long) do
    GenServer.call HoloServer, {Kind.push, data, holospace, secret, duration}
  end
  
  @doc "WARNING: Destroy `holospace`. *thundering sounds*"
  def forget(holospace \\ nil, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
   # todo: return true if the thing has not spread to holospace
   # otherwise radio "unable to erase" + remove the object
   GenServer.cast HoloServer, {Kind.drop, holospace, secret}
   
   holospace
  end
  
  ## Callbacks
  
  def handle_call({:meta}, source, agent) do
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:list, holospace, secret}, source, agent) do
    match = Agent.get(agent, &(&1))
    |> Map.keys
    |> Stream.filter(fn key -> key == holospace end)
    |> Enum.to_list
    |> List.wrap
    
    Logger.warn "Holo!list // #holospace // #{inspect match}"
    
    {:reply, match, agent}
  end
  
  def handle_call({:pull, holospace, secret}, source, agent) do
    map = Agent.get(agent, &(&1))
    thing = Map.get(map, holospace)
    
    Logger.debug "Holo!pull // #holospace // #{inspect thing}"
    
    case thing do
      thing when is_pid(thing) ->
        {:reply, Machine.compute(thing), agent}
      _ -> 
        {:reply, thing, agent}
    end
  end

  def handle_call({:push, data = %Data{}, holospace, secret, duration}, source, agent) do
    # we need a namespace to share over..
    if is_nil holospace do
      holospace = data.keycode
    end
    
    # only start a machine if the data has no other home
    if is_nil data.home do
      machine = Machine.boot(data)
    end
    
    # compile data in a second level Machine process
    data = Machine.compute(machine, secret, duration)
    
    # update map/space
    :ok = Agent.update agent, fn map ->
      Map.put map, holospace, machine
    end
    
    # TODO: send a :push to holospace
    
    # return the data
    {:reply, data, agent}
  end
  
  def handle_cast({:drop}, agent) do
    # TODO: Process.exit :kill all machines in holospace.
    
    # recreate holospace if that's what the wiz says we should do...
    :ok = Agent.update agent, fn x -> 
      Map.new
    end
    Logger.info "Holo!drop // #holospace // #{inspect Moment.now}"
    
    {:noreply, agent}
  end
  
  def handle_cast({:drop, holospace, secret}, agent) do
    # get the map
    map = Agent.get(agent, &(&1))
    
    # remove holospace
    :ok = Agent.update(agent, fn map -> 
      if Map.has_key? map, holospace do
        Map.delete map, holospace
      end
      
      map
    end)
    
    {:noreply, agent}
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
