require Logger

defmodule Bridge do

  @moduledoc """
  # Bridge
  ## Like a Rainbow Bridge to the NoFlo Multiverse.
  
  Bridge(s) poly to the Web and outside world, other
  NoFlo networks, running frameworks (Node/Rails), 
  the Unix/Mac/Windows systems below, and eventually 
  other pipelines too.
  """
  
  # Cool Modules
  use Magic
  use OrbitalMagic

  if Mix.env == :dev do
    use Plug.Debugger
  end

  @parsers [Plug.Parsers.MULTIPART, Plug.Parsers.URLENCODED]
  @upload 200_000_000
  
  # todo: dynamically build @static from `lib/static` BOM.
  # warn: update warp.web too
  @static [
    "bin",
    "css",
    "help",
    "data",
    "html",
    "img",
    "js",
  ]

  plug Plug.Static, at: "/static", from: :lovmx
  
  # The result returned by init/1 is passed as second argument to call/2. Note that
  # init/1 may be called during compilation and as such it must not return pids,
  # ports or values that are not specific to the runtime.

  def port, do: System.get_env("LOVMX_PORT") || 8443

  def init(data) do
    {:ok, agent} = Agent.start_link fn -> Map.new end

    # broadcast ourself
    #Holo.orbit self,  "tube"
    #Holo.orbit agent, "tube/agent"

    agent
  end
  
  def handle_call({:getruntime, secret}, source, agent) do
    {:reply, secret, agent}
  end
    
  match "/reset", via: :get do
    nubspace = "/"
    
    #Logger.debug "Bridge:RESET: #{inspect nubspace} // #{inspect conn.params}"
    
    send_resp(conn, 200, Pipe.page Holo.reset(true, true))
  end
  
  match "/", via: :post do
    # first parse the conn for params/binaries/etc
    conn = Plug.Parsers.call conn, parsers: @parsers, limit: @upload_limit
    
    # cleanup the path/nubspace
    nubspace = Lovmx.path conn.path_info
    if nubspace == [] do
      nubspace = ["/"]
    end
    
    # grab our payload(s)
    opts = conn.params
    
    # create the item
    if Map.has_key?(opts, :filename) do
      Freezer.put(opts.path, nil, opts.content_type, opts.filename)
      |> Holo.orbit(nubspace)
    end
    
    if Map.has_key?(opts, "code") do
      #Logger.debug "Bridge.POST: #{nubspace} // #{inspect conn.params}"
      
      opts["code"]
      |> Cake.magic
      |> Holo.orbit(nubspace)
    end
    
    ## footer
    send_resp conn, 200, Pipe.page Cake.magic(nubspace)
  end
  
  match "*nubspace", via: :get do
    if nubspace in [[],[""],nil] do
      nubspace = "/"
    end
    
    nubspace = Lovmx.path(nubspace)
    path = Lovmx.root Lovmx.web [nubspace]
    
    #Logger.debug "Bridge.nubspace: #{nubspace}"

    if File.exists?(path) and not File.dir?(path) do
      # use plug/send_file here for OS-level support
      send_file conn, 200, path
    else
      send_resp conn, 200, Pipe.page Holo.list(nubspace)
    end
  end
  
  ## Callbacks
  
  def start_link(lovmx) do
    link = {:ok, beam} = GenServer.start_link(Bridge, Map.new, name: BridgeServer)
    #Logger.debug "Bridge.start_link #{inspect beam} // #{inspect lovmx}"

    link
  end
  
end

