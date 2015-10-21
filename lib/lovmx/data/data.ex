require Logger

defmodule Data do
  
  @moduledoc """
  # Data
  ## Data Tree of Life.
  
  Data is both a particle (module) *and* a wave (capture/flow). 
  Data changes, thats the secret. We create Data and we *change* 
  Data.
  
  There are sixteen basic datas in the whole everything. 
  
  In force, LovMx tries to apply a Data-first then It Rocks. test.
  Next and we try for functional, reactive, and monadic-like approaches. 
  We try to keep each module as focused and DRY as possible at the
  highest abstraction and resemblance to natural language that we can,
  while also still trying to make nice bits and bytes for the computers.
  
  Our `use Magic` include and `use OrbitalMagic` simply combine
  as much of of the Custom API we can to Flow Based Programming in 
  Elixir. 
  
  #note: Our data/flow struct size is pretty big but we can make it
  fast and imagine lots of easy behind the scenes struct mutations and
  optimization down the road. Or you know, we all chooose to deal with 
  big packets..
  
  #note: the main focus has been to get a beautiful API nailed down at
  all cost. Then make it work. Then make it stream/concurrent. Then fast. 
  
  There are lots of #todos left, and we will be bootstrapping a code
  bounty on lovmx.com or internally @lovmx> at some point.
  """
  
  defstruct keycode: nil,
    home: nil,    # <process> or <secret> or <nubspace>
    kind: nil,    # default to :init or see `Kind` + `cake.ex`
    time: nil,    # genesis/duration/etc
    life: nil,    # microseconds/duration/expiration
    
    meta: %{},    # %{} a metadata map
    help: [],     # [messages] notes/readme
    bugs: [],     # [errors/exceptions]
    
    pull: %{},    # *startup* input (aka ROM)
    code: [],     # [functions] current program
    push: %{},    # *output* ports  (aka Post)
    native: nil,  # *computed* data (aka CPU)
    
    tick: 0,      # epoch/time/version
    roll: [],     # *previous* data (aka Backup)
    jump: %{},    # *potential* data
    ping: %{}     # *latest/social* (aka Social)

  @derive [Enumerable]

  ## Creating Data - See `flow.ex` and `pipe.ex` for more about data flows.
  
  @doc "Use `Data.new` to create new Data from native `real` data."
  def new(native \\ nil, kind \\ Kind.init, meta \\ %{}) do
    data = %Data{
        keycode: Lovmx.path(["data", Lovmx.keycode]),
           kind: kind,
           time: Moment.now,
           life: Lovmx.long,
           meta: Map.merge(%{}, meta || %{}),
         native: native
    }
    |> Holo.x
  end
  
  @doc "Restart Data w/ new `native`."
  def renew(data = %Data{}, native) do
    # save a rollback version
    data = Data.tick(data)
    #update internal data
    data = put_in(data.native, native)

    data
  end
    
  @doc "Use `Kind.meta` controls to help the data flow."
  def meta(data = %Data{}, signal, effect \\ nil) do
    put_in(data.meta, Map.put(data.meta, signal, effect))
    |> Holo.x
  end

  @doc "Use `Data.kind` to mutate the data type using custom or Kind types."
  def kind(data = %Data{}, kind \\ Data.init) do
    data = put_in data.kind, kind
  end
  
  @doc "Return *current* `data.native`."
  def native(data = %Data{}) do
    # todo: get the data from holo
    
    data.native
  end
    
  @doc "Readme first."
  def help(data = %Data{}, message) do
    put_in(data.help, Enum.concat(data.help, [message]))
    |> Holo.x
  end
    
  @doc "Use `Data.tick` to create a temporal notation (aka version) of `data` at this time."
  def tick(data = %Data{}, reboot \\ false) do
    current = data
    data = put_in data.roll, Enum.concat(data.roll, [current])
    
    if reboot do
      data = put_in data.jump, %{}
      data = put_in data.pull, %{}
    
      # blank the :pulls so next time through it'll re-fire w/ fresh data
      Enum.map data.pull, fn {key, value} ->
        data = put_in data.pull, Map.put(data.pull, key, Kind.init)
      end
    end
    
    # epoch
    data = put_in data.tick, data.tick + 1
    
    # Update the world.
    Holo.x data
  end
  
  @doc "Return inside `data` at `path`."
  def path(data = %Data{}, path) when is_atom(path) or is_binary(path) do
    Map.get data.pull, path
  end
  def path(path, data = %Data{}) when is_atom(path) or is_binary(path) do
    Map.get data.pull, path
  end
  
  @doc "Morph Data into whatever `function` returns."
  def morph(data = %Data{}, function) when is_function(function) do
    # Data can morph, return whatever Data or other thing from function
    function.(data)
  end
  
  @doc "Genetic Clone."
  def clone(data = %Data{}) do
    clone = Data.new
    clone = put_in clone.help,  data.help
    clone = put_in clone.code,  data.code
    clone = put_in clone.pull,  data.pull
    clone = put_in clone.push,  data.push

    clone
  end

  @doc "Add an error `message` to Bot."
  def bugs(data = %Data{}, message) when not is_nil(message) do
    Data.tick put_in(data.bugs, List.flatten [List.wrap(message)|data.bugs])
  end

  @doc "Rollback `data` to a previous version."
  def roll(data = %Data{}, tick \\ nil) do
    # init version
    if !tick do
      if data.tick > 0 do
        tick = data.tick - 1
      else
        tick = data.tick
      end
    end
    
    # pull the old version
    Tube.read Lovmx.web Lovmx.path ["#{tick}", data.keycode]
  end
  
  @doc "Jump data to an unknown future if exe `code` passes `test`."
  def jump(data = %Data{}, nubspace, code, test) do
    result = code.(data)

    if test.(result) do
      data = put_in(data.jump, Map.put(data.jump, nubspace, result))
      |> Data.tick
      |> Holo.x
    else
      data
    end
  end
  
  ## Meta/Error/Exception
  
  def error, do: :error
  def error(error) do
    error
    |> Data.new
    |> Data.kind(Kind.stop)
    |> Data.tick
  end
  def bugs(data, error \\ nil) do
    %{ data | bugs: Enum.concat(data.bugs, [error]) }
    |> Data.tick
  end
  
end