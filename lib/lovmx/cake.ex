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
      ".exs"    ->
        {data, binding} = Code.eval_file(path)

        binding

      # ".eex"    ->
      #   data = EEx.eval_string Drive.read(path), assigns: []
      
      ".magic"  -> 
        data = Drive.read(path) 
        |> Data.new 
        |> Cake.magic
        |> Cake.x(:beam, :beam, path)
        
      _ ->
        Data.boom("#weird `#{path}` *seems* to have a problem...")
    end
  end
  
  @doc "Render a template from `path` and render the template with our Data."
  def kit(path) do
    EEx.eval_file Help.web path
  end
  # def kit(data = %Data{}, path) do
  #   Data.code(fn data ->
  #     EEx.eval_file(Help.web(path), assigns: [data: data])
  #     |> Flow.feed(data)
  #   end)
  # end
  
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
  
  ## Compile Cake + Data
  
  def x(data = %Data{}, text) when is_binary(text) do
    Logger.debug "Cake.x.i // #data // #{inspect data}"
    
    # we are a superset of markdown, so mark it first..
    text = Pipe.down(text)
    text = Regex.replace(~r/\n/, text, "\n")
    
    # our magicdown regex.
    match = ~r/[^|\s]{0,}\@([a-z0-9]{2,})\.\s{1,}([a-z0-9\#\%\?\s]{2,})/i
    
    # compile Data + markup from original simple text
    cake = Regex.replace match, text, fn(capture, code, opts) ->
      {data, replace} = x(data, capture, code, opts)
      
      replace
    end
    Logger.debug "Cake.x.o // #data // #{inspect data}"
    
    # then flow it baby
    
    data = Flow.feed(cake, data, Kind.cake)
    
    {data, text} = x(data, :capture, :beam, nil)
    
    data = Flow.feed(text, data, Kind.text)
    
    data
  end
  def x(data = %Data{}, capture, code, secret) when code in [:beam, "beam"] do    
    # create our action
    # create our side effect text
    # return both
    data = data
    |> Flow.beam(secret)
    |> Flow.graph(secret)
    |> Holo.boost(code)
    
    #Logger.warn "Cake.x.beam // #data // #{inspect data}"
    
    {data, Pipe.text(data)}
  end
  def x(data = %Data{}, capture, code, holospace) when code in [:list, "list"] do
    # graph our data/action
    data = Drive.list(holospace)
    
    # create our side effect text
    text = Pipe.text(data)

    # feed text to data
    data = text |> Flow.feed(data, Kind.text)

    # return both
    {data, text}
  end
  # def x(data = %Data{}, capture, code, secret) when code in [:meta, "meta"] do
  #   # create our action
  #   # create our side effect text
  #   # return both
  #   {data, Pipe.text(data.meta)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:lock, "lock"] do
  #   # create our action
  #   # create our side effect text
  #   # return both
  #   {Castle.lock(data, secret), Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:list, "list"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:pull, "pull"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:code, "code"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:flow, "flow"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:push, "push"] do
  #   # get the list + return the upgraded data
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:wait, "wait"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:drop, "drop"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:text, "text"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:link, "link"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:html, "html"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:blob, "blob"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, secret) when code in [:cake, "cake"] do
  #   {data, Pipe.text(data)}
  # end
  # def x(data = %Data{}, capture, code, path)   when code in [:kit,  "kit"] do
  #   # get the kit
  #   string = Cake.kit(path)
  #
  #   # feed the kit to data
  #   data = string
  #   |> Flow.feed(data, Kind.text)
  #
  #   {data, string}
  # end
  # def x(data = %Data{}, capture, code, source) do
  #   {data, Pipe.text(data)}
  # end
    
end
