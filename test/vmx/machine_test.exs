# defmodule Machine.Test do
#   use ExUnit.Case
#
#   test "Use `Machine.start_link` to give data.home a Machine process.", do:
#     assert is_pid Machine.start_link Data.new
#
#   test "Use `Machine.data` to give data.home a Machine process.", do:
#     assert %Data{} = Machine.data Machine.start_link Data.new
#
#   test "Use `Machine.meta` to add code and make Bot ready for work." do
#     machine = Machine.start_link Data.new "lol"
#   end
#
#   test "Use `Machine.lock` to add code and make Bot ready for work." do
#     machine = Machine.start_link Data.new "lol"
#   end
#
#   test "Use `Machine.list` to add code and make Bot ready for work." do
#     machine = Machine.start_link Data.new "lol"
#   end
#
#   test "Use `Machine.pull` to add code and make Bot ready for work." do
#     machine = Machine.start_link Data.new "lol"
#   end
#
#   test "Use `Machine.pull` to add code and make Bot ready for work." do
#     machine = Machine.start_link Data.new "lol"
#   end
#
#   test "Use `Machine.push` to add code and make Bot ready for work." do
#     machine = Machine.start_link Data.new "lol"
#   end
#
#   test "Use `Machine.flow` to add code and make Bot ready for work." do
#     machine = Machine.start_link Data.new "lol"
#   end
#
#   # test "Use `Machine.wait` to add code and make Bot ready for work." do
#   #
#   # end
#
#   # test "Use `Machine.drop` to add code and make Bot ready for work." do
#   #   machine = Task.async(fn ->
#   #     machine = Machine.start_link Data.new "lol"
#   #   end) |> Task.await
#   #
#   #   assert Process.alive? machine
#   #
#   #   Machine.drop(machine)
#   #
#   #   assert not Process.alive? machine
#   # end
#
# end
