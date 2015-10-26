defmodule Cloud.Test do
  use ExUnit.Case

  test "Use `Cloud.space` to get a map of everything.", do: 
    assert is_map Cloud.space

  # test "Use `Cloud.space` to get specific maps of <holospace>.", do:
  #   assert is_list Cloud.space "lol"
      
  test "Use `Cloud.space` to map or drop everything at <holospace>." do
    data = Cloud.share Data.new, "whoa"
    assert data = Cloud.space "whoa"
  end
  
  test "Use `Cloud.list` to get a list of everything.", do: 
    assert is_list Cloud.list
    
  test "Use `Cloud.home` to add a help message." do
    data = Data.new
    machine = Machine.boot data
    
    assert is_pid Cloud.home(data, machine).home
  end
    
  test "Use `Cloud.move` to move data to a new home.", do: 
    assert %Data{home: "machine"} = Cloud.move Data.new, "machine"

  test "Use `Cloud.share <holospace>` to return holospace data." do
    key = Help.keycode

    one = "one" |> Data.new |> Cloud.share key
    assert one = Cloud.space(key)
    
    two = "two" |> Data.new |> Cloud.share key
    assert two = Cloud.space(key)
  end

  test "Use `Cloud.forget <holospace>` to forget *ALL* holospace data.", do:
    assert "nolols" == Cloud.forget("nolols", "passcode")
  
  test "Use `Cloud.get` to return a [list] of things at `holospace`.", do:
		assert is_list Cloud.get "img"

  test "Use `Cloud.read` to list directories", do:
		assert [%Data{}|_] = Cloud.read Help.web "img"

  test "Use `Cloud.save` to create files at `path`." do
    data = Cloud.save Data.new("machine")

    # check botpath
    webpath = Help.root Help.web Data.address(data)

    assert File.exists?(webpath) and File.dir?(webpath)
    assert File.exists? Path.join [webpath, "#{Kind.boot}"]
    #assert true == File.exists? Path.join [webpath, "term"]
    #assert true == File.exists? Path.join [webpath, "text"]
    #assert true == File.exists? Path.join [botpath, "json"]
    #assert true == File.exists? Path.join [botpath, "html"]
  end

  test "Use `Cloud.write` to create files at `path`." do
    Cloud.write "lol", "test"
  
    assert File.exists? Help.root Help.web "test"
  end
    
end
