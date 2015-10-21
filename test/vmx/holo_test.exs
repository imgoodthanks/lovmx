defmodule Holo.Test do
  use ExUnit.Case

  test "Use `Holo.space` to get a map of everything.",
  do: assert is_map Holo.space

  test "Use `Holo.home` to add a help message." do
    data = Data.new
    machine = Machine.boot data
         
    assert is_pid Holo.home(data, machine).home
  end

  test "Use `Holo.move` to move data to a new home.",
  do: assert %Data{home: "machine"} = Holo.move Data.new, "machine"
  
  # test "Use `Holo.orbit` to put data into Nubspace." do
#     data = Holo.orbit Data.new
#     assert data == Holo.data(data.keycode)
#   end
#
  # test "Use `Holo.orbit` gives data.home a Machine process.",
  # do: assert is_pid Holo.orbit(Data.new).home
  #
  # test "Use `Holo.orbit` returns original data.",
  # do: assert "lol" = Holo.orbit "lol"

  # test "Use `Holo.orbit` will return most recent orbital Data" do
  #   data = Holo.orbit Data.new "lol"
  #
  #   Task.async fn ->
  #     Data.renew data, "grr"
  #   end
  #
  #   assert "grrr" = Data.z(data).native
  # end
  
  # test "Use `Holo.capture` returns a [list] of Items." do
  #   # create an original bot and put it to orbit
  #   original = Holo.orbit Data.new
  #
  #   # assert that it installed...
  #   assert Map.has_key? Holo.space, original.keycode
  #
  #   # assert that trying to orbit anything else raises..
  #   assert %Data{bugs: [_bug]} = Holo.capture Data.new, original.keycode
  # end
  #
  # test "Use `Holo.noop` to log a noop on the object. Helps accounting do their job.",
  # do: assert %Data{} = Holo.noop Data.new
  #
  # test "Use `Cake.mix` to run files on the Freezer.",
  # do: assert %Data{} = Cake.mix "EXAMPLE.exs"
  #

  #
  # test "Use `Holo.orbit` stores nubspace: data." do
  #   assert %Data{keycode: keycode} = Holo.orbit "lol"
  # end

  # test "Use `Holo.data` returns *ALL* nubspace data." do
  #   key = Lovmx.keycode
  #
  #   one = Data.new("one") |> Holo.orbit key
  #   two = Data.new("two") |> Holo.orbit key
  #
  #   assert one in Holo.list(key)
  #   assert two in Holo.list(key)
  # end

  # test "Use `Holo.grab` returns *ALL* nubspace data @ path" do
  #   key = Lovmx.keycode
  #   one = Data.new("one") |> Holo.orbit key
  #   two = Data.new("two") |> Holo.orbit key
  #
  #   assert ["one", "two"] = Holo.grab key, :native
  # end

end
