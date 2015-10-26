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
  
  Welcome to Cloudspace. Here, take this map...

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
  # in the network via establishing Cloud + Cloud links.

  # todo: much of the networking, discovery/propgation, and
  # auth parts and in need of good love. But the ideas and
  # proof of concepts should be mostly stubbed.
  
  https://en.wikipedia.org/wiki/Cloudgraphy
  https://en.wikipedia.org/wiki/Functional_reactive_programming
  https://github.com/flowbased/flowbased.org/wiki
  https://github.com/flowbased/flowbased.org/wiki/Concepts
  https://en.wikipedia.org/wiki/Persistent_data_structure
  https://raw.githubusercontent.com/reactive-streams/reactive-streams-jvm/v1.0.0/README.md
  """
  
  use Application

  # See http://elixir-lang.org/docs/stable/Application.html
  def start(type, data) do
    #Logger.debug @moduledoc
    
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Wizard,     [self]), # janitor
      worker(Machine,    [self]), # code/data/exe
      worker(Cloud,      [self]), # io/internal
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
    "README.magic" |> Cloud.read |> Cake.magic
  end

  ## Exit

  @doc "Good night sweet prince."
  def terminate(message, data) do
    #####Cloud.share "Lovmx.terminate: #{inspect data} message: #{inspect message}"
    
    # todo: properly shutdown the Bridge
    # Plug.Adapters.Cowboy.shutdown Bridge.HTTPS
    
    {:noreply, data}
  end

end
