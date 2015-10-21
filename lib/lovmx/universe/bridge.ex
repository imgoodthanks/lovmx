require Logger

defmodule Bridge do

  @moduledoc """
  # Bridge
  ## Like a Rainbow Bridge to the NoFlo Multiverse.
  
  Bridge(s) poly to the Web and Multiverse worlds, 
  other NoFlo networks, other frameworks (Node/Rails), 
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
    "blob",
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
  def port, do: System.get_env("LOVMX_SECURE_PORT") || 8443

  @doc "We need to Plug.init."
  def init(secure_by_default \\ nil) do
    {:ok, agent} = Agent.start_link fn -> Map.new end
    
    # broadcast ourself
    #Holo.share agent, "tube/agent"

    agent
  end
  
  @doc "We walk the Bridge."
  def kick(opts \\ []) do
    # todo: we developed in and *will ship* SSL/secure by default, 
    # just want to do an easier release and need to get the SSL
    # guide written up on lovmx.com first.
    secure_by_default = Keyword.get opts, :secure, nil
    
    # hack: start the Bridge/API server until a proper API is in place
    if secure_by_default do 
      Plug.Adapters.Cowboy.https(Bridge, secure_by_default, port: Bridge.port,
       otp_app: :lovmx,   
      password: "secretlols",         # CHANGE YOUR PASSWORD TO YOUR SSL CERT PASSWORD
       keyfile: "priv/ssl/key.pem",   # install the key and certificate
      certfile: "priv/ssl/cert.pem")
    else
      Plug.Adapters.Cowboy.http(Bridge, secure_by_default, port: Bridge.port) 
    end
  end

  @doc "Route *all* generic PULL signals from HTTPS."  
  def call(conn = %Plug.Conn{method: "GET", path_info: holospace}, agent) do
    if holospace in [[], [""], nil] do
      holospace = "/"
    end

    holospace = Lovmx.path(holospace)
    path = Lovmx.root Lovmx.web [holospace]

    #Logger.debug "Bridge.holospace: #{holospace}"

    if File.exists?(path) and not File.dir?(path) do
      # use plug/send_file here for OS-level support
      send_file conn, 200, path
    else
      Logger.debug "Bridge.GET // #{holospace}"
      
      resp conn, 200, Pipe.page Holo.space(holospace)
    end
  end
  
  @doc "Route *all* generic PUSH signals from HTTPS."  
  def call(conn = %Plug.Conn{method: "POST", path_info: holospace}, agent) do
    if holospace in [[], [""], nil] do
      holospace = "/"
    end

    holospace = Lovmx.path(holospace)
    path = Lovmx.root Lovmx.web [holospace]

    Logger.debug "Bridge.POST // #{holospace}"

    resp conn, 200, Pipe.page Holo.space(holospace)
  end
  
  @doc "Even the Universe misses things."
  match _ do
    # TODO: forward to the wizard for defensive purposes.
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

