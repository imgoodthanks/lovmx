require Logger

defmodule Machine do
    
  @moduledoc """
  # Machine
  ## Code + Data
  ### FBP Component / Process
  """
  
  use GenServer
  use Connection
  import Kind
  
  ## APIs
  
  def boot(data = %Data{}) do
    link = {:ok, machine} = Machine.start_link(data)
    Logger.debug "Machine.boot // #{inspect machine} // #{inspect data}"
    
    machine
  end
  
  def data(machine, secret \\ nil, duration \\ Help.tock) when is_pid(machine) do
    GenServer.call machine, {flow, secret, duration}
  end
  
  # def meta(data = %Data{home: machine} \\ nil, signal, effect \\ nil) when is_pid(machine) do
  #   GenServer.call data.home, {:meta, signal, effect}
  # end
  #
  # def lock(data = %Data{home: machine}, signal \\ nil, effect \\ nil) when is_pid(machine) do
  #   GenServer.call data.home, {:meta, signal, effect}
  # end
  #
  # def list(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
  #   GenServer.call data.home, {:list, holospace, secret, duration}
  # end
  #
  # def pull(data = %Data{}) do
  #   Drive.read Help.web ["#{data.tick}", data.keycode]
  # end
  #
  # def pull(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
  #   GenServer.call data.home, {:pull, holospace, secret, duration}
  # end
  #
  # def push(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
  #   GenServer.call data.home, {:flow, secret, duration}
  # end
  #
  # def flow(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
  #   GenServer.call data.home, {:data, holospace, secret, duration}
  # end
  #
  # def wait(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
  #   # TODO: item this up
  #   Machine.code(data, fn x ->
  #     Cloud.share x, IO.gets :stdin
  #   end)
  # end
  #
  # def drop(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
  #   GenServer.call data.home, {:drop, holospace, secret, duration}
  # end
    
  ## Callbacks
  
  # def handle_call({boot, holospace, secret, duration}, source, agent) do
#     {:reply, Agent.get(agent, &(&1)), agent}
#   end
#
#   def handle_call({meta, signal, effect}, source, agent) do
#     :ok = Agent.update agent, fn data ->
#       Data.meta(data, signal, effect)
#     end
#
#     {:reply, Agent.get(agent, &(&1)), agent}
#   end
#
#   def handle_call({lock, holospace, secret, duration}, source, agent) do
#     # TODO: globally capture this holospace as ours
#
#     {:reply, Agent.get(agent, &(&1)), agent}
#   end
#
#   def handle_call({list, holospace, secret, duration}, source, agent) do
#     data = Agent.get(agent, &(&1))
#
#     {:reply, data.thing, agent}
#   end
#
#   def handle_call({pull, holospace, secret, duration}, source, agent) do
#     :ok = Agent.update agent, fn data ->
#       data = Enum.map data.pull, fn {signal, message} ->
#         Flow.pull(data, signal)
#       end |> List.first
#     end
#
#     {:reply, Agent.get(agent, &(&1)), agent}
#   end
#
#   def handle_call({push, holospace, secret, duration}, source, agent) do
#     :ok = Agent.update agent, fn data ->
#       Enum.each data.push, fn signal ->
#         Flow.push(data, signal)
#       end
#
#       data
#     end
#
#     {:reply, Agent.get(agent, &(&1)), agent}
#   end
#
#   def handle_call({code, holospace, secret, duration}, source, agent) do
#     {:reply, Agent.get(agent, &(&1)).code, agent}
#   end
  
  def handle_call({flow, secret, duration}, source, agent) do
    # Init + Compile + Exe a full Data/Flow..
    data = Agent.get agent, &(&1)
    
    # # PULL: Data.pull things into here
    # {_, pull_list} = Enum.map_reduce data.pull, Map.new, fn {key, value}, current ->
    #   Logger.debug ">>> // #{inspect key} // #{inspect value} // #{inspect current}"
    #   case {key, value} do
    #     # put in static/atomic data via a straight data.pull -> `value`
    #     {key, value} when is_atom(key) and is_atom(value) ->
    #       {key, value}
    #
    #     # put in dynamic/holospace data via a Boot.space
    #     {key, value} when is_atom(key) or is_binary(key) ->
    #       {key, Boot.space(key)}
    #
    #     # TODO: better support here
    #     _ ->
    #       {key, Kind.drop}
    #   end
    # end
    # Logger.debug "Machine:pull_list // #{inspect pull_list}"
    #
    # # COMPUTE: exe Data.code and effects
    # Enum.map data.code, fn x ->
    #   Help.thaw(x).(data)
    # end
    #
    # # Update all nubspace that this data has just pinged
    # Enum.each data.push, fn {key, value} ->
    #   case {key, value} do
    #     # a process, so send a :data message
    #     {key, value} when is_pid(value) ->
    #       GenServer.call key, {Kind.pull, key, secret, duration}
    #
    #     {key, value} when is_atom(value) or is_binary(value) ->
    #       Flow.x(data, key, secret)
    #
    #     _ -> nil
    #   end
    # end
    # Logger.debug "Machine:push_list // #{inspect data.push}"
    #
    # # update map/space
    # :ok = Agent.update agent, fn data -> data end
      
    {:reply, data, agent}
  end
  
  # def handle_call({wait, holospace, secret, duration}, source, agent) do
  #   {:reply, Agent.get(agent, &(&1)), agent}
  # end
  #
  # def handle_call({drop, holospace, secret, duration}, source, agent) do
  #   # spawn a task and forget it
  #
  #   {:reply, Agent.get(agent, &(&1)), agent}
  # end
  
  @doc "Machine"
  def start_link(data = %Data{}) do
    # Create an Agent for our state, which also gets us
    # an extra or secondary process to do longer map updates/etc
    # outside of the Bot's own process.
    {:ok, agent} = Agent.start_link fn -> data end
    
    link = {:ok, machine} = GenServer.start_link(Machine, agent, debug: [])
    #Logger.debug "Machine.start_link #{data.keycode}"
    
    # update the data to include our Machine home
    :ok = Agent.update agent, fn data -> 
      Data.home data, machine 
    end
    
    link
  end
  def start_link(thing) do
    start_link(Data.new thing)
  end
   
end
