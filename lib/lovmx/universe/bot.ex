require Logger

defmodule Bot do
  
  @moduledoc """
  # Bot
  ## Bot(s) are a module to map `code` + `data` to `nubspace` Machine(s).
  ### aka. Globally Persistent Code and Data Storage Component(s).
  
  Bot are animated and friendly little helpers.

  Bot like to eat `Cake` and write code for `Data` and `Player`s
  and should be considered when interacting with any native, 
  static, primitive, or nubspace based object(s) in need of 
  holographic intelligence.

  Good Bot should be fun, simple, and enjoy `Cake` immensely.

  Learn more:
  https://lovmx.com/help/bot
  
  Or on the web:
  https://en.wikipedia.org/wiki/Persistent_data_structure
  
  tl;dr - Bot(s) manage Code for Machine Data. 
  """
  
  # Send signals to Machines.
  
  @doc "Use `Kind.meta` controls to help the data flow."
  def meta(data = %Data{home: machine}, signal, effect \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:meta, signal, effect}
  end
  
  @doc "Add code to Data"  
  def c(function) when is_function(function) do
    code(function)
  end
  def code(function) when is_function(function) do
    code Data.new, function
  end
  def code(data = %Data{}, function) when is_function(function) do
    # todo: better update meta
    Data.tick put_in(data.code, Enum.concat(data.code, [function]))
  end
  def code(block = [do: _]) do
    code Data.new, block
  end
  def code(data = %Data{}, block = [do: _]) do
    code data, fn data ->
      block
    end
  end
  def code(data = %Data{home: machine}, nubspace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:code, nubspace, secret, duration}
  end
  
  def list(data = %Data{home: machine}, nubspace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:list, nubspace, secret, duration}
  end
  
  #@doc "Ask the agent/player/whatever for further input..."
  # def stub do
  #   #todo: item this up
  #   IO.gets :stdin
  # end
  # def stub(data = %Data{}) do
  #   #todo: item this up
  #   Data.code(data, fn x ->
  #     Holo.share x, IO.gets :stdin
  #   end)
  # end
  def stub(data = %Data{home: machine}, nubspace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:stub, nubspace, secret, duration}
  end
  
  def pull(data = %Data{}) do
    Tube.read Lovmx.web ["#{data.tick}", data.keycode]
  end
  def pull(data = %Data{home: machine}, nubspace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:pull, nubspace, secret, duration}
  end
  
  def loop(data = %Data{home: machine}, nubspace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:flow, nubspace, secret, duration}
  end
  
  def data(data = %Data{home: machine}, nubspace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:data, nubspace, secret, duration}
  end
    
  @doc "Stop flowing."
  def stop(data = %Data{home: machine}, nubspace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:stop, nubspace, secret, duration}
  end
  
end