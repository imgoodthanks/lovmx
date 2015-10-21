require Logger

defmodule Pipe do
  
  @moduledoc """
  # Pipe
  ## Push Data through a series of tubes and Nubspace Port(s).
  ### Pipe(s) manage the Data/Output life cycle.
  
  Tree of Life:
  -------------
  - Pipe(s) live *below* data/holo
  - Pipe(s) live *lateral* to data/machine
  - Pipe(s) live *above* the warps/elixir/server

  # todo: formal protocols + Pipe API extensions

  See more:
  https://github.com/flowbased/flowbased.org/wiki/Concepts
  """
    
  ## Static Tranforms 
  # for *complex* transforms we use Bots, Flows, and Pipes
  
  @doc "Pipe to a Cake/Magic document."
  def magic(data = %Data{}, nubspace, secret \\ nil) do
    Cake.magic(data)
    |> Tube.save(nubspace, secret)
  end
  
  @doc "Create static HTML pages."
  def page(data = %Data{}) do
    page data, data.keycode
  end
  def page(data = %Data{}, nubspace, secret \\ nil) do  
    # build page/results
    page = Enum.join([
      Cake.kit("html/header.html"),
      html(Cake.magic(data)),
      Cake.kit("html/footer.html"),
    ])
    
    # write the page to whatever it wanted
    #Tube.save page, Lovmx.web(nubspace)
    
    page
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
  def page(data) when is_map(data) do
    Enum.join([
      Cake.kit("html/header.html"),
      Enum.map(Map.to_list(data), &(html &1)),
      Cake.kit("html/footer.html"),
    ])
  end
  def page(data) when is_binary(data) do
    Enum.join([
      Cake.kit("html/header.html"),
      data,
      Cake.kit("html/footer.html"),
    ])
  end
  def page(data) do
    page(inspect data)
  end
  
  @doc "Create HTML snippets."
  def html(data, nubspace \\ "/", secret \\ nil)
  
  def html(data = %Data{native: data}, nubspace, secret) when is_list(data) do
    html Enum.map data, &(html &1)
  end
  def html(data = %Data{kind: :link}, nubspace, secret) do
    ####Holo.share "Pipe.html #{inspect data}"
    "<code class=\"data\">
    <a href='#{Lovmx.path [nubspace, data.native]}'>#{data.native}</a>
    </code>"
  end
  def html(data = %Data{native: %Data{kind: kind, meta: path}}, nubspace, secret) when is_binary(path) do
    #Holo.share "Pipe.html %Data{native: %Data{kind: kind, meta: path}}"
    if Freezer.extension(kind) do
      "<img src='#{path}'>"
    else
      text(data)
    end
  end

  def html(things, nubspace, secret) when is_list(things) do
    Enum.join Enum.map things, &(html &1, nubspace, secret)
  end
  def html(data, nubspace, secret) when is_binary(data) do
    "<pre class=\"text\">#{data}</pre>"
  end
  def html(other, nubspace, secret) do
    "<pre class=\"other\">#{inspect other}</pre>"
  end

  @doc "Return `Kind.pull = markdown(text)`."
  def down(text) when is_binary(text) do
    Cmark.to_html(text)
  end

  @doc "Create JSON for easy API/web access."
  def json([list]) when is_list(list) do
    Enum.map list, &(json &1)
  end
  def json(effects) do
    Poison.encode!([inspect(effects)])
  end
  def json do
    json "#nada: #{inspect self}"
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
#{data.native}
"""
  end
  def text(data = %Data{home: home}) when is_pid(home) do
    PrettyHex.pretty_hex data.home
  end
  def text(data) when is_atom(data) or is_binary(data) do
    data
  end
  def text(data) do
    PrettyHex.pretty_hex inspect data
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
  def text(data = %Data{}) do
"""
```
#warp // <a href='warp/#{data.tick}/#{data.keycode}' class='automagic'>#{data.keycode}</a>

#tick // #{data.tick}

#help // #{data.help}

#meta // #{inspect data.meta}

#bugs // #{inspect data.bugs}

#data // #{inspect data.native}

#code // #{inspect length(data.code)} codes

```
"""
  end
  def text(data) do
"""
```
#data:
#{inspect data}
```
"""
  end
    
  @doc "Drop `data` to /dev/null."
  def drop(whatever) do
    # todo: track noops to help manage machines
    # Holo.noop whatever
    
    nil
  end
  
  @doc "Return ``."
  def debug(data) do
    inspect data
  end

end
