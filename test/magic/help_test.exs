defmodule Help.Test do
  use ExUnit.Case
  
  # test "Use `Data.help` to add a help to the Hello World ",
  # do: assert Regex.match? ~r/magic/i, inspect Help.help
  
  # test "Does cool stuff",
  # do: assert %Data{} = "#yolo" |> new |> Data.code(fn data -> Data.renew data, Cake.magic(data.thing) end) |> boot |> compute
  #
  ## Boring API

  test "generic", do: assert Help.generic

  test "tick",    do: assert Help.tick > 0
  test "tock",    do: assert Help.tock > Help.tick
  test "long",    do: assert Help.long > Help.tock

  test "keycode for UUIDs", do:
		assert Regex.match? Help.keycode_regex, Help.keycode
  
  test "root", do:
		assert is_binary Help.root("README.magic")

  test "path [list]", do:
		assert is_binary Help.path ["silly", "rabbit"]

  test "path? is_binary", do:
		assert Help.path? "/nub"

  test "is_path is_binary in", do:
		assert Help.tock > 0

  test "is_path in", do:
		assert not Help.is_path ".."

  test "is_path", do:
		assert Help.is_path "/nub"

  test "freeze is_binary", do:
		assert is_binary Help.freeze %{}

  test "thaw is_function", do:
		assert is_function Help.thaw(Help.freeze fn -> "lol" end)

  
end