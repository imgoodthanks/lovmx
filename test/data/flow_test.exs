defmodule Flow.Test do
  use ExUnit.Case
  
  ## EXAMPLE
  
  # test "Flow does cool stuff." do
  #   # setup our data route
  #   %Data{thing: "/"}
  #   |> Flow.match Bot.code(fn data ->
  #     "index.html"
  #     |> Help.web
  #     |> Drive.read
  #     |> Pipe.page
  #     |> Flow.upgrade
  #   end)
  #
  #   # graph the route
  #   data = %Data{} = Flow.graph("/")
  #
  #   # we got the web page from the flow
  #   assert Regex.match? ~r/html/i, data.thing
  # end
  
  ## Meta
  
  test "Flow.motion(data, secret) returns a %{} of all flows.", do:
		assert is_map Flow.motion("secrets")
  
  test "Flow.grab(data, secret) returns a Bot process.", do:
      assert is_pid (Data.new |> Flow.boot).home

  ## INIT
    
  test "Flow.x(data, secret) updates a flow.", do:
		assert %Data{thing: "lol"} = Flow.x Data.new("lol")
    
  test "Flow.boot(data, secret) creates a flow.", do:
		assert is_pid Flow.boot(Data.new).home
  
  test "Use `Data.new` to create and then `Flow.upgrade` to update `data`", do:
    assert %Data{thing: "yep"} = Data.new("nada") |> Flow.upgrade "yep"
      
  ## Graph
    
  test "Flow.match(match, data) will append data to the flow." do
    assert %Data{thing: "lol"} = Flow.match Data.new("lol"), Data.new("whoa")
  end

  test "Flow.graph(data, secret) will collect data from *m* flows." do
    thing = Data.new("whoa")
    
    Flow.match %Data{thing: "test"}, thing

    flow = Flow.graph(Data.new "test")
    
    assert thing in flow.pull.graph
  end
  
  ## IN

  test "Flow.take(data, signal) controls a flow.", do:
    assert %Data{thing: "whoa"} = Flow.take Data.new("lol"), "whoa"

  test "Flow.feed(data, signal) controls a flow.", do:
    assert %Data{pull: %{"readme" => [%Data{thing: "lol"}]}} = Flow.feed Data.new("lol"), Data.new, "readme"
  
  test "Flow.pull(data, signal) controls a flow.", do:
    assert %Data{pull: %{"about" => :boot}} = Data.new |> Flow.boot |> Flow.pull("about")
  
  # # test "Flow.walk(data, signal) controls a flow.",
  # # do: assert %Data{} = Flow.walk Data.new
  
  ## OUT
  
  test "Flow.push(data, signal) controls a flow.", do: 
    assert %Data{push: %{"outside" => :push}} = Flow.push Data.new, "outside"

  test "Flow.wait(data, holospace, secret) controls a flow.", do:
    assert %Data{push: %{"test" => :wait}} = Flow.wait(Data.new, "test")
  
end
