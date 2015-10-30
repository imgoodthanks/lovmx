defmodule Holo.Test do
  use ExUnit.Case

  test "Use `Holo.map` to get a map of everything.", do:
    assert is_map Holo.map

  test "Use `Holo.boost <data>` and `Holo.space <holospace>` to set/get holospace Data." do
    key = Help.keycode

    one = "one" |> Data.new |> Holo.boost key
    assert [one] = Holo.space(key)

    two = "two" |> Data.new |> Holo.boost key
    assert [one, two] = Holo.space(key)
  end
  
end
