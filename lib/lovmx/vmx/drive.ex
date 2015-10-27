require Logger

defmodule Drive do
  
  @moduledoc """
   # Drive
  ## Disk or OS-level File/Blob Storage.

  Store and read items from the hard drives.

  # todo: security review
  # todo: add hotcake caching + file monitoring
  """
 
  ## File System
  
  @doc "Read private/project-based files from `$project/<path>`."
  def read(path, _secret \\ nil) do
    # build the path
    root = Help.project path

    Logger.debug "Boot.read: #{root}"

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
    Logger.debug "Drive.save: #{Help.path([holospace, Kind.boot])}"
  
    data
  end

  @doc "Write raw `thing` data to `$project/<path>`."
  def write(thing, path \\ nil, secret \\ nil) when is_nil(path) or is_atom(path) or is_binary(path) do
    absolute = Help.root Help.web path

    # create the enclosing path
    File.mkdir_p Path.dirname absolute

    # write the data out
    File.write! absolute, Help.freeze(thing), [:write]
    Logger.debug "Drive.write: #{Help.path([absolute, Kind.boot])}"

    thing
  end
  
end

