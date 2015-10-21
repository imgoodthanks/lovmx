# Lovmx and all related sub-projects and all related
# sub-directories and source code are Copyright 2015 Silljays.com
# developers AND licensed as free and open source software:
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require Logger

defmodule Lovmx do
  
  @moduledoc """
  # LovMx + ILvMx.
  ## Orbital Magic for Cloud Apps.
  ### Internet LoveMx + Internet Love and #virtual Magic #exchange

  LovMx + ILvMx are free and open source nonprofit projects 
  to host a global namespace of code/data/blobs.
  
  We are fun (silljays.com).
  We develop a cloud app server (this project).
  We develop a reference cloud app client (lolnub.app). 
  We host a public data service (ilvmx.com).
  We give away the best Web Theme Park on the net. (lolnub.com)
  
  Welcome to Holospace. Here, take this map...

  See `README.magic` or @readme inside LovMx for more.
  
  ## NOTES
  #############################################################
  
  # Check out Bridge for a standard LovMx module, it also
  # works well as an example `Application` (aka the Elixir 
  # Module) you would need to write to use the LovMx on
  # your own.

  # This Bridge uses the server flavor of OrbitalMagic 
  # but we also have an awesome Maru based include for
  # building data APIs.. check out `lib/cake.ex` to see 
  # more about and how other Orbital Magic works.

  # The LovMx also works well inside a Phoenix app
  # (see www.ilvmx.com or github.com/silljays/ilvmx)
  # because the LovMx loves to flip the Bird. Phoenix 
  # channels plus <3 this universe.

  # Finally, the server can be started from the command
  # line (aka standalone) optionally initated into the 
  # the ilvmx/galaxy/:whatever

  # In Galaxy mode the server will search #todo for other 
  # LovMx nodes and automatically begin participating
  # in the network via establishing Holo + Tube links.

  # todo: much of the networking, discovery/propgation, and
  # auth parts and in need of good love. But the ideas and
  # proof of concepts should be mostly stubbed.
  
  https://en.wikipedia.org/wiki/Holography
  https://en.wikipedia.org/wiki/Functional_reactive_programming
  https://github.com/flowbased/flowbased.org/wiki
  https://github.com/flowbased/flowbased.org/wiki/Concepts
  https://en.wikipedia.org/wiki/Persistent_data_structure
  https://raw.githubusercontent.com/reactive-streams/reactive-streams-jvm/v1.0.0/README.md
  """
  
  use Application

  # Genesis
  @epoch 0

  # some (developmental) delays may be needed on @tock
  @tick 110
  @tock 880
  @long @tick * @tock
  
  # See http://elixir-lang.org/docs/stable/Application.html
  def start(type, data) do
    #Logger.debug @moduledoc
    
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Wizard,     [self]), # janitor
      worker(Holo,       [self]), # io/internal
      worker(Machine,    [self]), # code/data/compute
      worker(Tube,       [self]), # io/external
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lovmx.Supervisor]

    ## Supervisor
    link = {:ok, supervisor} = Supervisor.start_link(children, opts)
    
    Logger.info "Lovmx.Supervisor: #{inspect link}"
    children |> Enum.map fn child ->
      Logger.debug "!supervisor // #{inspect supervisor} // #{inspect child}"
    end
    
    Logger.info  "Lovmx.start #{inspect link}"
    
    # Kickoff the First Creation of Init.
    Wizard.bang
    
    link
  end

  ## Metaversal

  @doc "Readme first. Don't panic."
  def help do
    "README.magic" |> Tube.read
  end

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

  ## Exit

  @doc "Good night sweet prince."
  def terminate(message, data) do
    #####Holo.share "Lovmx.terminate: #{inspect data} message: #{inspect message}"
    
    # todo: properly shutdown the Bridge
    # Plug.Adapters.Cowboy.shutdown Bridge.HTTPS
    
    {:noreply, data}
  end

end
