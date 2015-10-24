defmodule Holo.Test do
  use ExUnit.Case

  test "Use `Holo.space` to get a map of everything.", do: 
    assert is_map Holo.space

  # test "Use `Holo.space` to get specific maps of <holospace>.", do:
  #   assert is_list Holo.space "lol"
      
  test "Use `Holo.space` to map or drop everything at <holospace>." do
    data = Holo.share Data.new, "whoa"
    assert data = Holo.space "whoa"
  end
  
  test "Use `Holo.list` to get a list of everything.", do: 
    assert is_list Holo.list
    
  test "Use `Holo.home` to add a help message." do
    data = Data.new
    machine = Machine.boot data
    
    assert is_pid Holo.home(data, machine).home
  end
    
  test "Use `Holo.move` to move data to a new home.", do: 
    assert %Data{home: "machine"} = Holo.move Data.new, "machine"

  test "Use `Holo.share <holospace>` to return holospace data." do
    key = Help.keycode

    one = "one" |> Data.new |> Holo.share key
    assert one = Holo.space(key)
    
    two = "two" |> Data.new |> Holo.share key
    assert two = Holo.space(key)
  end

  test "Use `Holo.forget <holospace>` to forget *ALL* holospace data.", do:
    assert "nolols" == Holo.forget("nolols", "passcode")
  
end
