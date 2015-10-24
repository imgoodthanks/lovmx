defmodule Cake.Test do
  use ExUnit.Case
  
  test "Use `Cake.magic` to add magic and make Bot ready for work.", do:
		assert %Data{thing: list} = Cake.magic "@list. img"

  ## Types

  test "Kind.drop", do: assert :drop == Kind.drop
  test "Kind.boot", do: assert :boot == Kind.boot
  test "Kind.lock", do: assert :lock == Kind.lock  
  test "Kind.meta", do: assert :meta == Kind.meta
  test "Kind.list", do: assert :list == Kind.list
  test "Kind.pull", do: assert :pull == Kind.pull
  test "Kind.code", do: assert :code == Kind.code
  test "Kind.push", do: assert :push == Kind.push
  test "Kind.flow", do: assert :flow == Kind.flow
  test "Kind.wait", do: assert :wait == Kind.wait

  test "Kind.data", do: assert :json == Kind.data
  test "Kind.text", do: assert :text == Kind.text
  test "Kind.link", do: assert :link == Kind.link
  test "Kind.html", do: assert :html == Kind.html
  test "Kind.blob", do: assert :blob == Kind.blob
  test "Kind.cake", do: assert :cake == Kind.cake

  test "Kind.boom", do: assert :boom == Kind.boom
 
  test "Cake does cool stuff", do:
		assert %Data{thing: "<h1>lol</h1>\n"} = Cake.magic Data.new "# lol"

  test "Cake does nil stuff", do:
		assert is_nil Cake.magic nil

  # test "Cake.magic `@boot> stuff`" do
  #     data = "@boot> lol"
  #   |> Cake.magic
  #
  #   assert is_pid data.home
  # end
  
end