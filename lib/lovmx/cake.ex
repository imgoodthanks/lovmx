require Logger

defmodule Cake do
  
  @moduledoc """
  # Cake
  ## Sugary sweet Cloud App texting language
  ### Build industrial strength Orbital Magic apps in Seconds.

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
  
  @doc "Bot a file at `path`."
  def mix(path) when is_binary(path) do
    

    # scrub
    path = path |> Help.path?

    # best effort the file..
    case Path.extname(path) do
      ".exs"    -> {data, _} = Code.eval_file(path)
      ".eex"    -> EEx.eval_string Drive.read(path), assigns: []
      ".magic"  -> Drive.read(path) |> Cake.magic
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
  
  def magic(data = %Data{kind: :blob, thing: filename, meta: %{base: base, root: root}}, secret) 
  when is_binary(filename) and is_binary(base) and is_binary(root) do
    path = Help.path [base, filename]
        
    Cake.x data, Drive.read path
  end
  
  def magic(data = %Data{thing: text}) when is_binary(text) do
    Cake.x data, text
  end
  
  def magic(nada) when is_nil(nada) do
    # there is no magic here.. :(

    nil
  end
  
  def x(data = %Data{}, text) when is_binary(text) do
    # we are a superset of markdown, so mark it first..
    text = Pipe.down(text)
    text = Regex.replace(~r/\n/, text, "\n")
    
    # our magicdown regex.
    match = ~r/[^|\s]{0,}\@([a-z0-9]{2,})\>\s([a-z0-9\#\%\?\s]{2,})/i

    # compile Data + markup from original simple text
    cake = Regex.replace match, text, fn(cap, code, opts) ->
      {data, replace} = x(data, cap, code, opts)

      replace
    end
    
    # then flow it baby
    Flow.give(cake, data, Kind.cake)
  end
  def x(data = %Data{}, signal, "code", source) do
    data = Bot.code(data, source)
    

    {data, Pipe.text(source)}
  end
  def x(data = %Data{}, signal, "list", path) do
    # get the list
    list = Holo.space(path)
    

    {Flow.upgrade(data, list), Pipe.text(list)}
  end
  def x(data = %Data{}, signal, "boot", opts) do    
    # todo: spawn(signal, code.to_existing_atom, [opts])
    
    {data, opts}
  end
  def x(data = %Data{}, signal, code, opts) do
    
    
    # todo: spawn(signal, code.to_existing_atom, [opts])
    
    {data, code}
  end
    
end
