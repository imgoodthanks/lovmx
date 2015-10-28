require Logger

defmodule App do
  
  use Magic, oribtal: Plug
  import Plug.Conn
  
  def init(data \\ nil) do
    Logger.warn "App.init // #{inspect data}"
  end
  
  @doc "GET: Route *all* generic PULL signals from HTTPS."
  def call(conn = %Plug.Conn{method: "GET", path_info: holospace}, agent) do
    
    # hack to reset universe on each request
    Wizard.reset_all!

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
      case data = Holo.space(holospace) do
        data when is_list(data) ->
          resp conn, 200, Pipe.page data

        data = %Data{kind: :link, thing: thing} when is_atom(thing) or is_binary(thing) ->
          Cloud.redirect conn, thing

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
      |> Holo.boost(conn.params, holospace)
    end

    #Logger.debug "Cloud.POST // #{holospace} // #{inspect conn.params}"

    resp conn, 200, Pipe.page Drive.read Help.web holospace
  end
  
end