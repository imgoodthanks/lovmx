defmodule Kind.Test do
  use ExUnit.Case
  
  ## Controls

  test "Kind.drop abstracts `nil`, `drop`, and `null` types.", do: 
    assert :drop == Kind.drop
    
  test "Kind.boot abstracts `new`, `init`, and `start` motions.", do: 
    assert :boot == Kind.boot
    
  test "Kind.lock abstracts `auth`, `secret`, and `lock` actions.", do: 
    assert :lock == Kind.lock
      
  test "Kind.meta abstracts `meta`, `extra`, and `control` type data + packets.", do: 
    assert :meta == Kind.meta
    
  test "Kind.list abstracts a `list` type.", do: 
    assert :list == Kind.list
    
  test "Kind.pull abstracts `get`, `pull`, and `read` into data motions.", do: 
    assert :pull == Kind.pull
    
  test "Kind.code abstracts executable `code` inside data.", do: 
    assert :code == Kind.code
    
  test "Kind.push abstracts `post`, `push`, and `write` motions.", do: 
    assert :push == Kind.push
    
  test "Kind.flow abstracts `active`, `running`, and `loop`ing motions.", do: 
    assert :flow == Kind.flow
    
  test "Kind.wait abstracts `promise`, `future`, `time`, or `ready` based motions.", do: 
    assert :wait == Kind.wait

  ## Prototypes

  test "Kind.data abstracts `generic data object` likely to be an Elixir term or JSON ATM.", do: 
    assert :data == Kind.data
    
  test "Kind.text abstracts `plain text` atom or binary data.", do: 
    assert :text == Kind.text
    
  test "Kind.link abstracts `link`, `href`, or `directory` style data.", do: 
    assert :link == Kind.link
    
  test "Kind.html represents `HTML` markup.", do: 
    assert :html == Kind.html
    
  test "Kind.blob represents raw `binary` or `io` data.", do: 
    assert :blob == Kind.blob
    
  test "Kind.cake represents our custom `markdown+` markup.", do: 
    assert :cake == Kind.cake

  test "Kind.boom represents an `error`, `exception`, or `kill` type.", do: 
    assert :boom == Kind.boom
    
end