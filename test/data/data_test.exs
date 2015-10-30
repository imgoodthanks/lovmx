defmodule Data.Test do
  use ExUnit.Case
  
  ## APIs

  test "Use `Data.new` to create new `data`.", do:
		%Data{} = Data.new
      
  # test "Use `Data.home <bot>` to move data to a new process." do
  #   data = Data.new
  #   {:ok, bot} = Bot.start_link data
  #
  #   assert is_pid Data.home(data, bot).home
  # end
  
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
  
  test "Use `Data.tick` and `Data.roll` to play other versions of `data`." do
    first = data = Data.new("one")
    assert %Data{roll: []} = data

    # bump the data
    data = Data.tick(data)
    # get the new version
    version = Data.address(data, tick: :back)
    assert version in data.roll
    
    #todo: assert Data.roll(Data.tick(data), tick: :back)
  end

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
  
  # test "Data.roll to return a previous version of Data.",
  # do: assert %Data{} = Data.roll Data.tick(Holo.boost Data.new), 0

  # test "Data.jump(binary) to forecast future versions of Data.",
  # do: assert "<h1>lol</h1>\n" = Data.jump Data.new, "related", fn x -> Cake.magic("# lol") end, fn t -> t.kind == :cake end

  test "Use `Data.morph` to mutate data into whatever `fn` returns.", do:
		assert is_binary Data.morph Data.new, fn x -> "lol" end
  
  test "Use `Data.clone` to add boom/messages to `data`.", do:
		assert %Data{} = Data.new |> Data.clone

  test "Data.boom(binary) returns Data full of Cake.", do:
		assert %Data{boom: ["@yourebugged"]} = Data.boom Data.new, "@yourebugged"

end
