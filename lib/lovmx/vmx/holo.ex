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
  with software bugs.
  
  tl;dr Global Namespace + Push Data into the Machine.
  """  

  use GenServer
  
  ## Holospace (internet readable static/dynamic storage)

  @doc "Use `Holo.space` to return *everything* in Holospace share."
  def space do
    GenServer.call HoloServer, :space
  end
  
  @doc "Use `Holo.space <signal>` to return a [list] of specific *computed* data at `holospace`."
  def space(holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    list(holospace, secret)
    |> Stream.map(fn data -> 
      data.native
    end) 
    |> Enum.to_list
  end
  
  @doc "Use `Holo.list <holospace>` to return a [list] of things at `holospace`."
  def list(holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    Tube.read(Lovmx.web(holospace), secret)
    |> List.wrap
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
    Task.async fn -> 
      Holo.share(data)
    end
    
    data
  end
  def share(data = %Data{}, holospace \\ nil, secret \\ nil, duration \\ Lovmx.long) do
    GenServer.call HoloServer, {:share, data, holospace, secret, duration}
  end

  @doc "WARNING: Destroy `holospace`. *thundering sounds*"
  def forget(holospace \\ nil, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
   # todo: return true if the thing has not spread to holospace
   # otherwise radio "unable to erase" + remove the object
   GenServer.cast HoloServer, {:reset, holospace, secret}

   holospace
  end
  
  ## Callbacks
  
  def handle_cast(:reset, agent) do
        
    #todo: Process.exit :kill all machines in holospace.
    
    # recreate holospace if that's what the wiz says we should do...
    :ok = Agent.update agent, fn x -> Map.new end
    Logger.info "Holo!reset // #dynamic // #{inspect Moment.now}"
    
    {:noreply, agent}
  end
      
  def handle_call(:space, source, agent) do
    #todo: poll machines for compliance.
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:capture, data = %Data{}, holospace, secret, duration}, source, agent) do
    #Logger.debug "Holo:capture #{inspect self} // #{inspect holospace} // #{inspect data}"
    
    # extract our map that we reset shortly
    map = Agent.get(agent, &(&1))
    
    # we need a namespace to share over..
    if is_nil holospace do
      holospace = data.keycode
    end
    
    if Map.has_key?(map, holospace) do
      # return the data
      {:reply, Data.bugs(data, "Machine.handle_call:capture // holospace is already taken: #{inspect holospace}"), agent}
    else
      {:reply, handle_call({:share, data, holospace, secret, duration}, source, agent), agent}
    end
  end
  
  #def handle_call({:boost, data = %Data{}, holospace, secret, duration}, source, agent) do
  
  def handle_cast({:feel, source, data, holospace, secret, duration}, agent) do
    #Logger.debug "Holo.feel #{inspect self} // #{inspect source} // #{inspect data}"
    
    # get the map
    map = Agent.get(agent, &(&1))
    
    # compile data but keep it in a second level Machine process
    # todo: check if this data already has a machine installed..
    data = data
    |> Machine.compute(holospace, secret, duration)
    #|> Tube.share(holospace, secret)
    #|> Tube.save
    
    # check for updated versions
    #existing = Map.get(map, holospace)
    
    # store the <holospace/keycode> -> <machine/pid> map here in Holo
    :ok = Agent.update(agent, fn x -> Map.put x, data.keycode, data end)
    
    # send a :push back to the data
    if Process.alive?(source) do
      send source, {:push, self, data}
    end
    
    {:noreply, agent}
  end
  
  def handle_call({:share, data = %Data{}, holospace, secret, duration}, source, agent) do
    # we need a namespace to share over..
    if is_nil holospace do
      holospace = data.keycode
    end
    
    # # start a machine
    unless is_nil data.home do
      machine = Machine.boot(data)
      # |> Machine.compute(holospace, secret)
      
      #todo: use safetybox and encrypt data w/ secret
      data = put_in data.home, machine
      #|> Tube.save(holospace, secret)
    end

    #Logger.debug "Holo.share #{inspect self} // #{inspect holospace} // #{inspect data}"

    # update map/space
    :ok = Agent.update agent, fn map ->
      Map.put(map, holospace, machine)
    end

    # return the data
    {:reply, data, agent}
  end
  
  def handle_cast({:reset, holospace, secret}, agent) do
    # remove the data
    # Map.drop(map, holospace)

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
