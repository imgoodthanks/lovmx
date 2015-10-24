defmodule Flow.Test do
  use ExUnit.Case

  ## Flow Controls (aka poor man's state machine)

  test "Flow.into(data, signal) controls a flow.", do:
		assert %Data{thing: "whoa"} = "whoa" |> Flow.into Data.new("lol")

  test "Flow.pull(data, signal) controls a flow.", do:
		assert %Data{pull: %{"about" => :boot}} = Flow.pull Data.new, "about"
  
  test "Flow.take(data, signal) controls a flow.", do:
		assert %Data{pull: %{"readme" => %Data{}}} = Flow.take Data.new, Data.new, "readme"
  
  # test "Flow.walk(data, signal) controls a flow.",
  # do: assert %Data{} = Flow.walk Data.new
  
  test "Flow.push(data, signal) controls a flow.",
  do: assert %Data{push: %{"outside" => :push}} = Flow.push Data.new, "outside"
  
  # test "Flow.wait(data, holospace, secret) controls a flow.", do:
  #     assert %Data{} = Flow.wait(Data.new, "/test")

end
