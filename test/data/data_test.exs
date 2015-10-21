defmodule Data.Test do
  use ExUnit.Case
  
  ## Examples
  
  test "Use `Data.new` to create and then `Data.renew` to update `data`",
  do: %Data{native: "lol", roll: [%Data{native: nil}]} = Data.new |> Data.renew "lol"
    
  ## APIs

  test "Use `Data.new` to create new `data`.",
  do: %Data{} = Data.new
    
  test "Use `Data.renew` to add a help message.",
  do: assert %Data{native: :reboot} = Data.renew Data.new("whoa"), :reboot
        
  test "Use `Data.kind` to mutate the data type using custom or Kind types.",
  do: assert %Data{kind: :lols} = Data.kind Data.new, :lols
    
  test "Use `Data.help` to add a help message.",
  do: assert %Data{help: ["lol"]} = Data.help Data.new, "lol"

  test "Use `Data.meta(data, signal)` to control the data.",
  do: assert %Data{meta: %{"signal" => "lol"}} = Data.meta Data.new, "signal", "lol"

  test "Use `Data.tick` to pull *all* of nubspace for updates to `data`.",
  do: assert %Data{} = Data.tick Data.new

  test "Use `Data.path` to pull *all* of nubspace for updates to `data`.",
  do: assert is_nil Data.path Data.new, "lol"

  test "Use `Data.path` to pull *all* of nubspace for updates to `data`.",
  do: assert %Data{native: "lol"} = Data.new "lol"
    
  test "Use `Data.path` to pull *all* of nubspace for updates to `data`.",
  do: assert %Data{} = Data.path "lol", Data.new

  test "Use `Data.native` to pull *all* of nubspace for updates to `data`.",
  do: assert is_nil Data.native Data.new
          
  test "Use `Data.clone` to push *all* of nubspace with updated `data`.",
  do: assert %Data{} = Data.clone Data.new

  test "Use `Data.bugs` to add errors to the data.",
  do: assert %Data{} = Data.bugs Data.new, "whoops"

  test "Use `Data.error` to create *an* error data.",
  do: assert %Data{} = Data.error "whoops"
  
  # test "Data.roll to return a previous version of Bot.",
  # do: assert %Data{} = Data.roll Data.tick(Holo.share Data.new), 0

  # test "Data.jump(binary) to forecast future versions of Bot.",
  # do: assert "<p>@lol</p>" = Bot.jump Data.new, "related", fn x -> Cake.magic x end, fn t -> Holo.fuzzy t.native end

  # test "Data.stub(binary) returns Bot full of Cake.",
  # do: assert "<p>@lol</p>" = Bot.stub

  test "Use `Data.morph` to mutate data into whatever `fn` returns.",
  do: assert is_binary Data.morph Data.new, fn x -> "lol" end
  
  test "Use `Data.clone` to add bugs/messages to `bot`.",
  do: assert %Data{} = Data.new |> Data.clone

  test "Data.bugs(binary) returns Bot full of Cake.",
  do: assert %Data{bugs: ["@yourebugged"]} = Data.bugs Data.new, "@yourebugged"

end
