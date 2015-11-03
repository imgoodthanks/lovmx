require Logger

defmodule Freezer do

  @moduledoc """
  # Freezer
  ## Static Object Storage Component.

  You'll need a `secret` or an `unsecret` message
  to use this object.

  # todo: write an encrypted storage layer here
  """

  # todo: stub mimetype support.
  @static %{
    "image/jpeg"  => %{ kind: "#jpg",       extension: ".jpg"},
    "image/png"   => %{ kind: "#png",       extension: ".png"},
    "image/gif"   => %{ kind: "#gif",       extension: ".gif"},
    "unknown"     => %{ kind: "#unknown",   extension: ".x"},
  }
  
  @doc "Create a Binary box (aka large file)."
  def put(path, mime, name) do
  	{binsum, _}   = System.cmd("/usr/bin/shasum", ["-a", "512224", Help.path?(path)])
    binsum        = String.split(binsum, "  ", parts: 2) |> List.first

    # the public path
    binspace = Help.path ["bin", "#{ binsum }#{ ext(mime) }"]
    
    # write the file..
    File.write! (Help.root Help.web binspace), File.read!(path), [:write]
    
    
    # create the box
    Data.new(name, mime)
    |> Holo.move(binspace)
  end
  
  # Custom Freezer stuff.
  
  @doc "Freezer type/file extension accessor."
  def ext(mime) do
    if Map.has_key? @static, mime do
      @static[mime].extension
    else
      @static["unknown"].extension
    end
  end

end