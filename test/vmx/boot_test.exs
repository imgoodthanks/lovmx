defmodule Boot.Test do
  use ExUnit.Case

  test "Use `Boot.graph` to get a map of everything.", do: 
    assert is_map Boot.graph
      
  test "Use `Boot.space` to map or drop everything at <holospace>." do
    data = %Data{} = Boot.boost Data.new, "whoa"
    
    assert data.home in Boot.space "whoa"
  end
  
  test "Use `Boot.list` to get a list of everything.", do: 
    assert is_list Boot.list
        
  test "Use `Boot.move` to move data to a new home.", do: 
    assert %Data{home: "machine"} = Boot.move Data.new, "machine"

  test "Use `Boot.boost <holospace>` to return holospace data." do
    key = Help.keycode

    one = "one" |> Data.new |> Boot.boost key
    assert [one] = Boot.space(key)
    
    two = "two" |> Data.new |> Boot.boost key
    assert [one, two] = Boot.space(key)
  end

  test "Use `Boot.forget <holospace>` to forget *ALL* holospace data.", do:
    assert "nolols" == Boot.forget("nolols", "passcode")
      
end
