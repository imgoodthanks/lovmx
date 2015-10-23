defmodule Bot.Test do
  use ExUnit.Case, async: false

  ## Magic

  test "Use `Data.code` to add code and make Bot ready for work.", do:
    assert 1 == length Data.code(fn bot -> inspect bot end).code

  # test "Use `Data.code` to add code and make Bot ready for work.", do:
  #   assert 1 == length Data.code(fn bot -> inspect bot end).code
  #
  # test "Use `Data.code` to add code and make Bot ready for work.", do:
  #   assert 1 == length Data.code(fn bot -> inspect bot end).code
  #
  # test "Use `Data.code` to add code and make Bot ready for work.", do:
  #   assert 1 == length Data.code(fn bot -> inspect bot end).code
  #
  # test "Use `Data.code` to add code and make Bot ready for work.", do:
  #   assert 1 == length Data.code(fn bot -> inspect bot end).code
  #
  # test "Use `Data.code` to add code and make Bot ready for work.", do:
  #   assert 1 == length Data.code(fn bot -> inspect bot end).code
  #
  # test "Use `Data.code` to add code and make Bot ready for work.", do:
  #   assert 1 == length Data.code(fn bot -> inspect bot end).code

  test "Use `Data.code` to add code and make Bot ready for work.", do:
    assert 1 == length Data.code(fn bot -> inspect bot end).code

  test "Use `Data.code` to add code to data and make Bot ready for work.", do:
    assert %Data{code: [data]} = Data.code Data.new, fn bot -> inspect bot end

  test "Use `Data.code` to add code and make Bot ready for work.", do:
    assert 1 <= length (Data.new |> Data.code(fn x -> x end)).code

  # test "Use `Data.code` to add code and make Bot ready for work.", do:
  #   assert 1 == length Data.code(fn bot -> inspect bot end).code
  #
  # test "Use `Data.code` to add code and make Bot ready for work.", do:
  #   assert 1 == length Data.code(fn bot -> inspect bot end).code
  #
  # test "Use `Data.code` to add code and make Bot ready for work.", do:
  #   assert 1 == length Data.code(fn bot -> inspect bot end).code

end