defmodule Freezer.Test do
  use ExUnit.Case

  ## API

  test "Freezer.put to make an empty box w/ data" do
    blob = Freezer.put "README.magic", "unknown", "test.ex"

    assert %Data{kind: "unknown", native: "test.ex", home: home} = blob
    assert Regex.match? ~r/^blob/i, blob.home

    assert File.exists? Help.root Help.web blob.home
  end

end