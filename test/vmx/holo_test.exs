defmodule Holo.Test do
  use ExUnit.Case

  test "Use `Holo.space` to get a map of everything.", do: 
    assert is_map Holo.space

  test "Use `Holo.home` to add a help message." do
    data = Data.new
    machine = Machine.boot data
         
    assert is_pid Holo.home(data, machine).home
  end

  test "Use `Holo.move` to move data to a new home.", do: 
    assert %Data{home: "machine"} = Holo.move Data.new, "machine"
  
  # test "Use `Holo.space` to put data into Holospace." do
  #   data = Holo.share Data.new
  #
  #   assert data == Holo.space(data.keycode)
  # end

  # test "Use `Holo.share` gives data.home a Machine process.",
  # do: assert is_pid Holo.share(Data.new).home
  #
  # test "Use `Holo.share` returns original data.",
  # do: assert "lol" = Holo.share "lol"

  # test "Use `Holo.share` will return most recent orbital Data" do
  #   data = Holo.share Data.new "lol"
  #
  #   Task.async fn ->
  #     Data.renew data, "grr"
  #   end
  #
  #   assert "grrr" = Data.z(data).native
  # end
  
  # test "Use `Holo.capture` returns a [list] of Items." do
  #   # create an original bot and put it to orbit
  #   original = Holo.share Data.new
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
  # test "Use `Holo.share` stores holospace: data." do
  #   assert %Data{keycode: keycode} = Holo.share "lol"
  # end

  # test "Use `Holo.feel` returns *ALL* holospace data." do
  #   key = Lovmx.keycode
  #
  #   one = Data.new("one") |> Holo.share key
  #   two = Data.new("two") |> Holo.share key
  #
  #   assert one in Holo.list(key)
  #   assert two in Holo.list(key)
  # end

  # test "Use `Holo.grab` returns *ALL* holospace data @ path" do
  #   key = Lovmx.keycode
  #   one = Data.new("one") |> Holo.share key
  #   two = Data.new("two") |> Holo.share key
  #
  #   assert ["one", "two"] = Holo.grab key, :native
  # end

end
