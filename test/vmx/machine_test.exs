defmodule Machine.Test do
  use ExUnit.Case

  test "Use `Machine.boot` to give data.home a Machine process.", do: 
    assert is_pid Machine.boot Data.new
  
  test "Use `Machine.compute` to give data.home a Machine process.", do: 
    assert %Data{} = Machine.compute Machine.boot Data.new
  #
  # test "Use `Machine.compute <machine>, <secret>, <duration>` to compute / data from <holospace>.", do:
  #   assert %Data{} = Machine.compute Machine.boot Data.new

  test "`Machine.compute nil` will return nil.", do: 
    assert is_nil Machine.compute nil

end
