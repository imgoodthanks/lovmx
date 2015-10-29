require Logger

defmodule Holo do
  
  @moduledoc """
  # Holo
  ## Holospace Data Management
  ### Global Namespace Code + Data stored in RAM.
  
  Holo renders the local Universe (aka your App) by
  routing Player data to Machine code and graphing,
  routing, and piping the side effects as needed.

  Holo signals into the Machine and other parts of the 
  framework often in order to best get/create/update 
  whatever your little heart asks for. Like magic, but 
  with software bugs.
  
  tl;dr Global Namespace + Push Data into the Machine.
  """
  
  use GenServer
    
  ## Holospace (internal web-readable static/dynamic storage)
  
  @doc "Use `Holo.map` to return all <signals>."
  def map do
    GenServer.call HoloServer, {Kind.meta, nil}
  end
  
  @doc "Use `Holo.space <signal>, <secret>` to look at and return *SPECIFIC* signals at `holospace`."
  def space(data, secret \\ nil)

  def space(holospace, secret) when is_atom(holospace) or is_binary(holospace) do
    GenServer.call HoloServer, {Kind.flow, holospace, secret}
  end
  def space(things, secret) when is_list(things) do
    things
  end
  def space(data = %Data{kind: :blob, thing: filename}, secret) when is_binary(filename) do
    Cake.magic data, secret
  end
  def space(data = %Data{}, secret) do
    data
  end
    
  @doc "Use `Holo.capture` to *EXCLUSIVELY* capture `holospace`."
  def capture(data = %Data{}, holospace, secret \\ nil, duration \\ Help.long) do
    # Compile + pull *all* `data.pull` and push to the Machine for exe
    GenServer.call HoloServer, {Kind.lock, data, holospace, secret, duration}
  end
  
  @doc "Use `Holo.list <holospace>` to return a [list] of things at `holospace`."
  def list(holospace \\ "/", secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    GenServer.call HoloServer, {Kind.list, holospace, secret}
  end
    
  @doc "Move `data` to `holospace`."  
  def move(data = %Data{}, holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    # say goodbye
    Holo.forget(data.home, secret)
    
    put_in(data.home, holospace)
  end
  
  @doc "Use `Holo.boost` to start a `Machine` at `holospace` with `data`."
  def boost(thing, holospace \\ nil, secret \\ nil, duration \\ Help.long) do
    
    
    GenServer.call HoloServer, {Kind.push, thing, holospace, secret, duration}
  end
  
  # @doc "Write raw `thing` data to the root of the Multiverse / Unix file system."
  # def orbit(thing, aboslute, secret)
  
  @doc "WARNING: Destroy `holospace`. *thundering sounds*"
  def forget(holospace \\ nil, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
   # todo: return true if the thing has not spread to holospace
   # otherwise radio "unable to erase" + remove the object
   GenServer.cast HoloServer, {Kind.drop, holospace, secret}
   
   holospace
  end
    
  ## Callbacks
  
  def handle_call({:meta, _secret}, source, agent) do
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:list, holospace, secret}, source, agent) do
    match = Agent.get(agent, &(&1))
    |> Map.keys
    |> Stream.filter(fn key -> key == holospace end)
    |> Enum.to_list
    |> List.wrap
        
    {:reply, match, agent}
  end
  
  def handle_call({:lock, data = %Data{}, holospace, secret, duration}, source, agent) do
    

    # extract our map that we reset shortly
    map = Agent.get(agent, &(&1))

    # we need a namespace to share over..
    if is_nil holospace do
      holospace = data.keycode
    end

    if Map.has_key?(map, holospace) do
      # return the data
      {:reply, Data.boom(data, "Holo:lock // holospace is already taken: #{inspect holospace}"), agent}
    else
      # set that data to live at holospace and be static
      data = data
      |> Data.home(holospace)
      |> Data.kind(Kind.data)
      
      # exclusively put data into space
      :ok = Agent.update agent, fn map ->
        Map.put map, holospace, data
      end
      
      {:reply, data, agent}
    end
  end
  
  def handle_call({:pull, holospace, secret}, source, agent) do
    map  = Agent.get(agent, &(&1))
    data = Map.get(map, holospace)
    
    
    
    {:reply, data, agent}
  end
  
  def handle_call({:flow, holospace, secret}, source, agent) do
    map  = Agent.get(agent, &(&1))
    data = Map.get(map, holospace)
    
    
    case data do
      data when is_list(data) ->
        Enum.each data, fn x ->
          
        end
        
        {:reply, data, agent}  
      data ->
        {:reply, data, agent}
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
      # compile data in a second level Machine process
      data = Machine.data(machine, secret, duration)
    end
    
    # update map/space
    :ok = Agent.update agent, fn map ->
      Map.update map, holospace, [machine], fn x -> Enum.concat x, [machine] end
    end
    
    # send a :pull notice to holospace
    Task.async fn ->
      Enum.each list(holospace), fn thing ->
        case thing do
          # a process, so send a :data message
          thing when is_pid(thing) ->
            GenServer.call thing, {Kind.pull, data}
            
          _ -> nil
        end
      end
    end
    
    # return the data
    {:reply, data, agent}
  end
  
  def handle_call({:push, thing, holospace, secret, duration}, source, agent) do    
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