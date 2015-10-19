defmodule Bot.Test do
  use ExUnit.Case, async: false

  ## Magic
  test "Use `Bot.code` to add code and make Bot ready for work.",
  do: assert 1 == length Bot.code(fn bot -> inspect bot end).code

  test "Use `Bot.code` to add code to data and make Bot ready for work.",
  do: assert %Data{code: [data]} = Bot.code Data.new, fn bot -> inspect bot end

  test "Use `Bot.code` to add code and make Bot ready for work.",
  do: assert 1 <= length (Data.new |> Bot.code(fn x -> x end)).code
    
end