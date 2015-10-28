defmodule Lovmx.Test do
  use ExUnit.Case

  ## Bring in the Power.
  
  use Magic
  
  ## Examples
  
  # test "Use `Lovmx` to share code + data in Holospace." do
  #   key = Help.keycode
  #   data = Data.new key
  #
  #
  #   assert is_pid Cloud.home(data, machine).home
  # end
  
  test "Use Lovmx to Cake from Cake.kit.", do:
		assert is_binary "README.magic" |> Drive.read
  
end
