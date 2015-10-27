defmodule Machine.Test do
  use ExUnit.Case

  test "Use `Machine.boot` to give data.home a Machine process.", do:
    assert is_pid Machine.boot Data.new

  test "Use `Machine.data` to give data.home a Machine process.", do:
    assert %Data{} = Machine.data Machine.boot Data.new
  #
  # test "Use `Machine.data <machine>, <secret>, <duration>` to compute / data from <holospace>.", do:
  #   assert %Data{} = Machine.data Machine.boot Data.new

  # test "`Machine.data nil` will return nil.", do:
  #   assert is_nil Machine.data nil
  #
  # test "Use `Machine.drop` to add code and make Bot ready for work.", do:
  #   assert Machine.drop Data.new
  #
  # test "Use `Machine.boot` to add code and make Bot ready for work.", do:
  #   assert Machine.boot Data.new
  #
  # test "Use `Machine.lock` to add code and make Bot ready for work.", do:
  #   assert Machine.lock Data.new
  #
  # test "Use `Machine.meta` to add code and make Bot ready for work.", do:
  #   assert Machine.meta Data.new
  #
  # test "Use `Machine.list` to add code and make Bot ready for work.", do:
  #   assert Machine.list Data.new
  #
  # test "Use `Machine.pull` to add code and make Bot ready for work.", do:
  #   assert Machine.pull Data.new
  #
  # test "Use `Machine.pull` to add code and make Bot ready for work.", do:
  #   assert Machine.pull Data.new
  #
  # test "Use `Machine.push` to add code and make Bot ready for work.", do:
  #   assert Machine.push Data.new
  #
  # test "Use `Machine.flow` to add code and make Bot ready for work.", do:
  #   assert Machine.flow Data.new
  #
  # test "Use `Machine.wait` to add code and make Bot ready for work.", do:
  #   assert Machine.wait Data.new

end
