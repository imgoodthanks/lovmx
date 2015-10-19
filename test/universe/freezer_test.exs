defmodule Freezer.Test do
  use ExUnit.Case

  ## API

  test "Freezer.put to make an empty box w/ data" do
    box = Freezer.put "README.magic", "unknown", "test.ex"

    assert %Data{kind: "unknown", native: "test.ex", home: home} = box
    assert Regex.match? ~r/^bin/i, box.home

    assert true == File.exists? Lovmx.root Lovmx.web box.home
  end

end