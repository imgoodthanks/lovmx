require Logger

defmodule Machine do
    
  @moduledoc """
  # Machine
  ## Machine
  ### Machine
  """
  
  use GenServer
      
  @doc "Machine"  
  def boot(data = %Data{}) do
    link = {:ok, machine} = Machine.start_link(data)
    #Logger.debug "Machine.boot // #{inspect machine} // #{inspect data}"
    
    machine
  end
  
  @doc "Restart Machine w/ new Data."
  def reboot(data = %Data{}, native) do
    # save a rollback version
    data = Data.tick(data)
    #update internal data
    data = put_in(data.native, native)

    data
  end
    
  @doc "Use `Holo.x` to `Holo.x` data in the BACKGROUND."  
  def x(data = %Data{}) do
    # refresh *all* things + re-ping machine(s)
    #Task.async fn -> Holo.share(data) end
    
    data
  end
  def compute(process) do
    GenServer.call process, {:data, nil, nil, Lovmx.tock}
  end
  def compute(native, nubspace, secret, duration) do
    native
  end
  
  ## Callbacks
  
  # Listen for replies to various signal `Kind`s. See `cake.ex` to learn more
  # about Machine Magic and how it works.
  
  def handle_call({:flow, nubspace, secret, duration}, source, agent) do
    data = Agent.get(agent, &(&1))
    
    Stream.interval(Lovmx.tock) |>  Enum.take_while fn x ->
      Machine.compute data.home
    end
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:init, nubspace, secret, duration}, source, agent) do
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:meta, signal, effect}, source, agent) do
    :ok = Agent.update agent, fn data -> 
      Data.meta(data, signal, effect)
    end
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end

  def handle_call({:list, nubspace, secret, duration}, source, agent) do
    data = Agent.get(agent, &(&1))
    
    {:reply, data.native, agent}
  end

  def handle_call({:pull, nubspace, secret, duration}, source, agent) do
    :ok = Agent.update agent, fn data -> 
      data = Enum.map data.pull, fn {signal, message} -> 
        Flow.pull(data, signal)
      end |> List.first
    end
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:code, nubspace, secret, duration}, source, agent) do
    {:reply, Agent.get(agent, &(&1)).code, agent}
  end
  
  def handle_call({:push, nubspace, secret, duration}, source, agent) do
    :ok = Agent.update agent, fn data -> 
      Enum.each data.push, fn signal -> 
        Flow.push(data, signal)
      end
      
      data
    end
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:stub, nubspace, secret, duration}, source, agent) do
    {:reply, Agent.get(agent, &(&1)), agent}
  end
      
  def handle_call({:data, nubspace, secret, duration}, source, agent) do
    # Init + Compile + Exe a full Data/Flow..
    # pull our data
    data = Agent.get(agent, &(&1))
    
    # pull data in...
    unless %{} == data.pull do
      data = (Enum.map data.pull, fn {key, value} ->
        case key do
          # put in static/atomic data via a straight data.pull -> `value`
          key when is_atom(key)    -> data = put_in data.pull, value
          # put in dynamic/nubspace data via a Machine.data
          key when is_binary(key)  -> data = put_in data.pull, Map.put(data.pull, key, "#todo")
        end
      end) |> List.first
    end
    #Logger.debug "... // #{inspect data}"

    # ...exe code/effects...
    Enum.map data.code, fn x ->
      Lovmx.thaw(x).(data)
    end
    #Logger.debug "... // #{inspect data}"
    #Machine.compute(data)
    
    # ...push data out.
    Enum.map data.push, fn {key, value} ->
      put_in data.push, Map.put(data.push, key, Data.push)
    end
    
    # update the data.kind from :init (do something) to :flow (wait or stream)
    #data = Flow.meta data, Data.flow
    
    # update map/space
    :ok = Agent.update agent, fn data -> data end
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  def handle_call({:stop, nubspace, secret, duration}, source, agent) do
    # spawn a task and forget it
    
    {:reply, Agent.get(agent, &(&1)), agent}
  end
    
  @doc "Machine"  
  def start_link(data = %Data{}) do
    # Create an Agent for our state, which also gets us
    # an extra or secondary process to do longer map updates/etc
    # outside of the Bot's own process.
    {:ok, agent} = Agent.start_link fn -> data end
    
    link = {:ok, machine} = GenServer.start_link(Machine, agent, debug: [:trace])
    #Logger.debug "Machine.start_link #{data.keycode}"
    
    link
  end
  def start_link(native) do
    start_link(Data.new native)
  end
   
end
