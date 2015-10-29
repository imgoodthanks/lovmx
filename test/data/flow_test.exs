defmodule Flow.Test do
  use ExUnit.Case

  ## Meta
  
  test "Flow.motion(data, secret) returns a %{} of all flows.", do:
		assert is_map Flow.motion("secrets")
  
  test "Flow.machine(data, secret) returns a Machine process.", do:
		assert is_pid Data.new |> Flow.boot |> Flow.machine

  ## INIT
    
  test "Flow.x(data, secret) updates a flow.", do:
		assert %Data{thing: "lol"} = Flow.x Data.new("lol")
    
  test "Flow.boot(data, secret) creates a flow.", do:
		assert is_pid Flow.boot(Data.new).home

  # test "Flow.match(match, data) will append data to the flow.", do:
  #   assert %Data{} = Flow.match Data.new, Data.new("lol")

  ## IN
    
  # test "Flow.take(data, signal) controls a flow.", do:
  #     assert %Data{thing: "whoa"} = "whoa" |> Flow.in Data.new("lol")
  #
  # test "Flow.pull(data, signal) controls a flow.", do:
  #     assert %Data{pull: %{"about" => :boot}} = Flow.pull Data.new, "about"
  #
  # test "Flow.give(data, signal) controls a flow.", do:
  #     assert %Data{pull: %{"readme" => %Data{}}} = Flow.give Data.new, Data.new, "readme"
  #
  # # test "Flow.walk(data, signal) controls a flow.",
  # # do: assert %Data{} = Flow.walk Data.new
  #
  # test "Flow.push(data, signal) controls a flow.",
  # do: assert %Data{push: %{"outside" => :push}} = Flow.push Data.new, "outside"
  #
  # test "Flow.wait(data, holospace, secret) controls a flow.", do:
  #     assert %Data{} = Flow.wait(Data.new, "/test")
  
end
