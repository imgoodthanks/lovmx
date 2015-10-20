require Logger

defmodule Bridge do

  @moduledoc """
  # Bridge
  ## Like a Rainbow Bridge to the NoFlo Multiverse.
  
  Bridge(s) poly to the Web and Multiverse worlds, 
  other NoFlo networks, running frameworks (Node/Rails), 
  the Unix/Mac/Windows systems below, and other pipelines 
  too.
  """
  
  # Cool Modules
  use Magic
  use OrbitalMagic

  @parsers [Plug.Parsers.MULTIPART, Plug.Parsers.URLENCODED]
  @upload 200_000_000
  
  # todo: add custom Web/Warp support.
  # todo: dynamically build @static from `lib/drive` BOM.
  @static [
    "bin",
    "css",
    "help",
    "data",
    "html",
    "img",
    "js",
  ]

  plug Plug.Logger
  if Mix.env == :dev do
    use Plug.Debugger
  end
  
  # The result returned by init/1 is passed as second argument to call/2. Note that
  # init/1 may be called during compilation and as such it must not return pids,
  # ports or values that are not specific to the runtime.

  @doc "We live in an HTTPS Multiverse."
  def port, do: System.get_env("LOVMX_PORT") || 8443

  @doc "We need to Plug.init."
  def init(data) do
    {:ok, agent} = Agent.start_link fn -> Map.new end

    # broadcast ourself
    #Holo.orbit agent, "tube/agent"

    agent
  end
  
  @doc "Route *all* generic PULL signals from HTTPS."  
  def call(conn = %Plug.Conn{method: "GET", path_info: nubspace}, agent) do
    if nubspace in [[], [""], nil] do
      nubspace = "/"
    end

    nubspace = Lovmx.path(nubspace)
    path = Lovmx.root Lovmx.web [nubspace]

    #Logger.debug "Bridge.nubspace: #{nubspace}"

    if File.exists?(path) and not File.dir?(path) do
      # use plug/send_file here for OS-level support
      send_file conn, 200, path
    else
      Logger.debug "Bridge.GET // #{nubspace}"
      
      resp conn, 200, Pipe.page Holo.list(nubspace)
    end
  end
  
  @doc "Route *all* generic PUSH signals from HTTPS."  
  def call(conn = %Plug.Conn{method: "POST", path_info: nubspace}, agent) do
    if nubspace in [[], [""], nil] do
      nubspace = "/"
    end

    nubspace = Lovmx.path(nubspace)
    path = Lovmx.root Lovmx.web [nubspace]

    Logger.debug "Bridge.POST // #{nubspace}"

    resp conn, 200, Pipe.page Holo.list(nubspace)
  end
  
  @doc "Even the Universe misses things."
  match _ do
    #todo: forward to the wizard for defensive purposes.
    send_resp(conn, 404, "oops")
  end
    
  ## Callbacks
  
  ## todo: <develop the NoFlo bridge here>
  
  # def handle_call({:getruntime, secret}, source, agent) do
  #   {:reply, secret, agent}
  # end
  
  def start_link(_) do
    link = {:ok, bridge} = GenServer.start_link(Bridge, Map.new, name: BridgeServer)
    Logger.info "Bridge.start_link #{inspect bridge}"

    link
  end
  
end

