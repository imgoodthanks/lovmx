defmodule Tube.Test do
  use ExUnit.Case


  test "Tube.get returns a [list] of Blobs.", do:
		assert is_list Tube.get "img"

  test "Use `Tube.read` to list directories", do:
		assert [%Data{}|_] = Tube.read Lovmx.web "img"
  
  test "Use `Tube.save` to create files at `path`." do
    data = Tube.save Data.new("machine")
  
    # check botpath
    webpath = Lovmx.root Lovmx.web data.keycode
  
    assert File.exists?(webpath) and File.dir?(webpath)
    assert File.exists? Path.join [webpath, "#{Kind.boot}"]
    #assert true == File.exists? Path.join [webpath, "data"]
    #assert true == File.exists? Path.join [webpath, "text"]
    #assert true == File.exists? Path.join [botpath, "json"]
    #assert true == File.exists? Path.join [botpath, "html"]
  end

  test "Use `Tube.write` to create files at `path`." do
    Tube.write "lol", "test"
    
    assert File.exists? Lovmx.root Lovmx.web "test"
  end
  
end
