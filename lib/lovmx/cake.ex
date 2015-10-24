require Logger

defmodule Help do

  # Genesis
  @epoch 0

  # some (developmental) delays may be needed on @tock
  @tick 110
  @tock 880
  @long @tick * @tock
  
  ## API

  @doc "Return an Lovmx unique keycode (UUID)."
  def keycode do
    UUID.uuid4
  end

  @doc "Return the regex that matches Lovmx.keycode"
  def keycode_regex do
    ~r/[0-9a-f]{8}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{12}/i
  end

  @doc "Return the base data/thing/element."
  def generic do
    "data"
  end

  @doc "Return one Bot tick."
  def tick do
    @tick
  end

  @doc "Return one Bot tock."
  def tock do
    @tock
  end

  @doc "Return one Bot long."
  def long do
    @long
  end

  @doc "Hang for `seconds`."
  def sleep(thing, seconds) do
    :timer.sleep seconds

    thing
  end
  def sleep(seconds \\ 1) do
    :timer.sleep seconds * 1000
  end

  @doc "Deserialize stuff (wrap binary_to_term call)."
  def thaw(data) do
    try do
      :erlang.binary_to_term(data)
    rescue
      x -> data
    end
  end

  @doc "Serialize stuff (wrap term_to_binary call)."
  def freeze(data) when is_binary(data) do
    data
  end
  def freeze(data) do
    :erlang.term_to_binary(data)
  end

  ## Paths

  @doc "Return *project* root-based path."
  def project(stuff) do
    root(stuff)
  end

  def root(stuff) when is_list(stuff) do
    stuff |> Path.join |> root
  end
  def root(path) when is_binary(path) do
    Path.join(List.flatten [File.cwd!, [path]]) |> path?
  end

  @doc "Return *project/priv/static* based paths (aka Outer World)."
  def web do
    ["priv", "static"] |> path
  end
  def web(stuff) when is_list(stuff) do
    stuff |> Path.join |> web
  end
  def web(path) when is_binary(path) do
    [web, [path]] |> path
  end

  @doc "Return *<whatever/warp/* path (aka Inner World paths)."
  def pull do
    "data"
  end
  def pull(stuff) when is_list(stuff) do
    pull(Path.join List.wrap stuff)
  end
  def pull(path) do
    [pull, [path]] |> path
  end

  @doc "Safely join path `stuff` and validate file existence OR throw via is_path()."
  def path(stuff = []) do
    "/"
  end
  def path(stuff = nil) do
    "/"
  end
  def path(stuff) when is_list(stuff) do
    Path.join Enum.map stuff, &(path &1)
  end
  def path(stuff) when is_atom(stuff) do
    stuff |> Atom.to_string |> path?
  end
  def path(stuff) when is_binary(stuff) do
    stuff |> path?
  end

  @doc "Shorthand wrapper for throw'ing unless is_path"
  def path?(holospace) when is_atom(holospace) or is_binary(holospace) do
    unless is_path(holospace) do
      throw "bad path: #{inspect holospace}"
    end

    holospace
  end

  @doc "todo: consolidate: Scrub `holospace` to make *safe* paths."
  def scrub(holospace) do
    # TODO: make compliant

    [holospace] 
    |> Path.join 
    |> String.strip
    |> String.replace ~r/^(a-z0-9\?\.\s)/, ""
  end

  @doc """
  Remixed from Plug. Get the original:
  https://raw.githubusercontent.com/elixir-lang/plug/master/lib/plug/static.ex

  Returns false for invalid paths.
  """
  def is_path(path) when is_binary(path) and path in [".", "..", ""], do: false
  def is_path([h|_]) when h in [nil, "..", "", "\\", " "], do: false
  def is_path([h|t]) do
    case :binary.match(h, ["\\", ":"]) do
      {_, _} -> false
      :nomatch -> is_path(t)
    end
  end
  def is_path(_), do: true
  
end

defmodule Kind do
  
  @moduledoc """
  # Kind
  ## Data Types / Data Signals

  # We use the module Kind to get one useful namespace word
  # that flows well in source code and natural language. Kind is
  # an abstract signal-like query notion. A `Freezer.list` may look 
  # differently then what a `News.list` result would be and
  # certainly different than a `html([results], Kind.list)` call
  # may use. So if we think about `Data` as being *unmanifested*
  # energy (all potential flowing data) then Kind almost becomes 
  # the first query/tag/category we can put on `Data` before
  # collecting it.
  
  # From the start of `Kind` module usage we always work toward natural
  # language and common sense naming. Take great, great care
  # in naming.
  """
  
  ## Flow Controls
  def data, do: :json # object/data/json
  def drop, do: :drop # nil/nada/noop/drop
  def boot, do: :boot # new/fresh
  def lock, do: :lock # lock/secret
  def meta, do: :meta # meta/control
  def list, do: :list # show/head/etc
  def pull, do: :pull # pull/get/read 
  def code, do: :code # source/code
  def push, do: :push # push/once/post/update
  def flow, do: :flow # run/exe/produce
  def wait, do: :wait # promise/future  
  
  ## Data Prototypes
  def text, do: :text # binary/text
  def link, do: :link # a path/URI/link
  def html, do: :html # an html snippet
  def blob, do: :blob # static/binary
  def cake, do: :cake # cake/magic
  ## ^^^ cake is first class ^^^ 
  
  ## Exception
  def boom, do: :boom # error/exception/
    
end

