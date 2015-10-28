require Logger

defmodule Pipe do
  
  @moduledoc """
  # Pipe
  ## Push Data through a series of tubes.
  ### Pipe(s) manage the Data |> Output life cycle.
  
  Tree of Life:
  -------------
  - Pipe(s) live *below* data/flow/holo
  - Pipe(s) live *after* to data/machine
  - Pipe(s) live *above* the warps/elixir/server

  # todo: formal protocols + Pipe API extensions

  See more:
  https://github.com/flowbased/flowbased.org/wiki/Concepts
  """
    
  ## Static Tranforms 
  # for *complex* transforms we use Bots, Flows, and Pipes
  
  # @doc "Match outgoing Data."
  # def catch(data = %Data{}) do
  #   data
  # end

  @doc "Pipe to a Cake/Magic document."
  def magic(data = %Data{}, holospace, secret \\ nil) do
    Cake.magic(data)
    |> Cloud.save(holospace, secret)
  end
  
  @doc "Create static HTML pages."  
  def page(things = %Stream{}) do
    Logger.debug "Pipe.page #{inspect things}"
    
    # create the binary/html
    things
    |> Enum.to_list
    |> page
  end
  def page(things) when is_list(things) do
    page Enum.join(Enum.map things, &(html &1))
  end
  def page([]) do
    page ""
  end
  def page(nada) when is_nil(nada) do
    page ""
  end
  def page do
    page ""
  end
  def page(text) when is_binary(text) do
    Enum.join([
      Cake.kit("html/header.html"),
      text,
      Cake.kit("html/footer.html"),
    ])
  end
  def page(thing) do
    Logger.debug "Pipe.page #{inspect thing}"

    page(inspect thing)
  end
  
  @doc "Create HTML snippets."  
  def html(data = %Data{thing: data}) when is_list(data) do
    html Enum.map data, &(html &1)
  end
  def html(data = %Data{kind: :link}) do
    ####Cloud.boost "Pipe.html #{inspect data}"
    "<code class=\"data\">
    <a href='#{Help.path [data.meta.base, data.thing]}'>#{data.thing}</a>
    </code>"
  end
  def html(data = %Data{thing: %Data{kind: kind, meta: path}}) when is_binary(path) do
    #Cloud.boost "Pipe.html %Data{thing: %Data{kind: kind, meta: path}}"
    if Freezer.extension(kind) do
      "<img src='#{path}'>"
    else
      text(data)
    end
  end
  def html(things) when is_list(things) do
    Enum.join Enum.map things, &(html &1)
  end
  def html(data) when is_binary(data) do
    "<code class=\"text\">#{data}</code>"
  end
  def html(other) do
    "<code class=\"other\">#{inspect other}</code>"
  end

  @doc "Return `Kind.pull = markdown(text)`."
  def down(text) when is_binary(text) do
    Cmark.to_html(text)
  end
  
  @doc "Create JSON for easy API/web access."
  def json([list]) when is_list(list) do
    Enum.map list, &(json &1)
  end
  def json(things) do
    Poison.encode!([inspect(things)])
  end
  
  @doc "Render args as debug/text."
  def text([]) do
    """
    ```
    []
    ```
    """
  end
  def text(things) when is_list(things) do
    Enum.join Enum.map things, &(text &1)
  end
  def text(data = %Data{kind: :link}) do
    """
    #{data.thing}
    """
  end
  def text(data = %Data{home: home}) when is_pid(home) do
    PrettyHex.pretty_hex data.home
  end
  def text(data) when is_atom(data) or is_binary(data) do
    """
    ```
    #data:
    #{data}
    ```
    """
  end
  def text(data = %Data{}) do
    """
    ```
    #warp // <a href='warp/#{data.tick}/#{data.keycode}' class='automagic'>#{data.keycode}</a>

    #tick // #{data.tick}

    #help // #{data.help}

    #meta // #{inspect data.meta}

    #boom // #{inspect data.boom}

    #data // #{inspect data.thing}

    #code // #{inspect length(data.code)} codes

    ```
    """
  end
  def text(data) do
    """
    ```
    #data:
    #{inspect PrettyHex.pretty_hex inspect data}
    ```
    """
  end
  
  @doc "Drop `data` to /dev/null."
  def drop(whatever) do
    # todo: track noops to help manage machines
    # Cloud.noop whatever
    
    nil
  end
  
  @doc "Return ``."
  def debug(data) do
    inspect data
  end
  
end
