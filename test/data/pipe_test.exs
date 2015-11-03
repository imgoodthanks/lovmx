require Logger

defmodule Pipe.Test do
  use ExUnit.Case

  ## Data
  
  test "Pipe.magic creates a page from %Data{}", do:
		assert is_binary Pipe.page Data.new("# yo")
    
    
  test "Pipe.page creates a page from %Data{}", do:
		assert is_binary Pipe.page ["lol", "nub"]
    
  test "Pipe.page creates a page from %Data{} at `holospace`", do:
		assert is_binary Pipe.page Data.new

  test "Pipe.page creates a page from [list]", do:
    assert is_binary Pipe.page ["lol", "nub"]

  test "Pipe.page creates a page from []", do:
    assert is_binary Pipe.page []

  test "Pipe.page creates a page", do:
    assert is_binary Pipe.page

  test "Pipe.page creates a page from a Map %{}", do:
    assert is_binary Pipe.page Map.new

  test "Pipe.page creates a page from binary", do:
    assert is_binary Pipe.page "lol"

  test "Pipe.page creates a page from any `thing`", do:
    assert is_binary Pipe.page HashDict.new


  test "Pipe.html returns HTML from [list]", do:
    assert is_binary Pipe.html Data.new

  test "Pipe.html returns HTML from [list]", do:
    assert is_binary Pipe.html Data.new(nil, Kind.link), "about"
    
  test "Pipe.html returns HTML from [list]", do:
    assert is_binary Pipe.html ["lol", "nub"]

  test "Pipe.html returns HTML from [list]", do:
		assert is_binary Pipe.html ["lol", "nub"]

  test "Pipe.html returns HTML from Bot", do:
		assert is_binary Pipe.html Data.new "ok"

  test "Pipe.html returns HTML from binary", do:
		assert is_binary Pipe.html "lol"

  test "Pipe.html returns HTML from a PID", do:
		assert is_binary Pipe.html self


  test "Pipe.down returns HTML from binary", do:
		assert is_binary Pipe.down "lol"


  test "Pipe.json returns JSON from lists", do:
		assert is_binary Pipe.json [Data.new]

  test "Pipe.json returns JSON for `thing`", do:
    assert is_binary Pipe.json HashDict.new


  test "Pipe.text returns text for empty list", do:
		assert is_binary Pipe.text []

  test "Pipe.text returns text for [data]", do:
    assert is_binary Pipe.text [Data.new]

  test "Pipe.text returns text for Data links", do:
    assert is_binary Pipe.text Data.new(nil, Kind.link)

  test "Pipe.text returns text for Data", do:
    assert is_binary Pipe.text Flow.boot Data.new

  test "Pipe.text returns text for binary", do:
    assert is_binary Pipe.text "lol"

  test "Pipe.text returns text for atoms", do:
    assert is_binary Pipe.text :lol

  test "Pipe.text returns text", do:
    assert is_binary Pipe.text HashDict.new

                      
  test "Pipe.drop(data, signal) controls a flow.", do:
		assert is_nil Pipe.drop Data.new

    
  test "Pipe.debug returns text", do:
		assert is_binary Pipe.text Data.new
    
end
