defmodule Cake.Test do
  use ExUnit.Case
  
  test "Use `Cake.magic` to add magic and make Bot ready for work.",
  do: assert %Data{} = Cake.magic "@list. img"

  ## Types

  test "return the Kind.init type",   do: assert :init  == Kind.init
  test "return the Kind.kick type",   do: assert :kick  == Kind.kick
  test "return the Kind.meta type",   do: assert :meta  == Kind.meta
  test "return the Kind.list type",   do: assert :list  == Kind.list
  test "return the Kind.pull type",   do: assert :pull  == Kind.pull
  test "return the Kind.code type",   do: assert :code  == Kind.code
  test "return the Kind.push type",   do: assert :push  == Kind.push
  test "return the Kind.stub type",   do: assert :stub  == Kind.stub
  test "return the Kind.flow type",   do: assert :flow  == Kind.flow
  test "return the Kind.stop type",   do: assert :stop  == Kind.stop

  test "return the Kind.text type",   do: assert :text  == Kind.text
  test "return the Kind.link type",   do: assert :link  == Kind.link
  test "return the Kind.html type",   do: assert :html  == Kind.html
  test "return the Kind.blob type",   do: assert :blob  == Kind.blob
  test "return the Kind.cake type",   do: assert :cake  == Kind.cake

  test "return the Data.error type",  do: assert :error == Data.error
 
  test "Cake does cool stuff",
  do: assert "<h1>lol</h1>\n" = Data.path Kind.cake, Cake.magic Data.new "# lol"

  test "Cake does nil stuff",
  do: assert is_nil Cake.magic nil
      
  # test "#magic `@list. img` list holospace",
  # do: assert is_list Cake.magic("@list. img").native
   
end