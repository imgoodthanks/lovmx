defmodule Drive.Test do
  use ExUnit.Case

  ## General
  
  test "Use `Drive.list` to list directories", do:
		assert [%Data{}|_] = Drive.list "img"

  test "Use `Drive.read` to read blobs", do:
		assert is_binary Drive.read("example.exs")
    
  test "Use `Drive.save` to create files at `path`." do
    data = Drive.save Data.new("bot")

    # check botpath
    webpath = Help.root Help.web Data.address(data)

    assert File.exists?(webpath) and File.dir?(webpath)
    assert File.exists? Path.join [webpath, "#{Kind.boot}"]
    #assert true == File.exists? Path.join [webpath, "term"]
    #assert true == File.exists? Path.join [webpath, "text"]
    #assert true == File.exists? Path.join [botpath, "json"]
    #assert true == File.exists? Path.join [botpath, "html"]
  end

  test "Use `Drive.write` to create files at `path`." do
    Drive.write "lol", "test"
  
    assert File.exists? Help.root Help.web "test"
  end
  
end