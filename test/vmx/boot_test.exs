defmodule Boot.Test do
  use ExUnit.Case

  test "Use `Boot.space` to get a map of everything.", do: 
    assert is_map Boot.space

  # test "Use `Boot.space` to get specific maps of <holospace>.", do:
  #   assert is_list Boot.space "lol"
      
  test "Use `Boot.space` to map or drop everything at <holospace>." do
    data = Boot.share Data.new, "whoa"
    assert data = Boot.space "whoa"
  end
  
  test "Use `Boot.list` to get a list of everything.", do: 
    assert is_list Boot.list
    
  test "Use `Boot.home` to add a help message." do
    data = Data.new
    machine = Machine.boot data
    
    assert is_pid Boot.home(data, machine).home
  end
    
  test "Use `Boot.move` to move data to a new home.", do: 
    assert %Data{home: "machine"} = Boot.move Data.new, "machine"

  test "Use `Boot.share <holospace>` to return holospace data." do
    key = Help.keycode

    one = "one" |> Data.new |> Boot.share key
    assert one = Boot.space(key)
    
    two = "two" |> Data.new |> Boot.share key
    assert two = Boot.space(key)
  end

  test "Use `Boot.forget <holospace>` to forget *ALL* holospace data.", do:
    assert "nolols" == Boot.forget("nolols", "passcode")
      
end
