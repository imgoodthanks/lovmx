defmodule Data.Test do
  use ExUnit.Case
  
  ## Examples
  
  test "Use `Data.new` to create and then `Data.renew` to update `data`", do:
		%Data{thing: "yep"} = Data.new("nada") |> Data.renew "yep"
    
  ## APIs

  test "Use `Data.new` to create new `data`.", do:
		%Data{} = Data.new
    
  test "Use `Data.renew` to add a help message.", do:
		assert %Data{thing: :reboot} = Data.renew Data.new("whoa"), :reboot
  
  test "Use `Data.home` to add a help message." do
    data = Data.new
    machine = Machine.boot data
  
    assert is_pid Data.home(data, machine).home
  end
  
  test "Use `Data.kind` to mutate the data type using custom or Kind types.", do:
		assert %Data{kind: :lols} = Data.kind Data.new, :lols
    
  test "Use `Data.help` to add a help message.", do:
		assert %Data{help: ["lol"]} = Data.help Data.new, "lol"

  test "Use `Data.meta(data, signal)` to control the data.", do:
		assert %Data{meta: %{"signal" => "lol"}} = Data.meta Data.new, "signal", "lol"

  test "Use `Data.address(data, signal)` to get a specific Data version string." do
		data = Data.new
    |> Data.tick
    
    assert Help.path [data, "#{0}"] == Data.address(data)
  end
  
  test "Use `Data.address(data, tick: previous)` to get a specific Data version string." do
		data = Data.new
    |> Data.tick
    
    assert Help.path [data, "#{0}"] == Data.address(data, tick: :back)
  end
  
  # test "Use `Data.tick` and `Data.roll` to play other versions of `data`." do
  #   first = data = Data.new("one")
  #   assert %Data{roll: []} = data
  #
  #   # bump the data
  #   data = Data.tick(data)
  #   # get the new version
  #   version = Data.address(data, tick: :back)
  #   assert version in data.roll
  #
  #   assert first = Data.roll(data, tick: :back)
  # end

  test "Use `Data.path` to pull *all* of holospace for updates to `data`.", do:
		assert is_nil Data.path Data.new, "lol"

  test "Use `Data.path` to pull *all* of holospace for updates to `data`.", do:
		assert %Data{thing: "lol"} = Data.new "lol"
    
  test "Use `Data.path` to pull *all* of holospace for updates to `data`.", do:
		assert %Data{} = Data.path "lol", Data.new

  test "Use `Data.thing` to pull *all* of holospace for updates to `data`.", do:
		assert is_nil Data.thing Data.new
          
  test "Use `Data.clone` to push *all* of holospace with updated `data`.", do:
		assert %Data{} = Data.clone Data.new

  test "Use `Data.boom` to add errors to the data.", do:
		assert %Data{} = Data.boom Data.new, "whoops"

  test "Use `Data.boom` to create *an* error data.", do:
		assert %Data{} = Data.boom "whoops"
  
  # test "Data.roll to return a previous version of Bot.",
  # do: assert %Data{} = Data.roll Data.tick(Cloud.share Data.new), 0

  # test "Data.jump(binary) to forecast future versions of Bot.",
  # do: assert "<p>@lol</p>" = Bot.jump Data.new, "related", fn x -> Cake.magic x end, fn t -> Cloud.fuzzy t.thing end

  # test "Data.stub(binary) returns Bot full of Cake.",
  # do: assert "<p>@lol</p>" = Bot.stub

  test "Use `Data.morph` to mutate data into whatever `fn` returns.", do:
		assert is_binary Data.morph Data.new, fn x -> "lol" end
  
  test "Use `Data.clone` to add boom/messages to `bot`.", do:
		assert %Data{} = Data.new |> Data.clone

  test "Data.boom(binary) returns Bot full of Cake.", do:
		assert %Data{boom: ["@yourebugged"]} = Data.boom Data.new, "@yourebugged"

end
