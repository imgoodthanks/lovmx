require Logger

defmodule Cloud do
  
  @moduledoc """
  # Cloud
  ## Cloudspace Management
  ### Cloud manages the entire dynamic + static hologram.
  
  Cloud renders the local Universe (aka your App) by
  routing Player data to Machine code and graphing,
  routing, and piping the side effects as needed.

  Cloud signals into the Machine and other parts of the 
  framework often in order to best get/create/update 
  whatever your little heart asks for. Like magic, but 
  with software boom.
  
  tl;dr Global Namespace + Push Data into the Machine.
  """  

  use GenServer
  import Kind
  
  ## Web
  
  @doc "Return things from Web.Cloudspace or the internet."
  def get(holospace \\ "/", secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    regex = ~r/^https\:/i

    # an external web call
    if Regex.match?(regex, Help.path(holospace)) do
      try do
        HTTPotion.get(holospace).body
      rescue x ->
        [Data.new(holospace, Kind.boom, x)]
      end
    else
      # an internal lovmx call
      holospace
      |> Help.web
      |> read
    end
  end
  
  ## Holospace (internal web-readable static/dynamic storage)
  
  @doc "Use `Cloud.space` to return *everything* in Cloudspace share."
  def space do
    GenServer.call CloudServer, {Kind.meta}
  end
  
  @doc "Use `Cloud.space <signal>` to look at and return *SPECIFIC* data at `holospace`."
  def space(holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    GenServer.call CloudServer, {Kind.pull, holospace, secret}
  end
  
  # @doc "Use `Cloud.data <signal>` to return *ALL* `<data>.thing` at `holospace`."
  # def data(machine, secret \\ nil, duration \\ Help.tock) when is_pid(machine) do
  #   compute machine, secret, duration
  # end
  
  @doc "Use `Cloud.list <holospace>` to return a [list] of things at `holospace`."
  def list(holospace \\ "/", secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    GenServer.call CloudServer, {Kind.list, holospace, secret}
  end
  
  @doc "Give `data` a new home at `process`."    
  def home(data = %Data{}, process) when is_pid(process) do
    # # say goodbye
    # if not is_nil data.home and is_pid data.home and Process.alive? data.home do
    #   Process.exit(data.home, :normal)
    # end
    
    # update the data
    Data.tick(put_in data.home, process)
    |> Cloud.x
  end
  
  @doc "Move `data` to `holospace`."  
  def move(data = %Data{}, holospace, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
    # say goodbye
    Cloud.forget(data.home, secret)
    
    put_in(data.home, holospace)
    |> Cloud.x
  end
  
  @doc "Use `Cloud.x` and `Cloud.share` to start a `Machine` at `holospace` with `data`."
  def x(data = %Data{}, _holospace \\ nil, _secret \\ nil) do
    # Task.async fn ->
    #   Cloud.share(data)
    # end
    
    data
  end
  def share(thing, holospace \\ nil, secret \\ nil, duration \\ Help.long) do
    Logger.debug "Cloud:share // #{inspect data}"    
    
    GenServer.call CloudServer, {Kind.push, data, holospace, secret, duration}
  end
  
  # @doc "Write raw `thing` data to the root of the Multiverse / Unix file system."
  # def orbit(thing, aboslute, secret)
  
  @doc "WARNING: Destroy `holospace`. *thundering sounds*"
  def forget(holospace \\ nil, secret \\ nil) when is_atom(holospace) or is_binary(holospace) do
   # todo: return true if the thing has not spread to holospace
   # otherwise radio "unable to erase" + remove the object
   GenServer.cast CloudServer, {Kind.drop, holospace, secret}
   
   holospace
  end
  
  ## File System
    
  @doc "Read private/project-based files from `$project/<path>`."
  def read(path, _secret \\ nil) do
    # build the path
    root = Help.project path

    Logger.debug "Cloud.read: #{root}"

    # either read the file, or list the dir
    if File.exists? root do
      case File.dir? root do
        false ->
          Help.thaw File.read!(root)

        true  ->
          {:ok, files} = File.ls root

          # fixup the basename to hide inside the warp drive
          basename = Path.basename(path)
          if Path.basename(path) == "static" do
            basename = "/"
          end

          List.wrap(files)
          |> Enum.map(fn x ->
            Data.new(x, Kind.link, %{path: root})
          end)
      end
    else
      nil
    end
  end
  
  @doc "Save `data` to `holospace` with Magic features."  
  def save(data = %Data{}, holospace \\ nil, secret \\ nil) when is_nil(holospace) or is_atom(holospace) or is_binary(holospace) do
    # TODO: support secrets
    
    # writing to data's home, or holospace?
    if is_nil holospace do
      holospace = Data.address data
    end
    path = Help.path [holospace, Kind.boot]
    
    write Help.freeze(data), path, secret
    #Logger.debug "Cloud.save: #{Help.path([holospace, Kind.boot])}"
    
    data
  end

  @doc "Write raw `thing` data to `$project/<path>`."
  def write(thing, path \\ nil, secret \\ nil) when is_nil(path) or is_atom(path) or is_binary(path) do
    absolute = Help.root Help.web path

    # create the enclosing path
    File.mkdir_p Path.dirname absolute

    # write the data out
    File.write! absolute, Help.freeze(thing), [:write]
    #Logger.debug "Cloud.write: #{Help.path([absolute, Kind.boot])}"

    thing
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
    
    Logger.warn "Cloud!list // #holospace // #{inspect match}"
    
    {:reply, match, agent}
  end
  
  def handle_call({:pull, holospace, secret}, source, agent) do
    map = Agent.get(agent, &(&1))
    thing = Map.get(map, holospace)
    
    #Logger.debug "Cloud!pull // #holospace // #{inspect thing}"
    
    case thing do
      thing when is_pid(thing) ->
        {:reply, Machine.compute(thing), agent}
      _ -> 
        {:reply, thing, agent}
    end
  end
  
  def handle_call({:push, data = %Data{}, holospace, secret, duration}, source, agent) do
    Logger.debug "Cloud:push // #{inspect data}"    
    
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
  def handle_call({:push, thing, holospace, secret, duration}, source, agent) do
    Logger.debug "Cloud:push // #{inspect data}"    
    
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
    Logger.info "Cloud!drop // #holospace // #{inspect Moment.now}"
    
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
    # An agent that we'll eventually pass around to the *all* the Cloud servers...
    link = {:ok, agent} = Agent.start_link(fn -> Map.new end)
    
    # Keep the map inmemory for fluffiness.
    link = {:ok, holo} = GenServer.start_link(Cloud, agent, name: CloudServer, debug: [])
    Logger.info "Cloud.start_link #{inspect link}"
    
    ## SSL Checkup.
    Bridge.kick secure: File.exists? Help.root "priv/ssl/cert.pem"
    
    link
  end
  
end
