require Logger

defmodule Pipe.Test do
  use ExUnit.Case

  ## Data
  
  test "Pipe.page bot creates a page from [list]",
  do: assert is_binary Pipe.page ["lol", "nub"]

  test "Pipe.page bot creates a page from binary",
  do: assert is_binary Pipe.page "lol"

  test "Pipe.html bot returns HTML from [list]",
  do: assert is_binary Pipe.html ["lol", "nub"]

  test "Pipe.html bot returns HTML from Bot",
  do: assert is_binary Pipe.html Data.new "ok"

  test "Pipe.html bot returns HTML from binary",
  do: assert is_binary Pipe.html "lol"

  test "Pipe.html bot returns HTML from a PID",
  do: assert is_binary Pipe.html self

  test "Pipe.down returns HTML from binary",
  do: assert is_binary Pipe.down "lol"

  test "Pipe.json returns JSON for lists",
  do: assert is_binary Pipe.json Data.new

  test "Pipe.text bot returns text",
  do: assert is_binary Pipe.text Data.new

  test "Pipe.drop(data, signal) controls a flow.",
  do: assert is_nil Pipe.drop Data.new

  test "Pipe.debug bot returns text",
  do: assert is_binary Pipe.text Data.new
    
end
