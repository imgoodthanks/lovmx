# defmodule Bot.Test do
#   use ExUnit.Case, async: false
#
#   ## Magic
#
#   test "Bot.upgrade", do:
#     assert %Data{thing: "lol"} = Bot.fresh(Data.new) |> Bot.upgrade(Data.new "lol")
#
# #   test "Use `Bot.code` to add code and make Bot ready for work.", do:
# #     assert 1 == length Bot.code(fn bot -> inspect bot end).code
# #
# #   test "Use `Bot.code` to add code and make Bot ready for work.", do:
# #     assert 1 == length Bot.code(fn bot -> inspect bot end).code
# #
# #   test "Use `Bot.code <binary>` to add code and make Bot ready for work.", do:
# #     assert %Data{} = Bot.code "@list> img"
# #
# #   test "Use `Bot.code` to add code to data and make Bot ready for work.", do:
# #     assert %Data{code: [data]} = Bot.code Data.new, fn bot -> inspect bot end
# #
# #   test "Use `Bot.code` to add code and make Bot ready for work.", do:
# #     assert 1 <= length (Data.new |> Bot.code(fn x -> x end)).code
#
# #   test "Use `Bot.start_link` to give data.home a Bot process.", do:
# #     assert is_pid Bot.start_link Data.new
# #
# #   test "Use `Bot.data` to give data.home a Bot process.", do:
# #     assert %Data{} = Bot.data Bot.start_link Data.new
# #
# #   test "Use `Bot.meta` to add code and make Bot ready for work." do
# #     bot = Bot.start_link Data.new "lol"
# #   end
# #
# #   test "Use `Bot.lock` to add code and make Bot ready for work." do
# #     bot = Bot.start_link Data.new "lol"
# #   end
# #
# #   test "Use `Bot.list` to add code and make Bot ready for work." do
# #     bot = Bot.start_link Data.new "lol"
# #   end
# #
# #   test "Use `Bot.pull` to add code and make Bot ready for work." do
# #     bot = Bot.start_link Data.new "lol"
# #   end
# #
# #   test "Use `Bot.pull` to add code and make Bot ready for work." do
# #     bot = Bot.start_link Data.new "lol"
# #   end
# #
# #   test "Use `Bot.push` to add code and make Bot ready for work." do
# #     bot = Bot.start_link Data.new "lol"
# #   end
# #
# #   test "Use `Bot.flow` to add code and make Bot ready for work." do
# #     bot = Bot.start_link Data.new "lol"
# #   end
# #
# #   # test "Use `Bot.wait` to add code and make Bot ready for work." do
# #   #
# #   # end
# #
# #   # test "Use `Bot.drop` to add code and make Bot ready for work." do
# #   #   bot = Task.async(fn ->
# #   #     bot = Bot.start_link Data.new "lol"
# #   #   end) |> Task.await
# #   #
# #   #   assert Process.alive? bot
# #   #
# #   #   Bot.drop(bot)
# #   #
# #   #   assert not Process.alive? bot
# #   # end
# #
# end
