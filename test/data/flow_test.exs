require Logger

defmodule Flow.Test do
  use ExUnit.Case
  
  ## EXAMPLE
  
  test "Flow does cool stuff." do
    # setup our data route
    %Data{thing: "/"}
    |> Flow.match Data.code(fn data ->
      "index.html"
      |> Help.web
      |> Drive.read
      |> Pipe.page
      |> Flow.feed(data, Kind.html)
    end)
    |> Flow.graph
    
    # graph the route
    data = %Data{} = Flow.graph(Data.new "/")
    #Logger.warn "Flow.Test: #{inspect data}"
  end
  
  ## Meta
  
  test "Flow.beam(data, secret) returns a %{} of all flows.", do:
		assert is_map Flow.beam("secrets")
  
  ## INIT
  
  test "Flow.x(data, secret) updates a flow.", do:
		assert %Data{thing: "lol"} = Flow.x Data.new("lol")
    
  test "Flow.boot(data, secret) creates a flow.", do:
		assert is_pid Flow.boot(Data.new).home
  
  test "Flow.upgrade updates `data`", do:
    assert %Data{thing: "yep"} = Data.new("nada") |> Flow.upgrade "yep"
  
  ## Graph
    
  test "Flow.match(match, data) will append data to the flow." do
    assert %Data{thing: "lol"} = Flow.match Data.new("lol"), Data.new("whoa")
  end

  test "Flow.graph(data, secret) will collect data from *active* flows." do
    thing = Data.new("whoa")
    
    Flow.match %Data{thing: "test"}, thing

    flow = Flow.graph(Data.new "test")
    
    assert thing in flow.pull.graph
  end
  
  test "Flow.graph(things, secret) will collect data for a list of *all* flows." do
    thing = Data.new("whoa")
    Flow.match %Data{thing: "test"}, thing

    path = Help.project "README.magic"
    file1 = Data.new("README.magic", Kind.link, %{base: Path.basename(path) , root: path})
    file2 = Data.new("README.md", Kind.link, %{base: Path.basename(path) , root: path})
    
    things = Flow.graph([file1, file2])

    assert is_list things
    assert things = [file1, file2]
    assert things = ""
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
