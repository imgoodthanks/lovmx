require Logger

defmodule Boot do
  
  @moduledoc """
  # Boot
  ## Memory Management
  ###  Global Namespace of Code + Data.
  
  Boot renders the local Universe (aka your App) by
  routing Player data to Machine code and graphing,
  routing, and piping the side effects as needed.

  Boot signals into the Machine and other parts of the 
  framework often in order to best get/create/update 
  whatever your little heart asks for. Like magic, but 
  with software bugs.
  
  tl;dr Global Namespace + Push Data into the Machine.
  """  

  use GenServer
  import Kind
    
  ## Bootspace (internal web-readable static/dynamic storage)
  
  @doc "Use `Boot.space` to return *everything* in Bootspace share."
  def space do
    GenServer.call BootServer, {Kind.meta}
  end
  
  @doc "Use `Boot.space <signal>` to look at and return *SPECIFIC* data at `holospace`."
  def space(holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    GenServer.call BootServer, {Kind.pull, holospace, secret}
  end
  
  # @doc "Use `Boot.data <signal>` to return *ALL* `<data>.thing` at `holospace`."
  # def data(machine, secret \\ nil, duration \\ Help.tock) when is_pid(machine) do
  #   compute machine, secret, duration
  # end
  
  @doc "Use `Boot.list <holospace>` to return a [list] of things at `holospace`."
  def list(holospace \\ "/", secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    GenServer.call BootServer, {Kind.list, holospace, secret}
  end
  
  @doc "Give `data` a new home at `process`."    
  def home(data = %Data{}, process) when is_pid(process) do
    # # say goodbye
    # if not is_nil data.home and is_pid data.home and Process.alive? data.home do
    #   Process.exit(data.home, :normal)
    # end
    
    # update the data
    Data.tick(put_in data.home, process)
    |> Flow.x
  end
  
  @doc "Move `data` to `holospace`."  
  def move(data = %Data{}, holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    # say goodbye
    Boot.forget(data.home, secret)
    
    put_in(data.home, holospace)
    |> Flow.x
  end
  
  @doc "Use `Boot.share` to start a `Machine` at `holospace` with `data`."
  def share(thing, holospace \\ nil, secret \\ nil, duration \\ Help.long) do
    Logger.debug "Boot:share // #{inspect data}"    
    
    GenServer.call BootServer, {Kind.push, data, holospace, secret, duration}
  end
  
  # @doc "Write raw `thing` data to the root of the Multiverse / Unix file system."
  # def orbit(thing, aboslute, secret)
  
  @doc "WARNING: Destroy `holospace`. *thundering sounds*"
  def forget(holospace \\ nil, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
   # todo: return true if the thing has not spread to holospace
   # otherwise radio "unable to erase" + remove the object
   GenServer.cast BootServer, {Kind.drop, holospace, secret}
   
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
    
    Logger.warn "Boot!list // #holospace // #{inspect match}"
    
    {:reply, match, agent}
  end
  
  def handle_call({:pull, holospace, secret}, source, agent) do
    map = Agent.get(agent, &(&1))
    thing = Map.get(map, holospace)
    
    #Logger.debug "Boot!pull // #holospace // #{inspect thing}"
    
    case thing do
      thing when is_pid(thing) ->
        {:reply, Machine.data(thing), agent}
      _ -> 
        {:reply, thing, agent}
    end
  end
  
  def handle_call({:push, data = %Data{}, holospace, secret, duration}, source, agent) do
    Logger.debug "Boot:push // #{inspect data}"    
    
    # we need a namespace to share over..
    if is_nil holospace do
      holospace = data.keycode
    end
    
    # only start a machine if the data has no other home
    if is_nil data.home do
      machine = Machine.boot(data)
    end
    
    # compile data in a second level Machine process
    data = Machine.data(machine, secret, duration)
    
    # update map/space
    :ok = Agent.update agent, fn map ->
      Map.put map, holospace, machine
    end
    
    # TODO: send a :push to holospace
    
    # return the data
    {:reply, data, agent}
  end
  
  def handle_call({:push, thing, holospace, secret, duration}, source, agent) do
    Logger.debug "Boot:push // #{inspect data}"    
    
    # we need a namespace to share over..
    if is_nil holospace do
      holospace = Help.keycode
    end

    # update map/space
    :ok = Agent.update agent, fn map ->
      Map.put map, holospace, thing
    end
    
    # TODO: send a :push to holospace
    
    # return the data
    {:reply, thing, agent}
  end
  
  def handle_cast({:drop}, agent) do
    # TODO: Process.exit :kill all machines in holospace.
    
    # recreate holospace if that's what the wiz says we should do...
    :ok = Agent.update agent, fn x -> 
      Map.new
    end
    Logger.info "Boot!drop // #holospace // #{inspect Moment.now}"
    
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
    # An agent that we'll eventually pass around to the *all* the Boot servers...
    link = {:ok, agent} = Agent.start_link(fn -> Map.new end)
    
    # Keep the map inmemory for fluffiness.
    link = {:ok, holo} = GenServer.start_link(Boot, agent, name: BootServer, debug: [])
    Logger.info "Boot.start_link #{inspect link}"

    link
  end
  
end