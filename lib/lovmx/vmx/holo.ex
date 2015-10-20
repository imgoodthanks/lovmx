require Logger

defmodule Holo do
  
  @moduledoc """
  # Holo
  ## Holo
  ### Holo
  
  Holo is one of three core GenServers inside the Framework 
  and works like a *light* + *fluffy* messaging bridge to the
  Machine.
  
  Holo renders Orbital Nubspace (aka spacetime) by gluing
  together various parts of the framework into a cohesive
  whole (aka time/motion is superimposed with data) that may 
  be graphed, computed, and displayed.

  Holo signals into the Machine and other parts of the 
  framework often in order to best get/create/update 
  whatever your little heart asks for. Like magic, but 
  with software bugs.
  
  tl;dr Global Namespace + Push data into the Machine.
  """  

  use GenServer
  
  ## Nubspace (internet readable)
  
  @doc "Use `Holo.x` to `Holo.x` data in the BACKGROUND."  
  def x(data = %Data{}, _nubspace \\ nil, _secret \\ nil) do
    # refresh *all* things + re-ping machine(s)
    Task.async fn -> 
      Holo.orbit(data) 
    end
    
    data
  end
  
  @doc "Use `Holo.bang` to start breakfast."
  def bang(path \\ "README.magic", reboot \\ false) do
    Logger.info "Holo.bang."

    # devhack: nuke the galaxy on each boot
    Holo.reset(nubspace: true, universe: true)

    # reload a previously saved galaxy
    if reboot and File.exists?(Lovmx.project ["priv", "holo.freeze"]) do
      # fetch previous galaxy
      archive = Lovmx.thaw Tube.read Lovmx.path ["priv", "holo.freeze"]

      if archive do
        Holo.orbit "Holo.bang(true) but the `galaxy.freeze` file was nada."
      else
        Holo.orbit "Holo.bang(true) but the `galaxy.freeze` file was nada."
      end
    end
    
    # restart the network
    Cake.mix Lovmx.project path

    self
  end
  
  @doc "WARNING: Destroy various parts of Nubspace. *thundering sounds*"
  def reset(opts \\ []) do
    #todo: add (an entire..) auth process (using player + stampcodes)
    destroy_nubspace = Keyword.get opts, :nubspace, false
    destroy_universe = Keyword.get opts, :universe, false
    
    GenServer.cast :holo, {:reset, destroy_nubspace, destroy_universe}
    
    self
  end
  
  @doc "Use `Holo.space` to return *everything* in Nubspace orbit."
  def space do
    GenServer.call :holo, :space
  end
  
  @doc "Use `Holo.orbit` to start a `Machine` at `nubspace` with `data`."
  def orbit(data = %Data{}, nubspace \\ nil, secret \\ nil, duration \\ Lovmx.long) do
    Task.async fn ->
      GenServer.call :holo, {:orbit, data, nubspace, secret, duration}
    end
    
    data
  end
  def handle_call({:orbit, data = %Data{}, nubspace, secret, duration}, source, agent) do
    # we need a namespace to orbit over..
    if is_nil nubspace do
      nubspace = data.keycode
    end
    
    # # start a machine
    unless is_nil data.home do
      machine = Machine.boot(data)
      # |> Machine.compute(nubspace, secret)
      #todo: use safetybox and encrypt data w/ secret
      data = Holo.move(data, machine)
      # |> Tube.save(nubspace, secret)
    end

    #Logger.debug "Holo:orbit #{inspect self} // #{inspect nubspace} // #{inspect data}"

    # update map/space
    :ok = Agent.update agent, fn map ->
      Map.put(map, nubspace, machine)
    end

    # return the data
    {:reply, data, agent}
  end
  
  @doc "Use `Holo.grab` to return a list of *ALL* nubspace data at `signal`."
  def grab(nubspace, signal) when is_atom(nubspace) or is_binary(nubspace) do
    grab(nubspace, nil, signal)
  end
  def grab(nubspace, secret \\ nil, signal) when is_atom(nubspace) or is_binary(nubspace) do
    list(nubspace, secret) |> Stream.map(fn data -> data.native end) |> Enum.to_list
  end

  @doc "Use `Holo.list <nubspace>` to return a [list] of things."
  def list(nubspace, secret \\ nil) when is_atom(nubspace) or is_binary(nubspace) do
    Tube.read(Lovmx.web(nubspace), secret)
    |> List.wrap
  end
  
  @doc "Move `data` to home at `process` or `nubspace`."    
  def move(data = %Data{}, process) when is_pid(process) do
    # # say goodbye
    # if not is_nil data.home and is_pid data.home and Process.alive? data.home do
    #   Process.exit(data.home, :normal)
    # end
    
    # update the data
    Data.tick(put_in data.home, process)
    |> Holo.x
  end
  def move(data = %Data{}, nubspace, secret \\ nil) when is_atom(nubspace) or is_binary(nubspace) do
    # say goodbye
    Holo.nuke(data.home, secret)

    # create the clone
    Data.tick(put_in data.home, nubspace)
    |> Holo.x
  end
  
  @doc "WARNING: Destroy `nubspace`. *thundering sounds*"
  def nuke(nubspace \\ nil, secret \\ nil) when is_atom(nubspace) or is_binary(nubspace) do
   # todo: return true if the thing has not spread to nubspace
   # otherwise radio "unable to erase" + remove the object
   GenServer.cast :holo, {:nuke, nubspace, secret}

   nubspace
  end
  
  @doc "Save Holo.space to Holo."
  def freeze do
    #todo: Holo.orbit "#freeze the galaxy"

    # save the galaxy
    Task.async fn ->
      Holo.space
      |> Lovmx.freeze
      |> Tube.save(Lovmx.path ["priv", "holo.freeze"])
    end

    self
  end
  
  ## Callbacks
  
  def handle_cast({:reset, destroy_nubspace, destroy_universe}, agent) do
    Logger.info "Holo:reset"
    #todo: Process.exit :kill all bots/pids in nubspace
    
    # extract our map that we reset shortly
    map = Agent.get(agent, &(&1))
    
    # check + destroy things if that's what the wiz should do...
    if destroy_nubspace do
      Logger.info "!reset // #dynamic // #{:io_lib.format("~p", [:erlang.time])}"
      
      :ok = Agent.update agent, fn x -> Map.new end
    end

    if destroy_universe do
      # copy the boot folder over
      File.rm_rf Lovmx.project ["priv", "static"]
      # freshly copy static stuff no matter what
      File.cp_r  Lovmx.project(["lib", "drive"]), Lovmx.project ["priv", "static"]

      Logger.info "!reset // #static // #{:io_lib.format("~p", [:erlang.time])}"
    end
    
    path = Lovmx.project Lovmx.web "help"
    
    # copy dev/docs over
    File.mkdir_p path
    File.cp_r Lovmx.project(["doc"]), path
    File.ln_s Lovmx.project(Lovmx.web "doc"), path

    Logger.info "!reset // #doc // #{:io_lib.format("~p", [:erlang.time])}"

    {:noreply, agent}
  end
    
  def handle_call(:space, source, agent) do
    #todo: poll machines for compliance.
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:capture, data = %Data{}, nubspace, secret, duration}, source, agent) do
    #Logger.debug "Holo:capture #{inspect self} // #{inspect nubspace} // #{inspect data}"
    
    # extract our map that we reset shortly
    map = Agent.get(agent, &(&1))
    
    # we need a namespace to orbit over..
    if is_nil nubspace do
      nubspace = data.keycode
    end
    
    if Map.has_key?(map, nubspace) do
      # return the data
      {:reply, Data.bugs(data, "Machine.handle_call:capture // nubspace is already taken: #{inspect nubspace}"), agent}
    else
      {:reply, handle_call({:orbit, data, nubspace, secret, duration}, source, agent), agent}
    end
  end
  
  #def handle_call({:boost, data = %Data{}, nubspace, secret, duration}, source, agent) do
  
  def handle_cast({:data, source, data, nubspace, secret, duration}, agent) do
    #Logger.debug "Holo:data #{inspect self} // #{inspect source} // #{inspect data}"
    
    # get the map
    map = Agent.get(agent, &(&1))
    
    # compile data but keep it in a second level Machine process
    # todo: check if this data already has a machine installed..
    data = data
    |> Machine.compute(nubspace, secret, duration)
    #|> Tube.share(nubspace, secret)
    #|> Tube.save
    
    # check for updated versions
    #existing = Map.get(map, nubspace)
    
    # store the <nubspace/keycode> -> <machine/pid> map here in Holo
    :ok = Agent.update(agent, fn x -> Map.put x, data.keycode, data end)
    
    # send a :push back to the data
    if Process.alive?(source) do
      send source, {:push, self, data}
    end
    
    {:noreply, agent}
  end
  
  def handle_cast({:nuke, nubspace, secret}, agent) do
    # remove the data
    # Map.drop(map, nubspace)

    {:noreply, agent}
  end

  def start_link(_) do
    # An agent that we'll eventually pass around to the *all* the Holo servers...
    link = {:ok, agent} = Agent.start_link(fn -> Map.new end)
    
    # Keep the map inmemory for fluffiness.
    link = {:ok, holo} = GenServer.start_link(Holo, agent, name: :holo, debug: [])
    Logger.info "Holo.start_link #{inspect holo}"

    link
  end
  
end
