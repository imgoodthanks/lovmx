require Logger

defmodule Flow do
  
  @moduledoc """
  # Flow
  ## Real-time Map of Active/Unique Data in Motion.
  
  A data flow is the basic layout of an `application` or are the 
  Modules you need to define and respond to the various other 
  Data/Flow signal types, stacking and plugging your modules into 
  all the available framework out. 
  
  For example a Bot produces something that Flows into a Pipe and
  out to the Universe and Multiverse modules that people see and use.
  """
  
  use GenServer
  
  ## META
  
  @doc "Use `Flow.out` to return all Data flows."
  def out(secret \\ nil) do
    GenServer.call FlowServer, {Kind.data, secret}
  end
  
  # INIT
  
  @doc "Put `data` into the Universal Flow."
  def beam(data = %Data{}, secret \\ nil, duration \\ Help.long) do
    #GenServer.call FlowServer, {Kind.push, data, nil, secret, duration}
    match(%Data{}, data, secret, duration)
  end

  @doc "Put `thing` in the Universal Flow to capture beam(s)."
  def match(thing, data, secret \\ nil, duration \\ Help.long)

  def match(things, data = %Data{}, secret, duration) when is_list(things) do
    Enum.map things, fn thing ->
      match(thing, data, secret, duration)
    end
  end

  def match(match = %Data{}, data = %Data{}, secret, duration) do
    GenServer.call FlowServer, {Kind.code, match, data, secret, duration}
  end

  @doc "Upgrade Data in the Universal Flow w/ optional new data."
  def upgrade(data = %Data{}, secret \\ nil, duration \\ Help.long) do
    # Task.async(fn ->
    #   match(%Data{}, data, secret, duration)
    # end)
    
    data
  end

  @doc "Upgrade data in the background."
  def x(thing, secret \\ nil, duration \\ Help.long)

  def x(data = %Data{}, secret, duration) do
    Task.async fn ->
      upgrade(data, secret, duration)
    end

    data
  end
  def x(other, secret, duration) do
    other
  end

  @doc "From `data` *to* `holospace`."
  def push(data = %Data{}, holospace \\ nil, secret \\ nil, duration \\ Help.long) do
    GenServer.call FlowServer, {Kind.push, data, holospace, secret, duration}
  end

  @doc "Map `holospace` *INTO* `data.pull`."
  def pull(data = %Data{}, holospace, secret \\ nil, duration \\ Help.long) when is_atom(holospace) or is_binary(holospace) do
    GenServer.call FlowServer, {Kind.pull, data, holospace, secret, duration}
  end

  @doc "Put `thing` *INTO* `data.pull`.`<signal>`."
  def feed(thing, data, signal, secret \\ nil)

  def feed(thing, data = %Data{}, signal, secret) when is_atom(signal) or is_binary(signal) do
    GenServer.call FlowServer, {Kind.meta, :feed, data, thing, signal, secret}
  end
  
  def feed(thing, things, signal, secret) when is_list(things) and is_atom(signal) or is_binary(signal) do
    Enum.map things, fn data -> feed thing, data, signal, secret end 
  end

  @doc "Collect Data through all Data Flows."
  def graph(thing, secret \\ nil, duration \\ Help.tock)

  def graph(data = %Data{}, secret, duration) do
    GenServer.call FlowServer, {Kind.flow, data, secret, duration}
  end
  def graph(things, secret, duration) do
    Enum.map things, fn data ->
      graph(data, secret, duration)
    end
  end
    
  ## CALLBACKS
  
  # return *all* active %{data => flow} sessions.
  def handle_call({:data, secret}, source, agent) do
    #todo: support secret/access/codes

    {:reply, Agent.get(agent, &(&1)), agent}
  end
  
  # put `thing` into `data` and return fresh data.
  def handle_call({:meta, :feed, data = %Data{}, thing, signal, secret}, source, agent) do
    data = home_check(data)
    
    # put the data/bot into the flow
    # update map/match -> match/data
    :ok = Agent.update data.home, fn x ->
      put_in(data.pull, Map.update(data.pull, Kind.data, [thing], fn take ->
        take
        |> Enum.concat([thing])
        |> List.flatten
        |> List.wrap
      end))
    end

    {:reply, Agent.get(data.home, &(&1)), agent}
  end
  
  # return *all* active %{data => flow} sessions.
  def handle_call({:code, match = %Data{}, data = %Data{}, secret, duration}, source, agent) do
    #todo: support secret/access/codes

    # ensure a beam
    data = home_check(data)

    #put the data/bot into the flow
    fresh = Map.put(Map.new, match, [data])

    :ok = Agent.update agent, fn map ->
      # update the system map
      Map.update map, Kind.code, fresh, fn x ->
        Map.merge x, Map.put(Map.new, match, List.flatten [Map.get(x, match), data])
      end
    end

    data = Agent.get(data.home, &(&1))

    {:reply, data, agent}
  end
  def handle_call({:code, match = %Data{}, thing, secret, duration}, source, agent) do
    handle_call({:code, match, Data.new(thing), secret, duration}, source, agent)
  end
  
  def handle_call({:push, data = %Data{home: home}, holospace, secret, duration}, source, agent) when is_pid(home) do
    :ok = Agent.update data.home, fn latest ->
      # update the system map
      put_in latest.push, Map.merge(latest.push, Map.put(Map.new, holospace, List.flatten [Map.get(latest.push, holospace), Kind.push]))
    end
    
    #todo: support secret/access/codes
    {:reply, Agent.get(data.home, &(&1)), agent}
  end
  
  # return a specific data flow
  def handle_call({:pull, data = %Data{home: home}, holospace, secret, duration}, source, agent) when is_pid(home) do
    :ok = Agent.update data.home, fn latest ->
      # update the system map
      put_in latest.pull, Map.merge(latest.pull, Map.put(Map.new, holospace, List.flatten [Map.get(latest.pull, holospace), Kind.pull]))
    end
    
    #todo: support secret/access/codes
    {:reply, Agent.get(data.home, &(&1)), agent}
  end
  def handle_call({:pull, data = %Data{}, holospace, secret, duration}, source, agent) do
    #todo: support secret/access/codes
    {:reply, data, agent}
  end
  
  # return a specific data flow
  # exe all data.things from the Univeral Flow of `data.code` segments
  def handle_call({:flow, data = %Data{}, secret, duration}, source, agent) do
    map = Agent.get(agent, &(&1))
    data = home_check(data)

    # walk the Flow.out.code space.
    data = Enum.reduce map, data, fn {code, codemap}, data ->
      #Logger.warn ">>> Flow:code #data  #{inspect data}"
      #Logger.warn ">>> Flow:code #code  #{inspect code}"
      #Logger.warn ">>> Flow:code #codemap  #{inspect codemap}"
      
      # returning a %{match => [list]} of things
      data = Enum.reduce codemap, data, fn {match, things}, data ->
        #Logger.warn ">>> Flow:code #match #{inspect match}"
        #Logger.warn ">>> Flow:code #things  #{inspect things}"
        
        # when match is true, walk the data.code.<match>.[list] or steps for thing.code
        if match == data do
          #Logger.warn ">>> Flow:code #match  #{inspect match.code}"
          
          # loop the signal/match things
          Enum.each things, fn thing ->
            # update the data.pull material for each codespace match/thing w/ thing
            :ok = Agent.update data.home, fn latest ->
              #Logger.warn ">>> Flow:code #latest  #{inspect latest.code}"
          
              data = put_in(latest.pull, Map.merge(latest.pull, Map.put(Map.new, match, things)))
            end
            
            # iterate each code block for each thing
            Enum.each thing.code, fn code ->
              #iterate each of the thing's code steps
              Logger.info "Flow.code.(data) // #{inspect thing.code}"
              
              Task.async fn -> upgrade(code.(data), secret, duration) end
            end
          end

          data = data |> x(secret, duration)
        end

        data = data |> x(secret, duration)
      end

      data = data |> x(secret, duration)
    end

    # refresh
    data = Agent.get(data.home, &(&1))
    #Logger.warn ">>> Flow:code #data  #{inspect data.code}"
    #Logger.warn ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

    # walk the data code steps
    data = Enum.reduce data.code, data, fn code, data ->
      :ok = Agent.update data.home, fn internal ->
        data = Help.thaw(code).(data)
      end

      data
    end

    # return the data
    {:reply, data, agent}
  end
  def handle_call({:flow, data = %Data{}, secret, duration}, source, agent) do
    # noop

    {:reply, data, agent}
  end
  
  # start the named FlowServer process.
  def start_link(_) do
    # An agent that we'll eventually pass around to *all* the Flow servers...
    link = {:ok, agent} = Agent.start_link(fn -> Map.new end)
    
    # Keep the map in memory for fluffiness.
    link = {:ok, holo} = GenServer.start_link(Flow, agent, name: FlowServer, debug: [])
    Logger.info "Flow.start_link #{inspect link}"
    
    link
  end
  
  # create an agent to put in data.home if necessary
  defp home_check(data) do
    # put the bot into the data
    unless is_pid(data.home) do
      {:ok, home} = Agent.start_link fn -> data end
      
      data = Data.home(data, home)
      
      # put the data in an agent for an easy api
      # put the data/bot into the flow
      # update map/match -> match/data
      :ok = Agent.update data.home, fn _ -> data end
    end
    
    # pull fresh data
    data = Agent.get(data.home, &(&1))
  end
  
end
