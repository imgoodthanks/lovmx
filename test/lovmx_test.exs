defmodule Lovmx.Test do
  use ExUnit.Case

  ## Bring in the Power.
  
  use Magic
  
  ## Examples
  
  # test "Use `Lovmx` to share code + data in Holospace." do
  #   key = Lovmx.keycode
  #   data = Data.new key
  #
  #
  #   assert is_pid Holo.home(data, machine).home
  # end
  
  test "Use Lovmx to Cake from Cake.kit.", do:
		assert is_binary "README.magic" |> Tube.read
    
  # test "Use `Data.help` to add a help to the Hello World ",
  # do: assert Regex.match? ~r/magic/i, inspect Lovmx.help
  
  # test "Does cool stuff",
  # do: assert %Data{} = "#yolo" |> new |> Bot.code(fn data -> Data.renew data, Cake.magic(data.native) end) |> boot |> compute
  #
  ## Boring API

  test "generic", do: assert Lovmx.generic

  test "tick",    do: assert Lovmx.tick > 0
  test "tock",    do: assert Lovmx.tock > Lovmx.tick
  test "long",    do: assert Lovmx.long > Lovmx.tock

  test "keycode for UUIDs", do:
		assert Regex.match? Lovmx.keycode_regex, Lovmx.keycode
  
  test "root", do:
		assert is_binary Lovmx.root("README.magic")

  test "path [list]", do:
		assert is_binary Lovmx.path ["silly", "rabbit"]

  test "path? is_binary", do:
		assert Lovmx.path? "/nub"

  test "is_path is_binary in", do:
		assert Lovmx.tock > 0

  test "is_path in", do:
		assert not Lovmx.is_path ".."

  test "is_path", do:
		assert Lovmx.is_path "/nub"

  test "freeze is_binary", do:
		assert is_binary Lovmx.freeze %{}

  test "thaw is_function", do:
		assert is_function Lovmx.thaw(Lovmx.freeze fn -> "lol" end)

end
