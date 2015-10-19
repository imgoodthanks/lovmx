require Logger

defmodule Tube do
  
  @moduledoc """
  # Tube
  ## Input/Output to the Universe.
  ### Move Data between our Universe and the Multiverse. 
  
  Input and Output to the Universe. Push new data to 
  <code/nubspace/keycode/bridge/warp/etc> and other future
  systems and networks.
  """
  
  ## Secure Web
  
  @doc "Return things from Web.Nubspace or the internet."
  def get(nubspace \\ "/", secret \\ nil) when is_atom(nubspace) or is_binary(nubspace) do
    regex = ~r/^https\:/i

    # an external web call
    if Regex.match?(regex, Lovmx.path(nubspace)) do
      try do
        HTTPotion.get(nubspace).body
      rescue x ->
        [Data.new(nubspace, Data.error, x)]
      end
    else
      # an internal lovmx call
      nubspace
      |> Lovmx.web
      |> read
    end
  end
  
  ## File System
  
  @doc "Read private/project-based files from `$project/<path>`."
  def read(path, _secret \\ nil) do
    # build the path
    root = Lovmx.project path

    #Logger.debug "Tube.read: #{root}"

    # either read the file, or list the dir
    if File.exists? root do
      case File.dir? root do
        false ->
          Lovmx.thaw File.read!(root)

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
  
  @doc "Save `data` to `nubspace` with Magic features."  
  def save(data = %Data{}, nubspace \\ nil, secret \\ nil) when is_nil(nubspace) or is_atom(nubspace) or is_binary(nubspace) do
    #todo: support secrets
    
    # writing to data's home, or nubspace?
    if is_nil nubspace do
      nubspace = data.keycode
    end
    path = Lovmx.path [nubspace, Kind.init]
    
    write Lovmx.freeze(data), path, secret
    #Logger.debug "Tube.save: #{Lovmx.path([nubspace, Kind.init])}"
    
    data
  end

  @doc "Write raw `native` data to `$project/<path>`."
  def write(native, path \\ nil, secret \\ nil) when is_nil(path) or is_atom(path) or is_binary(path) do
    absolute = Lovmx.root Lovmx.web path

    # create the enclosing path
    File.mkdir_p Path.dirname absolute

    # write the data out
    File.write! absolute, Lovmx.freeze(native), [:write]
    #Logger.debug "Tube.write: #{Lovmx.path([absolute, Kind.init])}"

    native
  end
  
  # @doc "Write raw `native` data to the root of the Multiverse / Unix file system."
  # def multi(native, aboslute, secret)
  
end
