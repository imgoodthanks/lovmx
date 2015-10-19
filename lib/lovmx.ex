# ILvMx, Lovmx, and all related sub-projects and all related
# sub-directories and source code are Copyright 2015 #lovmx
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

  LovMx + ILvMx are free and open source nonprofit 
  global projects to host a namespace of code/data/blobs.
  
  We are fun (silljays.com).
  We develop a cloud app server <-[You are here.] 
  We created a reference cloud app client (lolnub.app). 
  We host a public data service (ilvmx.com).
  We give away the best Web Theme Park on the net. (lolnub.com)
  
  In a nutshell, we wanna build: 
   
  An Elixir-based Wolfram Language clone 
  powered by a Twitter like network 
  of Markdown-style documents 
  for Clients connected to their own private VPNs/VMs
  running an Orbital Magic framework written in the 
  sexiest language/runtime in the world, oh my dear love Erlang/Elixir, 
  for the purpose of creating a grassroots network
  of Code + Data + Blob storage aka Cake Apps 
  written by commerce and community 
  in a *meticulously* namespaced 
  v2v storage-based network made 
  completely open source and transparent.
  
  Yeah that sounds right.
  
  Welcome to #nubspace. Here, take this map...

  ## LovMx - Nubspace Tree of Life.
  #############################################################
  
  Generally speaking, the Multiverse has three parts above,
  three below, and only really a few things in the middle we 
  need to actually care about.

  # graph/higher

  - Data // both a particle (code/data) and a wave (roll/jump)
  - Flow // push/pull data from other `nubspace` and `data`
  - Pipe // push one-way `data` to other parts of `nubspace`
  
  # universe
  - Bot // easily create code + data components w/ a variety of data
  - Bridge // default HTTPS API server and NoFlo gateway
  - Player // user agents
  
  # vmx
  - Holo // global namespace of code + data storage
  - Machine // the virtual/physical code/server object 
  - Tube // input/output API endpoints
  
  # hyperverse
  - Cake // All energy/matter/movement
  - Wizard // like a galactic nuclear janitor
  
  
  ## LovMx - Multiverse
  #############################################################
  
  –––––––––––––––––––
  [universe]
  –––––––––––––––––––
  [vmx/holo]
  [vmx/machine]
  [vmx/tube]
  –––––––––––––––––––
  [server/multiverse]
  –––––––––––––––––––
  
  ## LovMx - VMX (Virtual Machine eXchange)
  #############################################################

  # pattern |  in              out   | side effects
  #–––––––––|––––––––––––––––––––––––|–––––––––––––––––––––––––
  # data    |  Holo \       / Tube   | output |> html/json/etc
  #–––––––––|––––––––––––––––––––––––|–––––––––––––––––––––––––
  # actual  |        Machine         | files/sockets/https
  #–––––––––|––––––––––––––––––––––––|–––––––––––––––––––––––––
  

  ## NOTES
  #############################################################
  
  # Check out Bridge for a standard LovMx module, it also
  # works well as an example `Application` (aka Elixir 
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
      worker(Wizard,     [self]), # system
      worker(Holo,       [self]), # data/in
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lovmx.Supervisor]

    ## Supervisor

    link = {:ok, supervisor} = Supervisor.start_link(children, opts)
    Logger.info "Lovmx.Supervisor: #{inspect link}"

    # children |> Enum.map fn child ->
    #   Holo.orbit "#supervisor // #{inspect supervisor} // #{inspect child}"
    #   Holo.install child
    # end
          
    Logger.info  "Lovmx.start #{inspect self}"
    
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
  def path?(nubspace) when is_atom(nubspace) or is_binary(nubspace) do
    unless is_path(nubspace) do
      throw "bad path: #{inspect nubspace}"
    end

    nubspace
  end

  @doc "todo: consolidate: Scrub `nubspace` to make *safe* paths."
  def scrub(nubspace) do
    #todo: make compliant

    [nubspace] 
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
    #####Holo.orbit "Lovmx.terminate: #{inspect data} message: #{inspect message}"

    {:noreply, data}
  end

end
