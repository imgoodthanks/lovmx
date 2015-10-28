defmodule Cake.Test do
  use ExUnit.Case
  
  test "Use `Cake.magic` to add magic and make Bot ready for work.", do:
		assert %Data{thing: list} = Cake.magic "@list. img"

  test "Cake does cool stuff", do:
		assert %Data{pull: %{cake: "<h1>lol</h1>\n"}} = Cake.magic Data.new "# lol"

  test "Cake does nil stuff", do:
		assert is_nil Cake.magic nil

  # test "Cake.magic `@boot> stuff`" do
  #     data = "@boot> lol"
  #   |> Cake.magic
  #
  #   assert is_pid data.home
  # end
  
end