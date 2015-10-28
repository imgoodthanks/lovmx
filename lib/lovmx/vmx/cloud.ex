require Logger

defmodule Cloud do

  @moduledoc """
  # Cloud
  ## HTTP/HTTPS + NoFlo + Web.
  
  Cloud(s) poly between the Cloud and Multiverse worlds, 
  other NoFlo networks, other frameworks (Node/Rails), 
  the Platform/Unix/Mac/Windows systems below, and other 
  pipelines too.
  """
  
  # Cool Modules
  use OrbitalMagic

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

if Mix.env == :dev do
  use Plug.Debugger
end
  
  # The result returned by init/1 is passed as second argument to call/2. Note that
  # init/1 may be called during compilation and as such it must not return pids,
  # ports or values that are not specific to the runtime.

  @doc "We live in an HTTPS Multiverse."
  def port do
    if Application.get_env(:lovmx, :https, false) do
      8443
    else
      8080
    end
  end
  
  @doc "We need to Plug.init."
  def init(_nada \\ nil) do
    {:ok, agent} = Agent.start_link fn -> Map.new end
    
    agent
  end
  
  @doc "We walk the Cloud."
  def kick(opts \\ []) do
    # todo: we developed with and *will ship* SSL/secure by default, 
    # just want to do an easier release and need to get the SSL
    # guide written up on lovmx.com first.
    secure_by_default = Keyword.get opts, :https, Application.get_env(:lovmx, :https, false)
    
    # hack: start the Cloud/API server until a proper API is in place
    if secure_by_default do 
      Plug.Adapters.Cowboy.https(Cloud, secure_by_default, port: Cloud.port,
       otp_app: :lovmx,   
      password: "secretlols",         # CHANGE YOUR PASSWORD TO YOUR SSL CERT PASSWORD
       keyfile: "priv/ssl/key.pem",   # install the key and certificate
      certfile: "priv/ssl/cert.pem")
    else
      Plug.Adapters.Cowboy.http(Cloud, secure_by_default, port: Cloud.port) 
    end
    
    Logger.info "Cloud.kick // https: #{inspect secure_by_default} // port: #{inspect Cloud.port}"
  end
  
  @doc "Default route."
  def call(conn = %Plug.Conn{path_info: holospace}, agent) do
    Plug.Conn.send_resp 200, Pipe.page Drive.read Help.web holospace
  end
  
  
  @doc """
  Sends redirect response to provided url String
  <snip>
  Redirect pulled and modified from Phoenix:
  /phoenix/blob/eae9c5dfcb81875c5bcb5b2ee5bdbd5eb9898bd9/lib/phoenix/controller/connection.ex
  """
  def redirect(conn, url), do: redirect(conn, :found, url)
  def redirect(conn, status, url) do
    conn
    |> Plug.Conn.put_resp_header("Location", url)
    |> Plug.Conn.send_resp(301, url)
  end
  
  match _ do
    send_resp(conn, 404, "oops")
  end
  
end

