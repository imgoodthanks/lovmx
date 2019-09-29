require Logger

defmodule Flow.Test do
  use ExUnit.Case
  
  ## Meta
  
  test "Flow.out(data, secret) returns a %{} of all flows.", do:
	assert is_map Flow.out("secrets")
  
  ## INIT
  
  test "Flow.beam(data, secret) creates an agent-backed data flow.", do:
    assert is_pid Flow.beam(Data.new).home

  test "Flow.match(match, thing) controls a flow." do
    data = Data.new "lol"

    assert %Data{pull: %{}} = Flow.match %Data{}, data
  end

  test "Flow.upgrade(data, secret) updates `data`" do
    assert data = %Data{thing: "yada"} = Data.new("yada")

    assert %Data{thing: "nada"} = Flow.upgrade put_in data.thing, "nada"
  end
  
  test "Flow.x(data, secret) updates a flow." do
    assert data = %Data{thing: "yada"} = Data.new("yada") |> Flow.x
  end

  test "Flow.push(data, signal) controls a flow.", do:
    assert :push in (Data.new |> Flow.beam |> Flow.push("about")).push["about"]

  test "Flow.pull(data, signal) controls a flow.", do:
    assert :pull in (Data.new |> Flow.beam |> Flow.pull("about")).pull["about"]
    
  test "Flow.feed(data, signal) controls a flow.", do:
    assert :pull in (Data.new |> Flow.beam |> Flow.pull("lol")).pull["lol"]

  test "Flow.graph(data, signal) controls a flow.", do:
    assert %Data{} = Data.new |> Flow.beam |> Flow.pull("about")

end