defmodule Cake do
  
  @moduledoc """
  # Cake
  ## Sugary sweet Cloud App texting language
  ### Build industrial strength Orbital Magic apps in Seconds.
  
  All energy/matter/vibration of Holospace is Cake.
  And it's Cake all the way down. Except for the `binary`
  that sits below Cake and which *ALL* calls should return. 
  Then it looks more like: CakeN > CakeN+1 > binary.
  
  Cake is a fun + simple Cloud App texting language for bringing
  Orbital Magic to your app. The idea is we type mostly plain 
  English code words like @share> homevideo.mp4 to activate ILvMx 
  Special Super Powers anywhere regular text is accepted. We
  then build up a world writable file system network of Cake
  documents and when one is executed it dynamically pulls
  all the data into a Markdown document, which then becomes
  the app the Player is using. Of course each and every one of 
  our actual users and user agents are connected to either their 
  very own Castle server (aka VPN/VPS) or connected to one of the 
  community free, shared, and moderated Castles.
    
  All energy/matter/vibration of Holospace is Cake.
  And it's Cake all the way down. Except for the `binary`
  that sits below Cake and which *ALL* calls should return. 
  Then it looks more like: Cake > Cake > binary.
  
  For examples see `README.magic` or @help, #help, #cake, etc.
  """
  
  @moduledoc "Use `Cake` to build industrial strength Orbital Magic apps."
  
  ##    *     *     *     *     *     *     *     *     *
  ##   |||   |||   |||   |||   |||   |||   |||   |||   |||   
  ## #######################################################
  ## ## Magic is powered by Cake ###########################
  ## #######################################################
  
  @doc "Machine a file at `path`."
  def mix(path) when is_binary(path) do
    #Logger.debug "Cake.mix #{path}"

    # scrub
    path = path |> Help.path?

    # best effort the file..
    case Path.extname(path) do
      ".exs"    -> {data, _} = Code.eval_file(path)
      ".eex"    -> EEx.eval_string Tube.read(path), assigns: []
      ".magic"  -> Tube.read(path) |> Cake.magic
      _ ->
        Data.boom("#weird `#{path}` *seems* to have a problem...")
    end
  end
  
  @doc "Render a template from `path` and render the template with our Data."
  def kit(path) do
    EEx.eval_file Help.web path
  end
  def kit(data = %Data{}, path) do
    EEx.eval_file Help.web(path), assigns: [data: data]
  end
  
  def magic(text) when is_binary(text) do
    magic Data.new text
  end
  def magic(data = %Data{thing: text}) when is_binary(text) do
    Logger.warn "Cake.magic: #{inspect data.keycode}"
    
    # we are a superset of markdown, so mark it first..
    text = Pipe.down(text)
    #Logger.debug "Cake.magic2: #{inspect text} // #{inspect data}"
    
    # # our magicdown regex.
    # match = ~r/[^|\s]{0,}\@([a-z0-9]{2,})\>\s([a-z0-9\#\%\?\s]{2,})/i
    #
    # # compile Data + markup from original simple text
    # cake = Regex.replace match, text, fn(cap, code, opts) ->
    #   {data, replace} = x(data, cap, code, opts)
    #
    #   replace
    # end
    # Logger.debug "Cake.magic3: #{inspect text} // #{inspect data}"
    
    # then flow it baby
    text 
    |> Flow.into(data) 
  end
  def magic(nada) when is_nil(nada) do
    # there is no magic here.. :(

    nil
  end
  
  # def x(data = %Data{}, signal, "code", source) do
  #   #Logger.debug "#path // #{inspect signal} // #{inspect data}"
  #
  #   data = Data.code(data, source)
  #   #Logger.debug "#code // #{inspect source }"
  #
  #   {data, Pipe.text(source)}
  # end
  # def x(data = %Data{}, signal, "list", path) do
  #   # get the list
  #   list = Holo.space(path)
  #   #Logger.debug "#list // #{inspect list}"
  #
  #   {Data.renew(data, list), Pipe.text(list)}
  # end
  def x(data = %Data{}, signal, "boot", opts) do
    Logger.warn "#boot // #{inspect signal}  #{inspect opts}"
    
    # todo: spawn(signal, code.to_existing_atom, [opts])
    
    {data, opts}
  end
  def x(data = %Data{}, signal, code, opts) do
    #Logger.debug "#signal // #{inspect signal } // #{inspect code} // #{inspect opts}"
    
    # todo: spawn(signal, code.to_existing_atom, [opts])
    
    {data, code}
  end
    
end

defmodule Magic do
  
  @moduledoc "Use `Magic` to optimize your Elixir."
  
  defmacro __using__(_options) do
    quote do
            
      Code.ensure_loaded Data
      import Data

      Code.ensure_loaded Flow
      import Flow
      
      Code.ensure_loaded Pipe
      import Pipe

      Code.ensure_loaded Holo
      import Holo
      
      Code.ensure_loaded Tube
      import Tube
      
      Code.ensure_loaded Machine
      import Machine
      
      Code.ensure_loaded Cake
      import Cake
      
      require Logger
      
    end
  end
  
end

defmodule OrbitalMagic do
    
  @moduledoc "Use `OrbitalMagic` for easy web apps."
  
  defmacro __using__(_options) do
    quote do

      import Plug.Conn
      use Plug.Router
      use Plug.Builder
      plug :match
      plug :dispatch
      use WebAssembly
      
    end
  end
  
end

defmodule OrbitalMaru do
  
  @moduledoc "Use `OrbitalMaru` for easy HTTP APIs."
  
  defmacro __using__(_options) do
    quote do

      import Plug.Conn
      use Maru.Router
      plug Plug.Logger
      use WebAssembly
    end
  end
  
end
