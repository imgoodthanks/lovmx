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
  use Magic, orbital: true
  
  @parsers [Plug.Parsers.MULTIPART, Plug.Parsers.URLENCODED]
  @upload 200_000_000
  
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
  def port, do: System.get_env("LOVMX_SECURE_PORT") || 8443

  @doc "We need to Plug.init."
  def init(secure_by_default \\ nil) do
    {:ok, agent} = Agent.start_link fn -> Map.new end
    
    agent
  end
  
  ## Web
  
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
      |> Drive.read
    end
  end
  
  @doc "We walk the Cloud."
  def kick(opts \\ []) do
    # todo: we developed in and *will ship* SSL/secure by default, 
    # just want to do an easier release and need to get the SSL
    # guide written up on lovmx.com first.
    secure_by_default = Keyword.get opts, :secure, nil
    
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
  end

  @doc "GET: Route *all* generic PULL signals from HTTPS."
  def call(conn = %Plug.Conn{method: "GET", path_info: holospace}, agent) do
    
    if Mix.env == :dev do
      Wizard.reset_all!
    end
    
    if holospace in [[], [""], nil] do
      holospace = "/"
    end

    holospace = Help.path(holospace)
    path = Help.root Help.web [holospace]

    if File.exists?(path) and not File.dir?(path) do
      # use plug/send_file here for OS-level support
      send_file conn, 200, path
    else      
      # we have a dynamic request
      case data = Boot.space(holospace) do
        data when is_list(data) ->
          resp conn, 200, Pipe.page data
        
        data = %Data{kind: :link, thing: thing} when is_atom(thing) or is_binary(thing) ->
          redirect conn, thing
          
        data = %Data{} ->
          resp conn, 200, Pipe.page data
          
          _ -> send_resp(conn, 200, Pipe.page(data))
      end
    end
  end

  @doc "POST: Route *all* generic PUSH signals from HTTPS."
  def call(conn = %Plug.Conn{method: "POST", path_info: holospace}, agent) do
    if holospace in [[], [""], nil] do
      holospace = "/"
    end

    holospace = Help.path(holospace)
    path = Help.root Help.web [holospace]

    # first parse the conn for params/binaries/etc
    conn = Plug.Parsers.call conn, parsers: @parsers, limit: @upload_limit

    # grab our payload(s)
    data = conn.params["data"]
    code = conn.params["code"]

    # create the item
    if data do
      #todo: add the code to the data
      Freezer.put(data.path, data.content_type, data.filename)
      |> Boot.boost(conn.params, holospace)
    end
    
    Logger.debug "Cloud.POST // #{holospace} // #{inspect conn.params}"

    resp conn, 200, Pipe.page 
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
    |> put_resp_header("Location", url)
    |> send_resp(301, url)
  end
  
  match _ do
    send_resp(conn, 404, "oops")
  end
  
  ## Callbacks
  
  ## todo: <develop the NoFlo bridge here>
  
  # def handle_call({:getruntime, secret}, source, agent) do
  #   {:reply, secret, agent}
  # end
  
  def start_link(_) do
    link = {:ok, cloud} = GenServer.start_link(Cloud, Map.new, name: CloudServer)
    Logger.info "Cloud.start_link #{inspect cloud}"

    link
  end
  
end

