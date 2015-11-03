defmodule Cake.Test do
  use ExUnit.Case

  # test "Use `Cake.mix <path>.cake` compile Elixir stuff" do
  #   data = %Data{
  #     pull: %{text: text}
  #   } = Cake.mix "example.cake"
  #
  #   assert is_binary(text)
  # end
  
  test "Use `Cake.mix.exs` to eval a file", do:
    assert is_list Cake.mix "example.exs"
    
  # test "Use `Cake.mix.eex` to bring static stuff into the", do:
  #   assert %Data{} = Cake.mix "example.eex"
  
  test "Use `Cake.mix.cake` to bring static stuff into the", do:
    assert %Data{} = Cake.mix "example.cake"
  
  
  test "Use `Cake.kit` to bring static stuff into the", do:
    assert is_binary Cake.kit "html/header.html"

  # test "Use `Cake.kit` to do nil stuff", do:
  #   assert %Data{} = Cake.kit Data.new, "html/header.html"
  
  
  # test "Use `Cake.magic <text>` to do data/text stuff", do:
  #   assert %Data{} = Cake.magic "lol"
  #
  # test "Use `Cake.magic` to add magic and make Bot ready for work." do
  #   data = %Data{thing: list} = Cake.magic "@list. img"
  # end
  #
  # test "Use `Cake.magic` to do cool stuff", do:
  #   assert %Data{pull: %{cake: ["<h1>lol</h1>\n"]}} = Cake.magic Data.new "# lol"
  #
  # test "Use `Cake.magic` to do nil stuff", do:
  #   assert is_nil Cake.magic nil
  
  
  test "Use `Cake.x.boot` to do nil stuff" do
    assert {data = %Data{home: home}, text} = Cake.x(Data.new, nil, :boot, nil)
    
    # did the data boot?
    assert is_pid home
  end
  
  test "Use `Cake.x.boot` to do nil stuff" do
    assert {data = %Data{pull: %{drive: list}}, text} = Cake.x(Data.new, nil, :boot, nil)
  end
  
  # # test "Use `Cake.x.data` to do nil stuff", do:
  # #   assert %Data{} = Cake.x nil
  # #
  # # test "Use `Cake.x.meta` to do nil stuff", do:
  # #   assert %Data{} = Cake.x nil
  # #
  # # test "Use `Cake.x.lock` to do nil stuff", do:
  # #   assert %Data{} = Cake.x nil
  # #
  # test "Use `Cake.x.list` to do nil stuff", do:
  #   assert is_binary (%Data{pull: %{kit: kit}} =
  #
  # # test "Use `Cake.x.pull` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"

  # # test "Use `Cake.x.code` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"
  
  # # test "Use `Cake.x.flow` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"
  
  # # test "Use `Cake.x.push` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"
  
  # # test "Use `Cake.x.wait` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"
  
  # # test "Use `Cake.x.drop` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"
  
  
  # # test "Use `Cake.x.text` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"

  # # test "Use `Cake.x.text` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"
  
  # # test "Use `Cake.x.text` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"
  
  # # test "Use `Cake.x.text` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"
  
  # # test "Use `Cake.x.text` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"
  
  
  # # test "Use `Cake.x.text` to do nil stuff", do:
  # #   assert %Data{} = Cake.x Data.new, "signal"
  
end