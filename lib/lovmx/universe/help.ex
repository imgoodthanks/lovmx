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