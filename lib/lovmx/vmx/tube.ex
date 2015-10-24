require Logger

defmodule Tube do
  
  @moduledoc """
  # Tube
  ## Input/Output to the Universe.
  ### Move Data between our Universe and the Multiverse. 
  
  Input and Output to the Universe. Push new data to 
  <code/holospace/keycode/bridge/warp/etc> and other future
  systems and networks.
  """
  
  use GenServer
  
  ## Secure Web
  
  @doc "Return things from Web.Holospace or the internet."
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
  
  ## File System
  
  @doc "Read private/project-based files from `$project/<path>`."
  def read(path, _secret \\ nil) do
    # build the path
    root = Help.project path

    Logger.debug "Tube.read: #{root}"

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
    #Logger.debug "Tube.save: #{Help.path([holospace, Kind.boot])}"
    
    data
  end

  @doc "Write raw `thing` data to `$project/<path>`."
  def write(thing, path \\ nil, secret \\ nil) when is_nil(path) or is_atom(path) or is_binary(path) do
    absolute = Help.root Help.web path

    # create the enclosing path
    File.mkdir_p Path.dirname absolute

    # write the data out
    File.write! absolute, Help.freeze(thing), [:write]
    #Logger.debug "Tube.write: #{Help.path([absolute, Kind.boot])}"

    thing
  end
  
  # @doc "Write raw `thing` data to the root of the Multiverse / Unix file system."
  # def orbit(thing, aboslute, secret)
  
  def start_link(_) do
    # An agent that we'll eventually pass around to the *all* the Holo servers...
    link = {:ok, agent} = Agent.start_link(fn -> Map.new end)
    
    # Keep the map inmemory for fluffiness.
    link = {:ok, tube} = GenServer.start_link(Tube, agent, name: :tube)
    Logger.info "Tube.start_link #{inspect link}"
    
    
    ## SSL Checkup.
    Bridge.kick secure: File.exists? Help.root "priv/ssl/cert.pem"
    
    link
  end
end
